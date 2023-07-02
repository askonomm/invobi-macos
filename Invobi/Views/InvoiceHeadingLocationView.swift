//
//  InvoiceHeadingLocationView.swift
//  Invobi
//
//  Created by Asko Nomm on 02.07.2023.
//

import SwiftUI

struct InvoiceHeadingLocationView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    var location: String
    @Binding var showActionsForField: InvoiceField?
    @State private var name = ""
    @State private var fields: Array<InvoiceField> = []
    
    var body: some View {
        VStack(alignment: .leading) {
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
                self.fields = getFields()
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
