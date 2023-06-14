import SwiftUI

struct InvoiceTotal: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \InvoiceItem.order, ascending: true)],
        animation: .default)
    private var items: FetchedResults<InvoiceItem>
    
    var body: some View {
        HStack {
            Text("Total".uppercased())
                .font(.callout)
                .fontWeight(.semibold)
            Spacer()
            Text(calculateSubTotal(), format: .currency(code: invoice.currency ?? "EUR"))
        }
        .padding(.top, 40)
        .padding(.horizontal, 40)
        .border(width: 1, edges: [.top], color: Color(hex: "#e5e5e5"))
    }
    
    private func getItems() -> Array<InvoiceItem> {
        return items.filter { item in
            return item.invoiceId == self.invoice.id
        }
    }
    
    private func calculateSubTotal() -> Decimal {
        return getItems().reduce(0) { result, item in
            let total: Decimal = (item.qty! as Decimal) * (item.price! as Decimal)
            
            return result + total
        }
    }
}
