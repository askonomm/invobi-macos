//
//  InvoiceTaxations.swift
//  Invobi
//
//  Created by Asko Nomm on 14.06.2023.
//

import SwiftUI

struct InvoiceTaxationsPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice

    var body: some View {
        VStack {
            ForEach(getTaxations(), id: \.self) { taxation in
                Spacer().frame(height: 15)
                InvoiceTaxationsTaxationPreviewView(invoice: invoice, taxation: taxation)
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
