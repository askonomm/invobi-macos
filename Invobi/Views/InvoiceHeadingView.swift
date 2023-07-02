import SwiftUI
import ReordableViews

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
                                        delete: delete)
                Spacer().frame(height: 10)
            }
        
            Button(action: {
                addField()
            }) {
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
            field.order = getFields().last != nil ? getFields().last!.order + 1 : 0
            
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
            self.fields.removeAll { f in
                return f.order == field.order
            }
            
            self.showActionsForField = .none
            
            try? context.save()
        }
    }
}

struct InvoiceHeadingView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    @State private var showActionsForField: InvoiceField?

    let columns = [
        GridItem(.flexible(), spacing: 30),
        GridItem(.flexible(), spacing: 30)
    ]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("From")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(colorScheme == .dark ? Color(hex: "#eee") : Color(hex: "#333"))
                            
                            InvoiceHeadingLocationView(invoice: invoice, location: "FROM", showActionsForField: $showActionsForField)
                            
                            Spacer()
                        }
                        Spacer()
                    }
                }
 
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("To")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(colorScheme == .dark ? Color(hex: "#eee") : Color(hex: "#333"))
                            
                            InvoiceHeadingLocationView(invoice: invoice, location: "TO", showActionsForField: $showActionsForField)
                            
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 40)
    }
}
