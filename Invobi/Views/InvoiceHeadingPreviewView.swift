import SwiftUI

struct InvoiceHeadingLocationPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    var location: String
    @State private var draggedField: InvoiceField?
    @State private var name = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // Name
            if location == "FROM" && invoice.fromName != nil {
                Text(invoice.fromName!)
                    .font(.title2)
            }
            
            if location == "TO" && invoice.toName != nil {
                Text(invoice.toName!)
                    .font(.title2)
            }
            
            // Fields
            ForEach(getFields()) { field in
                Spacer().frame(height: 20)
                InvoiceHeadingFieldPreviewView(field: field)
            }
        }
    }

    private func getFields() -> Array<InvoiceField> {
        var fields: Array<InvoiceField> = []
        
        if invoice.fields != nil {
            fields = invoice.fields!.allObjects as! [InvoiceField]
        }
        
        fields = fields.filter { field in
            return field.location == self.location
        }
        
        return fields.sorted { a, b in
            a.order < b.order
        }
    }
}

struct InvoiceHeadingPreviewView: View {
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
                            .font(.title2)
                            .fontWeight(.light)
                            .foregroundColor(Color(hex: "#999"))
                            
                            Spacer().frame(height: 10)
                            
                            InvoiceHeadingLocationPreviewView(invoice: invoice, location: "FROM")
                            
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
                            .fontWeight(.light)
                            .foregroundColor(Color(hex: "#999"))
                            
                            Spacer().frame(height: 10)
                            
                            InvoiceHeadingLocationPreviewView(invoice: invoice, location: "TO")
                            
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
