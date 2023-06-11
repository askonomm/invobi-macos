import SwiftUI

struct InvoiceHeadingFromView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \InvoiceField.order, ascending: false)],
        animation: .default)
    private var fields: FetchedResults<InvoiceField>
    @State private var name = ""
    @State private var disabled = true
    
    var body: some View {
        VStack(alignment: .leading) {
            // Name
            TextFieldView(value: $name, onAppear: onAppear, save: save)
            
            Spacer().frame(height: 15)
            
            // Fields
            ForEach(self.fields) { field in
                Text("Field...")
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
    
    private func addField() -> InvoiceField {
        let newField = InvoiceField(context: context)
        newField.id = UUID.init()
        newField.invoiceId = invoice.id
        newField.label = ""
        newField.value = ""
        newField.location = "FROM"
        newField.order = 0

        do {
            try context.save()
            return newField
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct InvoiceHeadingToView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @State private var name = ""

    var body: some View {
        VStack(alignment: .leading) {
            // Name
            TextFieldView(value: $name, onAppear: onAppear, save: save)
            
            Spacer().frame(height: 15)
            
            // Fields
            Button(action: {}) {
                Text("Add field")
            }
        }
    }
    
    func onAppear() {
        self.name = self.invoice.toName != nil ? "\(self.invoice.toName!)" : ""
    }
    
    func save() {
        self.invoice.toName = self.name
        try? self.context.save()
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
                            
                            InvoiceHeadingFromView(invoice: invoice)
                            
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
                            
                            InvoiceHeadingToView(invoice: invoice)
                            
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
        .padding(.top, 7)
        .padding(.bottom, 13)
    }
}
