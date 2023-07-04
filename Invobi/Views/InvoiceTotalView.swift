import SwiftUI

struct InvoiceTotalView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        HStack {
            Text("Total")
                .fontWeight(.semibold)
            Spacer()
            Text(calculateTotal(invoice), format: .currency(code: invoice.currency ?? "EUR"))
                .fontWeight(.semibold)
        }
        .padding(.all, 40)
        .border(width: 1, edges: [.top], color: colorScheme == .dark ? Color(hex: "#333") : Color(hex: "#e5e5e5"))
    }
}
