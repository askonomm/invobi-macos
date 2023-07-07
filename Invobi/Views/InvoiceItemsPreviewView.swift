//
//  InvoiceItemsView.swift
//  Invobi
//
//  Created by Asko Nomm on 12.06.2023.
//

import SwiftUI

struct InvoiceItemsPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Items")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(colorScheme == .dark ? Color(hex: "#eee") : Color(hex: "#333"))
                
                Spacer()
            }
            
            Spacer().frame(height: 15)
            
            HStack(alignment: .top) {
                HStack {
                    Text(String(localized: "Name").uppercased())
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#999") : Color(hex: "#777"))
                    Spacer()
                }
                .frame(minWidth: 200, maxWidth: .infinity)
                
                Spacer().frame(width: 20)
                
                HStack {
                    Text(String(localized: "QTY").uppercased())
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#999") : Color(hex: "#777"))
                    Spacer()
                }
                .frame(width: 65)
                
                Spacer().frame(width: 20)
                
                HStack {
                    Text(String(localized: "Price").uppercased())
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#999") : Color(hex: "#777"))
                    Spacer()
                }
                .frame(width: 100)
                
                Spacer().frame(width: 20)
                
                HStack {
                    Spacer()
                    Text(String(localized: "Total").uppercased())
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#999") : Color(hex: "#777"))
                }
                .frame(width: 120)
                
            }
            .frame(maxWidth: .infinity)
            
            ForEach(getItems(), id: \.self) { item in
                VStack {
                    Spacer().frame(height: 10)
                    InvoiceItemsItemPreviewView(invoice: invoice, item: item, currency: invoice.currency ?? "EUR")
                }
            }
        }
        .padding(.all, 40)
        .border(width: 1, edges: [.top, .bottom], color: colorScheme == .dark ? Color(hex: "#333") : Color(hex: "#e5e5e5"))
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
