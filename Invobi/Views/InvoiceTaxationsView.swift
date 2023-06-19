//
//  InvoiceTaxations.swift
//  Invobi
//
//  Created by Asko Nomm on 14.06.2023.
//

import SwiftUI

struct InvoiceTaxationView: View {
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
            Text(calculateTaxTotal(), format: .currency(code: invoice.currency ?? "EUR"))
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
        self.invoice.objectWillChange.send()
        self.taxation.percentage = (self.percentage) as NSDecimalNumber
        
        try? context.save()
    }
    
    private func saveName() {
        self.invoice.objectWillChange.send()
        self.taxation.name = self.name
        
        try? context.save()
    }
    
    private func calculateTaxTotal() -> Decimal {
        var items: Array<InvoiceItem> = []
        
        if invoice.items != nil {
            items = invoice.items!.allObjects as! [InvoiceItem]
        }
        
        let subTotal: Decimal = items.reduce(0) { result, item in
            let total: Decimal = (item.qty! as Decimal) * (item.price! as Decimal)
            
            return result + total
        }
        
        return (self.percentage / 100) * subTotal
    }
}

struct InvoiceTaxationsView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice

    var body: some View {
        VStack {
            ForEach(getTaxations(), id: \.self) { taxation in
                ZStack {
                    InvoiceTaxationView(invoice: invoice, taxation: taxation)
                    
                    HStack {
                        Button(action: {
                            context.delete(taxation)
                            try? context.save()
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                        }
                        .buttonStyle(.plain)
                        .offset(x:-26)
                        
                        Spacer()
                    }
                }
            }
            
            if getTaxations().count > 0 {
                Spacer().frame(height: 15)
            }
            
            HStack {
                Button(action: addTaxation) {
                    Text("Add taxation")
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 40)
    }
    
    private func getTaxations() -> Array<InvoiceTaxation> {
        var taxations: Array<InvoiceTaxation> = []
        
        if invoice.taxations != nil {
            taxations = invoice.taxations!.allObjects as! [InvoiceTaxation]
        }
        
        return taxations.sorted { a, b in
            return a.order < b.order
        }
    }
    
    private func addTaxation() {
        let taxation = InvoiceTaxation(context: context);
        taxation.name = ""
        taxation.percentage = 0
        taxation.order = getTaxations().last != nil ? getTaxations().last!.order + 1 : 0
    
        invoice.addToTaxations(taxation)
        
        try? context.save()
    }
}
