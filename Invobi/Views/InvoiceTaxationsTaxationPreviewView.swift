//
//  InvoiceTaxationsTaxationPreviewView.swift
//  Invobi
//
//  Created by Asko Nomm on 05.07.2023.
//

import SwiftUI

struct InvoiceTaxationsTaxationPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @ObservedObject var taxation: InvoiceTaxation
    
    var body: some View {
        HStack {
            Text("\(taxation.percentage ?? 0)")
                .font(.title3)
                .fixedSize()
            Text("%")
                .offset(x: -8)
            Text(taxation.name ?? "")
                .font(.title3)
                .offset(x: -4)
            .fixedSize()
            Spacer()
            Text(calculateTaxTotal(invoice: invoice, percentage: taxation.percentage! as Decimal), format: .currency(code: invoice.currency ?? "EUR"))
                .font(.title3)
                .fontWeight(.semibold)
        }
    }
}
