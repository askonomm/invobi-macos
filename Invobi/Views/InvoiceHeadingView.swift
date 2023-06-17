import SwiftUI

struct InvoiceHeadingLocationView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    var location: String
    @State private var draggedField: InvoiceField?
    @State private var name = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // Name
            TextFieldView(label: "Name", value: $name, onAppear: onAppear, save: save)
            
            Spacer().frame(height: 15)
            
            // Fields
            ForEach(getFields()) { field in
                InvoiceHeadingFieldView(field: field)
                Spacer().frame(height: 10)
            }
            
            Button(action: {
                addField()
            }) {
                Text("Add field")
            }
        }
    }
    
    func onAppear() {
        self.name = self.invoice.fromName != nil ? "\(self.invoice.fromName!)" : ""
    }
    
    func save() {
        self.invoice.fromName = self.name
        try? self.context.save()
    }
    
    private func getFields() -> Array<InvoiceField> {
        var fields: Array<InvoiceField> = []
        
        if invoice.fields != nil {
            fields = invoice.fields!.allObjects as! [InvoiceField]
        }
        
        return fields.filter { field in
            return field.location == self.location
        }
    }
    
    private func addField() {
        let field = InvoiceField(context: context)
        field.label = ""
        field.value = ""
        field.location = self.location
        field.order = getFields().last != nil ? getFields().last!.order + 1 : 0
        
        invoice.addToFields(field)

        try? context.save()
    }
}

struct InvoiceHeadingView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice

    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("From")
                            .font(.title3)
                            
                            InvoiceHeadingLocationView(invoice: invoice, location: "FROM")
                            
                            Spacer()
                        }
                        Spacer()
                    }
                }
 
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("To")
                            .font(.title3)
                            
                            InvoiceHeadingLocationView(invoice: invoice, location: "TO")
                            
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
