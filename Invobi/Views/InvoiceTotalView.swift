import SwiftUI

struct InvoiceTotalView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        HStack {
            Text("Total")
            .fontWeight(.semibold)
            Spacer()
            Text(calculateTotal(), format: .currency(code: invoice.currency ?? "EUR"))
            .fontWeight(.semibold)
        }
        .padding(.top, 40)
        .padding(.horizontal, 40)
        .border(width: 1, edges: [.top], color: Color(hex: "#e5e5e5"))
    }
    
    private func calculateTotal() -> Decimal {
        if invoice.items != nil {
            let items = invoice.items!.allObjects as! [InvoiceItem]
            
            return items.reduce(0) { result, item in
                let total: Decimal = (item.qty! as Decimal) * (item.price! as Decimal)
                
                return result + total
            }
        }
        
        return 0
    }
}
