//
//  InvoiceTotalPreviewView.swift
//  Invobi
//
//  Created by Asko Nomm on 04.07.2023.
//

import SwiftUI

struct InvoiceTotalPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        HStack {
            Text("Total")
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
            Text(calculateTotal(), format: .currency(code: invoice.currency ?? "EUR"))
                .font(.title3)
                .fontWeight(.semibold)
        }
        .padding(.all, 40)
        .border(width: 1, edges: [.top], color: colorScheme == .dark ? Color(hex: "#333") : Color(hex: "#e5e5e5"))
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
