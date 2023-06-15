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
    @State private var val: Decimal = 0
    @State private var valType = "PERCENTAGE"
    @State private var name = ""
    
    var body: some View {
        HStack {
            NumberFieldView(value: $val, onAppear: onValAppear, save: saveVal)
            .fixedSize()
            Text("%")
            .offset(x: -4)
            Spacer().frame(width: 15)
            TextFieldView(label: "Name", value: $name, onAppear: onNameAppear, save: saveName)
            .fixedSize()
            Spacer()
            Text(calculateTaxTotal(), format: .currency(code: invoice.currency ?? "EUR"))
                .fontWeight(.semibold)
        }
        .onAppear {
            if self.taxation.valType != nil {
                self.valType = self.taxation.valType!
            }
        }
    }
    
    private func onValAppear() {
        if self.taxation.val != nil {
            self.val = self.taxation.val! as Decimal
        }
    }
    
    private func onNameAppear() {
        if self.taxation.name != nil {
            self.name = self.taxation.name!
        }
    }
    
    private func saveVal() {
        self.invoice.objectWillChange.send()
        self.taxation.val = (self.val) as NSDecimalNumber
        
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
        
        if self.valType == "PERCENTAGE" {
            // todo: substract discounts from subtotal for future if there are discounts
            return (self.val / 100) * subTotal
        }
        
        return self.val
    }
}

struct InvoiceTaxationsView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice

    var body: some View {
        VStack {
            ForEach(getTaxations(), id: \.self) { taxation in
                InvoiceTaxationView(invoice: invoice, taxation: taxation)
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
        if invoice.taxations != nil {
            return invoice.taxations!.allObjects as! [InvoiceTaxation]
        }
        
        return []
    }
    
    private func addTaxation() {
        let taxation = InvoiceTaxation(context: context);
        taxation.name = ""
        taxation.val = 0
        taxation.valType = "PERCENTAGE"
        taxation.order = getTaxations().last != nil ? getTaxations().last!.order + 1 : 0
    
        invoice.addToTaxations(taxation)
        
        try? context.save()
    }
}
