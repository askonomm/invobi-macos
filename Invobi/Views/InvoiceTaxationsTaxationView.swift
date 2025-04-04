//
//  InvoiceTaxationsTaxationView.swift
//  Invobi
//
//  Created by Asko Nomm on 02.07.2023.
//

import SwiftUI

struct InvoiceTaxationsTaxationView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @ObservedObject var taxation: InvoiceTaxation
    @State private var percentage: Decimal = 0
    @State private var name = ""
    
    var body: some View {
        HStack {
            NumberFieldView(value: $percentage, onAppear: onPercentageAppear, save: savePercentage)
            .fixedSize()
            Text("%")
            .offset(x: -4)
            Spacer().frame(width: 10)
            TextFieldView(label: "Taxation name", value: $name, onAppear: onNameAppear, save: saveName)
            .fixedSize()
            Spacer()
            Text(calculateTaxTotal(invoice: invoice, percentage: percentage), format: .currency(code: invoice.currency ?? "EUR"))
                .fontWeight(.semibold)
        }
    }
    
    private func onPercentageAppear() {
        if self.taxation.percentage != nil {
            self.percentage = self.taxation.percentage! as Decimal
        }
    }
    
    private func onNameAppear() {
        if self.taxation.name != nil {
            self.name = self.taxation.name!
        }
    }
    
    private func savePercentage() {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.invoice.objectWillChange.send()
            self.taxation.percentage = (self.percentage) as NSDecimalNumber
            
            try? context.save()
        }
    }
    
    private func saveName() {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.invoice.objectWillChange.send()
            self.taxation.name = self.name
            
            try? context.save()
        }
    }
}
