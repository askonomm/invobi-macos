//
//  InvoiceItemsView.swift
//  Invobi
//
//  Created by Asko Nomm on 12.06.2023.
//

import SwiftUI

struct InvoiceItemRowView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    @ObservedObject var item: InvoiceItem
    var currency: String
    @State private var itemName = ""
    @State private var itemQTY: Decimal = 0
    @State private var itemPrice: Decimal = 0
    @State private var itemTotal: Decimal = 0
    
    var body: some View {
        TextFieldView(value: $itemName, onAppear: onItemNameAppear, save: saveItemName)
        .frame(minWidth: 200, maxWidth: .infinity)
        Spacer().frame(width: 20)
        NumberFieldView(value: $itemQTY, onAppear: onItemQTYAppear, save: saveItemQTY)
        .frame(width: 65)
        Spacer().frame(width: 20)
        NumberFieldView(value: $itemPrice, onAppear: onItemPriceAppear, save: saveItemPrice)
        .frame(width: 100)
        Spacer().frame(width: 20)
        HStack {
            Spacer()
            Text(self.itemTotal, format: .currency(code: currency))
            .fontWeight(.semibold)
            .lineLimit(1)
        }
        .frame(width: 120)
    }
    
    private func onItemNameAppear() {
        DispatchQueue.main.async {
            if self.item.name != nil {
                self.itemName = self.item.name!
            }
        }
    }
    
    private func onItemQTYAppear() {
        DispatchQueue.main.async {
            if self.item.qty != nil {
                self.itemQTY = self.item.qty! as Decimal
            }
            
            calculateTotal()
        }
    }
    
    private func onItemPriceAppear() {
        DispatchQueue.main.async {
            if self.item.price != nil {
                self.itemPrice = self.item.price! as Decimal
            }
            
            calculateTotal()
        }
    }
    
    private func saveItemName() {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.item.name = self.itemName
            try? context.save()
        }
    }
    
    private func saveItemQTY() {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.invoice.objectWillChange.send()
            self.item.qty = (self.itemQTY) as NSDecimalNumber
            try? context.save()
            
            calculateTotal()
        }
    }
    
    private func saveItemPrice() {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.invoice.objectWillChange.send()
            self.item.price = (self.itemPrice) as NSDecimalNumber
            try? context.save()
            
            calculateTotal()
        }
    }
    
    private func calculateTotal() {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.itemTotal = self.itemQTY * self.itemPrice
        }
    }
}

struct InvoiceItemsView: View {
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
            
            ForEach(getItems(), id: \.self) { item in
                Spacer().frame(height: 15)
                
                ZStack {
                    HStack {
                        InvoiceItemRowView(invoice: invoice, item: item, currency: invoice.currency ?? "EUR")
                    }

                    HStack {
                        if getItems().count > 1 {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.08)) {
                                    context.delete(item)
                                    try? context.save()
                                }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                            }
                            .buttonStyle(.plain)
                            .offset(x: -8, y: -14)
                        }

                        Spacer()
                    }
                }
            }
            
            Spacer().frame(height: 15)
            
            Button(action: addItem) {
                Text("Add item")
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
    
    private func addItem() {
        withAnimation(.easeInOut(duration: 0.08)) {
            let item = InvoiceItem(context: context)
            item.name = ""
            item.qty = 1
            item.price = 0
            item.order = getItems().last != nil ? getItems().last!.order + 1 : 0
            
            invoice.addToItems(item)
            
            try? context.save()
        }
    }
}
