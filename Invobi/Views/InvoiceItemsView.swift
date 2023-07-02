//
//  InvoiceItemsView.swift
//  Invobi
//
//  Created by Asko Nomm on 12.06.2023.
//

import SwiftUI

struct InvoiceItemsView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    @State private var showActionsForItem: InvoiceItem?
    @State private var items: Array<InvoiceItem> = []

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
                    Text("Name".uppercased())
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#999") : Color(hex: "#777"))
                    Spacer()
                }
                .frame(minWidth: 200, maxWidth: .infinity)
                
                Spacer().frame(width: 20)
                
                HStack {
                    Text("QTY".uppercased())
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#999") : Color(hex: "#777"))
                    Spacer()
                }
                .frame(width: 65)
                
                Spacer().frame(width: 20)
                
                HStack {
                    Text("Price".uppercased())
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#999") : Color(hex: "#777"))
                    Spacer()
                }
                .frame(width: 100)
                
                Spacer().frame(width: 20)
                
                HStack {
                    Spacer()
                    Text("Total".uppercased())
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#999") : Color(hex: "#777"))
                }
                .frame(width: 120)
                
            }
            .frame(maxWidth: .infinity)
            
            ForEach(items) { item in
                Spacer().frame(height: 15)
                
                ZStack {
                    InvoiceItemsItemView(invoice: invoice, item: item, currency: invoice.currency ?? "EUR")

                    if getItems().count > 1 && showActionsForItem == item {
                        InvoiceItemsItemActionsView(item: item,
                                               moveUp: moveUp,
                                               moveDown: moveDown,
                                               delete: delete,
                                               isFirst: isFirst(item),
                                               isLast: isLast(item))
                    }
                }
                .onHover { over in
                    withAnimation(.easeInOut(duration: 0.08)) {
                        if over {
                            showActionsForItem = item
                        } else {
                            showActionsForItem = .none
                        }
                    }
                }
                .offset(x: -24)
            }
            
            Spacer().frame(height: 15)
            
            Button(action: addItem) {
                Text("Add item")
            }
        }
        .padding(.all, 40)
        .border(width: 1, edges: [.top, .bottom], color: colorScheme == .dark ? Color(hex: "#333") : Color(hex: "#e5e5e5"))
        .onAppear {
            self.items = getItems()
        }
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
    
    private func addItem() {
        withAnimation(.easeInOut(duration: 0.08)) {
            let item = InvoiceItem(context: context)
            item.name = ""
            item.qty = 1
            item.price = 0
            item.order = getItems().last != nil ? getItems().last!.order + 1 : 0
            
            invoice.addToItems(item)
            items.append(item)
            
            try? context.save()
        }
    }
    
    private func moveUp(_ item: InvoiceItem) {
        withAnimation(.easeInOut(duration: 0.08)) {
            let currentOrder = item.order
            let newOrder = currentOrder - 1
            
            let replacingItem = items.first { item in
                return item.order == newOrder
            }
            
            item.order = newOrder
            items[Int(currentOrder)] = replacingItem!
            items[Int(newOrder)] = item
            replacingItem!.order = currentOrder
            
            self.showActionsForItem = .none
            
            try? context.save()
        }
    }
    
    private func moveDown(_ item: InvoiceItem) {
        withAnimation(.easeInOut(duration: 0.08)) {
            let currentOrder = item.order
            let newOrder = currentOrder + 1
            
            let replacingItem = items.first { item in
                return item.order == newOrder
            }
            
            item.order = newOrder
            items[Int(currentOrder)] = replacingItem!
            items[Int(newOrder)] = item
            replacingItem!.order = currentOrder
            
            self.showActionsForItem = .none
            
            try? context.save()
        }
    }
    
    private func delete(_ item: InvoiceItem) {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.context.delete(item)
            
            // Remove item
            self.items.removeAll { i in
                return i.order == item.order
            }
            
            // Re-order all items because there can now be a gap
            items.indices.forEach { index in
                let f = items[index]
                f.order = Int32(index)
            }
            
            self.showActionsForItem = .none
            
            try? context.save()
        }
    }
    
    private func isFirst(_ item: InvoiceItem) -> Bool {
        return items.first == item
    }
    
    private func isLast(_ item: InvoiceItem) -> Bool {
        return items.last == item
    }
}
