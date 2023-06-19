//
//  InvoiceItemsView.swift
//  Invobi
//
//  Created by Asko Nomm on 12.06.2023.
//

import SwiftUI

struct InvoiceItemRowPreviewView: View {
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

struct InvoiceItemsPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Items")
                .font(.title2)
                .fontWeight(.light)
                .foregroundColor(Color(hex: "#999"))
                
                Spacer()
            }
            
            Spacer().frame(height: 15)
            
            HStack(alignment: .top) {
                HStack {
                    Text("Name".uppercased())
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(Color(hex: "#777"))
                    Spacer()
                }
                .frame(minWidth: 200, maxWidth: .infinity)
                
                Spacer().frame(width: 20)
                
                HStack {
                    Text("QTY".uppercased())
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(Color(hex: "#777"))
                    Spacer()
                }
                .frame(width: 65)
                
                Spacer().frame(width: 20)
                
                HStack {
                    Text("Price".uppercased())
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(Color(hex: "#777"))
                    Spacer()
                }
                .frame(width: 100)
                
                Spacer().frame(width: 20)
                
                HStack {
                    Spacer()
                    Text("Total".uppercased())
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(Color(hex: "#777"))
                }
                .frame(width: 120)
                
            }
            .frame(maxWidth: .infinity)
            
            ForEach(getItems(), id: \.self) { item in
                VStack {
                    Spacer().frame(height: 10)
                    InvoiceItemRowPreviewView(invoice: invoice, item: item, currency: invoice.currency ?? "EUR")
                }
            }
        }
        .padding(.all, 40)
        .background(Color(hex: "#fafafa"))
        .border(width: 1, edges: [.top, .bottom], color: Color(hex: "#e5e5e5"))
    }
    
    private func getItems() -> Array<InvoiceItem> {
        if invoice.items != nil {
            let items = invoice.items!.allObjects as! [InvoiceItem]
            
            return items.sorted { a, b in
                a.order < b.order
            }
        }
        
        return []
    }

}
