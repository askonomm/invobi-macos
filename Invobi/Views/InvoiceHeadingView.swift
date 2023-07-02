import SwiftUI
import ReordableViews

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
