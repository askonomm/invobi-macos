//
//  InvoiceDiscountsDiscountView.swift
//  Invobi
//
//  Created by Asko Nomm on 04.07.2023.
//

import SwiftUI

struct InvoiceDiscountsDiscountView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @ObservedObject var discount: InvoiceDiscount
    @State private var percentage: Decimal = 0
    @State private var value: Decimal = 0
    @State private var name = ""
    
    var body: some View {
        HStack {
            NumberFieldView(value: $percentage, onAppear: onPercentageAppear, save: savePercentage)
            .fixedSize()
            Text("%")
            .offset(x: -4)
            Spacer().frame(width: 10)
            TextFieldView(label: "Discount name", value: $name, onAppear: onNameAppear, save: saveName)
            .fixedSize()
            Spacer()
            Text(calculateDiscountTotal(invoice: invoice, percentage: percentage), format: .currency(code: invoice.currency ?? "EUR"))
                .fontWeight(.semibold)
        }
    }
    
    private func onPercentageAppear() {
        if self.discount.percentage != nil {
            self.percentage = self.discount.percentage! as Decimal
        }
    }
    
    private func onNameAppear() {
        if self.discount.name != nil {
            self.name = self.discount.name!
        }
    }
    
    private func savePercentage() {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.invoice.objectWillChange.send()
            self.discount.percentage = (self.percentage) as NSDecimalNumber
            
            try? context.save()
        }
    }
    
    private func saveName() {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.invoice.objectWillChange.send()
            self.discount.name = self.name
            
            try? context.save()
        }
    }
}
