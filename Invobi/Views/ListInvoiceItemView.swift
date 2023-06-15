import SwiftUI

struct ListInvoiceItemViewHeadingView: View {
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        HStack(alignment: .top) {
            Text("Invoice #")
                .font(.title3)
                .fontWeight(.light)
                .foregroundColor(getStatusAltColor(status: self.invoice.status))
                .opacity(0.8)
            Text("\(invoice.nr != nil ? invoice.nr! : "")")
                .font(.title3)
                .offset(x: -7)
                .lineLimit(1)
                .foregroundColor(getStatusAltColor(status: self.invoice.status))
            Spacer()
        }.frame(maxWidth: .infinity)
    }
}

struct ListInvoiceItemViewFooterView: View {
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        HStack(alignment: .top) {
            Text("$500")
            .foregroundColor(getStatusAltColor(status: self.invoice.status))
            
            Spacer()
           
            if self.invoice.status != nil && self.invoice.dueDate != nil && (self.invoice.status == "UNPAID" || self.invoice.status == "OVERDUE") {
                Text(getDueInText(date: self.invoice.dueDate!).uppercased())
                    .font(.caption)
                    .foregroundColor(getStatusAltColor(status: self.invoice.status))
                    .offset(y: 2)
                
                Spacer().frame(width:10)
            }
            
            Text(self.invoice.status != nil ? self.invoice.status!.uppercased() : "DRAFT")
                .font(.caption)
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .foregroundColor(getStatusAltColor(status: self.invoice.status))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(getStatusAltColor(status: self.invoice.status)))
                .offset(y:-1)
        }.frame(maxWidth: .infinity)
    }
}

struct ListInvoiceItemView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    var onSelect: (_ invoice: Invoice) -> Void
    
    var body: some View {
        Button(action: navigateToInvoice) {
            VStack(alignment: .leading) {
                ListInvoiceItemViewHeadingView(invoice: invoice)
                Spacer().frame(height: 15)
                ListInvoiceItemViewFooterView(invoice: invoice)
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, 20)
            .padding(.trailing, 15)
            .padding(.top, 15)
            .padding(.bottom, 13)
            .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .onAppear(perform: checkIfOverdue)
        .buttonStyle(.plain)
        .background(getStatusColor(status: self.invoice.status))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: Color(hex: "#f2f2f2"), radius: 2, x: 0, y: 3)
        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous)
            .stroke(getStatusBorderColor(status: self.invoice.status)))
    }
    
    // Navigate to the invoice.
    private func navigateToInvoice() {
        checkIfOverdue()
        onSelect(invoice)
    }
    
    // Check if the invoice is overdue, and if it is, change the status to OVERDUE.
    private func checkIfOverdue() {
        print(self.invoice)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let status = self.invoice.status != nil ? self.invoice.status : "DRAFT"
            
            if self.invoice.dueDate != nil && status != "DRAFT" && status != "PAID" {
                if getDayDiff(Date.now, self.invoice.dueDate!) < 0 {
                    self.invoice.status = "OVERDUE"
                    try? self.context.save()
                }
            }
        }
    }
}
