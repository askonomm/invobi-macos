//
//  InvoiceTaxations.swift
//  Invobi
//
//  Created by Asko Nomm on 14.06.2023.
//

import SwiftUI

struct InvoiceTaxationPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @ObservedObject var taxation: InvoiceTaxation
    
    var body: some View {
        HStack {
            Text("\(taxation.percentage ?? 0)")
                .fixedSize()
            Text("%")
                .offset(x: -8)
            Text(taxation.name ?? "")
                .offset(x: -4)
            .fixedSize()
            Spacer()
            Text(calculateTaxTotal(), format: .currency(code: invoice.currency ?? "EUR"))
                .fontWeight(.semibold)
        }
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
        
        var percentage: Decimal = 0
        
        if self.taxation.percentage != nil {
            percentage = self.taxation.percentage! as Decimal
        }
        
        return (percentage / 100) * subTotal
    }
}

struct InvoiceTaxationsPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice

    var body: some View {
        VStack {
            ForEach(getTaxations(), id: \.self) { taxation in
                Spacer().frame(height: 15)
                InvoiceTaxationPreviewView(invoice: invoice, taxation: taxation)
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
}
