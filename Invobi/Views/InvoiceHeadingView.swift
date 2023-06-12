import SwiftUI

struct InvoiceHeadingLocationView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \InvoiceField.order, ascending: true)],
        animation: .default)
    private var fields: FetchedResults<InvoiceField>
    var location: String
    @State private var draggedField: InvoiceField?
    @State private var name = ""
    @State private var disabled = true
    
    var body: some View {
        VStack(alignment: .leading) {
            // Name
            TextFieldView(value: $name, onAppear: onAppear, save: save)
            
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
        return fields.filter { field in
            return field.location == self.location && field.invoiceId == self.invoice.id
        }
    }
    
    private func addField() {
        let newField = InvoiceField(context: context)
        newField.id = UUID.init()
        newField.invoiceId = invoice.id
        newField.label = ""
        newField.value = ""
        newField.location = self.location
        newField.order = getFields().last != nil ? getFields().last!.order + 1 : 0

        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct InvoiceHeadingView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @State private var showingFromPopover = false
    @State private var showingToPopover = false

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
                .sheet(isPresented: $showingToPopover) {
                    Text("tesad")
                }
            }
        }
        .padding(.horizontal, 40)
    }
}
