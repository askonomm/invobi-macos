//
//  InvoiceDiscountsPreviewView.swift
//  Invobi
//
//  Created by Asko Nomm on 05.07.2023.
//

import SwiftUI

struct InvoiceDiscountsPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice

    var body: some View {
        VStack {
            ForEach(getDiscounts(), id: \.self) { discount in
                Spacer().frame(height: 15)
                InvoiceDiscountsDiscountPreviewView(invoice: invoice, discount: discount)
            }
        }
        .padding(.horizontal, 40)
    }
    
    private func getDiscounts() -> Array<InvoiceDiscount> {
        var discounts: Array<InvoiceDiscount> = []
        
        if invoice.discounts != nil {
            discounts = invoice.discounts!.allObjects as! [InvoiceDiscount]
        }
        
        return discounts.sorted { a, b in
            return a.order < b.order
        }
    }
}
