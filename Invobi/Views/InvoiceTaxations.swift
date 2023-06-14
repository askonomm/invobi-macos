//
//  InvoiceTaxations.swift
//  Invobi
//
//  Created by Asko Nomm on 14.06.2023.
//

import SwiftUI

struct InvoiceTaxations: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \InvoiceItem.order, ascending: true)],
        animation: .default)
    private var items: FetchedResults<InvoiceItem>
    
    var body: some View {
        HStack {
            Button(action: {}) {
                Text("Add taxation")
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
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
