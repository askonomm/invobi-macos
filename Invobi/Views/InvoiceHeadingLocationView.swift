//
//  InvoiceHeadingLocationView.swift
//  Invobi
//
//  Created by Asko Nomm on 02.07.2023.
//

import SwiftUI

struct ImageView: View {
    var imageData: Data
    
    var body: some View {
        if let image = NSImage(data: imageData) {
            Image(nsImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: 45)
        }
    }
}

struct FileView: View {
    var onSelect: (_ path: String) -> Void
    
    var body: some View {
        Button("Select image") {
            let openPanel = NSOpenPanel()
            openPanel.prompt = "Select image"
            openPanel.allowsMultipleSelection = false
                openPanel.canChooseDirectories = false
                openPanel.canCreateDirectories = false
                openPanel.canChooseFiles = true
                openPanel.allowedContentTypes = [.image]
                openPanel.begin { (result) -> Void in
                    if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                        let selectedPath = openPanel.url!.path
                        onSelect(selectedPath)
                    }
                }
        }
    }
}

struct InvoiceHeadingLocationView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    var location: String
    @Binding var showActionsForField: InvoiceField?
    @State private var imageData: Data?
    @State private var name = ""
    @State private var fields: Array<InvoiceField> = []
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image
            if imageData != nil {
                ZStack(alignment: .topLeading) {
                    ImageView(imageData: imageData!)
                    
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.08)) {
                                imageData = .none
                                
                                if location == "FROM" {
                                    invoice.fromImage = .none
                                }
                                
                                if location == "TO" {
                                    invoice.toImage = .none
                                }
                                
                                try? context.save()
                            }
                        }) {
                            Label("Remove image", systemImage: "minus.circle.fill")
                                .foregroundColor(.red)
                                .labelStyle(.iconOnly)
                        }
                        .buttonStyle(.plain)
                        .offset(x: -6, y: -6)
                        
                        Spacer()
                    }
                }
            } else {
                FileView(onSelect: { path in
                    if let image = NSImage(byReferencingFile: path) {
                        withAnimation(.easeInOut(duration: 0.08)) {
                            imageData = image.tiffRepresentation!
                            
                            if location == "FROM" {
                                invoice.fromImage = imageData
                                try? context.save()
                            }
                            
                            if location == "TO" {
                                invoice.toImage = imageData
                                try? context.save()
                            }
                        }
                    }
                })
            }
            
            Spacer().frame(height: 15)
            
            // Name
            TextFieldView(label: "Name", value: $name, onAppear: onNameAppear, save: saveName)
            
            Spacer().frame(height: 15)
            
            // Fields
            ForEach(fields) { field in
                InvoiceHeadingFieldView(fields: getFields(),
                                        field: field,
                                        showActionsForField: $showActionsForField,
                                        moveUp: moveUp,
                                        moveDown: moveDown,
                                        delete: delete,
                                        isFirst: isFirst(field),
                                        isLast: isLast(field))
                Spacer().frame(height: 10)
            }
            
            Button(action: addField) {
                Text("Add field")
            }
        
            .onAppear {
                withAnimation(.easeInOut(duration: 0.08)) {
                    self.fields = getFields()
                    
                    if location == "FROM" && invoice.fromImage != nil {
                        imageData = invoice.fromImage!
                    }
                    
                    if location == "TO" && invoice.toImage != nil {
                        imageData = invoice.toImage!
                    }
                }
            }
        }
    }
    
    func onNameAppear() {
        if self.location == "FROM" {
            self.name = self.invoice.fromName != nil ? self.invoice.fromName! : ""
        }
        
        if self.location == "TO" {
            self.name = self.invoice.toName != nil ? self.invoice.toName! : ""
        }
    }
    
    func saveName() {
        if self.location == "FROM" {
            self.invoice.fromName = self.name
        }
        
        if self.location == "TO" {
            self.invoice.toName = self.name
        }
        
        try? self.context.save()
    }
    
    private func getFields() -> Array<InvoiceField> {
        var fields: Array<InvoiceField> = []
        
        if invoice.fields != nil {
            fields = invoice.fields!.allObjects as! [InvoiceField]
        }
        
        let filteredFields = fields.filter { field in
            return field.location == self.location
        }
        
        return filteredFields.sorted { a, b in
            return a.order < b.order
        }
    }
    
    private func addField() {
        withAnimation(.easeInOut(duration: 0.08)) {
            let field = InvoiceField(context: context)
            field.label = ""
            field.value = ""
            field.location = self.location
            field.order = fields.last != nil ? fields.last!.order + 1 : 0
            
            invoice.addToFields(field)
            fields.append(field)
            
            try? context.save()
        }
    }
    
    private func moveUp(_ field: InvoiceField) {
        withAnimation(.easeInOut(duration: 0.08)) {
            let currentOrder = field.order
            let newOrder = currentOrder - 1
            
            let replacingField = fields.first { field in
                return field.order == newOrder
            }
            
            field.order = newOrder
            fields[Int(currentOrder)] = replacingField!
            fields[Int(newOrder)] = field
            replacingField!.order = currentOrder
            
            self.showActionsForField = .none
            
            try? context.save()
        }
    }
    
    private func moveDown(_ field: InvoiceField) {
        withAnimation(.easeInOut(duration: 0.08)) {
            let currentOrder = field.order
            let newOrder = currentOrder + 1
            
            let replacingField = fields.first { field in
                return field.order == newOrder
            }
            
            field.order = newOrder
            fields[Int(currentOrder)] = replacingField!
            fields[Int(newOrder)] = field
            replacingField!.order = currentOrder
            
            self.showActionsForField = .none
            
            try? context.save()
        }
    }
    
    private func delete(_ field: InvoiceField) {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.context.delete(field)
            
            // Remove field
            self.fields.removeAll { f in
                return f.order == field.order
            }
            
            // Re-order all fields because there can now be a gap
            fields.indices.forEach { index in
                let f = fields[index]
                f.order = Int32(index)
            }
            
            self.showActionsForField = .none
            
            try? context.save()
        }
    }
    
    private func isFirst(_ field: InvoiceField) -> Bool {
        return fields.first == field
    }
    
    private func isLast(_ field: InvoiceField) -> Bool {
        return fields.last == field
    }
}
