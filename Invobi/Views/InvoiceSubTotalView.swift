//
//  InvoiceSubTotal.swift
//  Invobi
//
//  Created by Asko Nomm on 13.06.2023.
//

import SwiftUI

struct InvoiceSubTotalView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice

    var body: some View {
        HStack {
            Text("Subtotal")
            .fontWeight(.semibold)
            Spacer()
            Text(calculateSubTotal(), format: .currency(code: invoice.currency ?? "EUR"))
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
