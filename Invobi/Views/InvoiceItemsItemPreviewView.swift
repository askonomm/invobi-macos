//
//  InvoiceItemsItemPreviewView.swift
//  Invobi
//
//  Created by Asko Nomm on 07.07.2023.
//

import SwiftUI

struct InvoiceItemsItemPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @ObservedObject var item: InvoiceItem
    var currency: String
    
    var body: some View {
        HStack(alignment: .top) {
            HStack(alignment: .top) {
                Text(item.name ?? "")
                    .font(.title3)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .frame(minWidth: 200, maxWidth: .infinity)
            
            Spacer().frame(width: 20)
            
            HStack(alignment: .top) {
                Text((item.qty ?? 0) as Decimal, format: .number)
                    .font(.title3)
                
                Spacer()
            }
            .frame(width: 65)
            
            Spacer().frame(width: 20)
            
            HStack(alignment: .top) {
                Text((item.price ?? 0) as Decimal, format: .currency(code: currency))
                    .font(.title3)
                
                Spacer()
            }
            .frame(width: 100)
            
            Spacer().frame(width: 20)
            
            HStack(alignment: .top) {
                Spacer()
                Text(calculateTotal(), format: .currency(code: currency))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
            .frame(width: 120)
        }
    }
    
    private func calculateTotal() -> Decimal {
        var qty: Decimal = 0
        var price: Decimal = 0
        
        if self.item.qty != nil {
            qty = self.item.qty! as Decimal
        }
        
        if self.item.price != nil {
            price = self.item.price! as Decimal
        }
        
        return qty * price
    }
}
