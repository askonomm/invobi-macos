//
//  InvoiceItemsItemView.swift
//  Invobi
//
//  Created by Asko Nomm on 02.07.2023.
//

import SwiftUI

struct InvoiceItemsItemView: View {
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
        HStack {
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
        .offset(x: 24)
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
