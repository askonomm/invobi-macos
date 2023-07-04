//
//  InvoicesSectionInvoiceView.swift
//  Invobi
//
//  Created by Asko Nomm on 02.07.2023.
//

import SwiftUI

struct InvoicesSectionInvoiceView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.08)) {
                appState.selectedInvoice = invoice
                appState.view = Views.invoice
            }
        }) {
            VStack(spacing: 0) {
                Spacer().frame(height: 8)
                HStack {
                    HStack {
                        Text("#")
                            .font(.title3)
                            .foregroundColor(Color.gray)
                            .fontWeight(.light)
                        
                        Text(invoice.nr ?? "")
                            .font(.title3)
                            .offset(x: -5)
                        
                        Spacer().frame(width: 8)
                        
                        Text(calculateTotal(invoice), format: .currency(code: invoice.currency ?? "EUR"))
                            .fontWeight(.light)
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    if invoice.status != "DRAFT" && invoice.status != "PAID" {
                        Text("Due \(displayDate(invoice.dueDate ?? Date.now))")
                            .opacity(0.5)
                    }
                }
                Spacer().frame(height: 10)
            }
            
            .accessibilityLabel("Invoice \(invoice.nr ?? "")")
            .border(width: 1, edges: [.bottom], color: colorScheme == .dark ? Color(hex: "#333") : Color(hex: "#e5e5e5"))
            .contentShape(Rectangle())
            .onAppear {
                if invoice.dueDate != nil {
                    if getDayDiff(invoice.dueDate!, Date.now) > 0 {
                        self.invoice.status = "OVERDUE"
                        try? context.save()
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private func calculateTotal(_ invoice: Invoice) -> Decimal {
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
