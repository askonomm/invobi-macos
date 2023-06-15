//
//  InvoiceItemsView.swift
//  Invobi
//
//  Created by Asko Nomm on 12.06.2023.
//

import SwiftUI

struct InvoiceItemRowView: View {
    @Environment(\.managedObjectContext) private var context
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
        self.item.name = self.itemName
        try? context.save()
    }
    
    private func saveItemQTY() {
        self.item.qty = (self.itemQTY) as NSDecimalNumber
        try? context.save()
        
        calculateTotal()
    }
    
    private func saveItemPrice() {
        self.item.price = (self.itemPrice) as NSDecimalNumber
        try? context.save()
        
        calculateTotal()
    }
    
    private func calculateTotal() {
        self.itemTotal = self.itemQTY * self.itemPrice
    }
}

struct InvoiceItemsView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \InvoiceItem.order, ascending: true)],
        animation: .default)
    private var items: FetchedResults<InvoiceItem>
    @ObservedObject var invoice: Invoice

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Items".uppercased())
                .font(.callout)
                .fontWeight(.semibold)
                
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
            
            ForEach(getItems()) { item in
                ZStack {
                    HStack {
                        InvoiceItemRowView(item: item, currency: invoice.currency ?? "EUR")
                    }
                    
                    HStack {
                        if countItems() > 1 {
                            Button(action: {
                                context.delete(item)
                                try? context.save()
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                            }
                            .buttonStyle(.plain)
                            .offset(x:-26)
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
        .background(Color(hex: "#fafafa"))
        .border(width: 1, edges: [.top, .bottom], color: Color(hex: "#e5e5e5"))
    }
    
    private func getItems() -> Array<InvoiceItem> {
        return items.filter { item in
            return item.invoiceId == self.invoice.id
        }
    }
    
    private func countItems() -> Int {
        return getItems().count
    }
    
    private func addItem() {
        let item = InvoiceItem(context: context)
        item.id = UUID.init()
        item.invoiceId = invoice.id
        item.name = ""
        item.qty = 1
        item.price = 0
        item.order = getItems().last != nil ? getItems().last!.order + 1 : 0

        try? context.save()
    }
}
