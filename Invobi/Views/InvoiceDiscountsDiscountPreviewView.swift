//
//  InvoiceDiscountsDiscountPreviewView.swift
//  Invobi
//
//  Created by Asko Nomm on 05.07.2023.
//

import SwiftUI

struct InvoiceDiscountsDiscountPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @ObservedObject var discount: InvoiceDiscount
    
    var body: some View {
        HStack {
            Text("\(discount.percentage ?? 0)")
                .font(.title3)
                .fixedSize()
            Text("%")
                .offset(x: -8)
            Text(discount.name ?? "")
                .font(.title3)
                .offset(x: -4)
            .fixedSize()
            Spacer()
            Text(calculateDiscountTotal(invoice: invoice, percentage: discount.percentage! as Decimal), format: .currency(code: invoice.currency ?? "EUR"))
                .font(.title3)
                .fontWeight(.semibold)
        }
    }
}
