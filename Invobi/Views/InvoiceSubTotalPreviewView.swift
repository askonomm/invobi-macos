//
//  InvoiceSubTotalPreviewView.swift
//  Invobi
//
//  Created by Asko Nomm on 04.07.2023.
//

import SwiftUI

struct InvoiceSubTotalPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice

    var body: some View {
        HStack {
            Text("Subtotal")
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
            Text(calculateSubTotal(), format: .currency(code: invoice.currency ?? "EUR"))
                .font(.title3)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 40)
    }
    
    private func calculateSubTotal() -> Decimal {
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
