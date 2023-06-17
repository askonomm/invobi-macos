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
        if invoice.items == nil {
            return 0
        }

        let items = invoice.items!.allObjects as! [InvoiceItem]
        
        // get subtotal
        let subTotal: Decimal = items.reduce(0) { result, item in
            let total: Decimal = (item.qty! as Decimal) * (item.price! as Decimal)
            
            return result + total
        }
        
        // get total taxed
        var taxedTotal: Decimal = 0
        
        if invoice.taxations != nil {
            let taxations = invoice.taxations!.allObjects as! [InvoiceTaxation]
            
            taxedTotal = taxations.reduce(0) { result, item in
                return result + ((item.percentage! as Decimal / 100) * subTotal)
            }
        }
        
        return subTotal + taxedTotal
    }
}
