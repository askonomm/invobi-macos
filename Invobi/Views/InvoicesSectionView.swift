//
//  InvoicesSectionView.swift
//  Invobi
//
//  Created by Asko Nomm on 02.07.2023.
//

import SwiftUI

struct InvoicesSectionView: View {
    var title: String
    var invoices: Array<Invoice>
    
    var body: some View {
        if invoices.count > 0 {
            VStack(spacing: 0) {
                HStack {
                    Text(title.uppercased())
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 10)
                
                ForEach(invoices, id: \.self) { invoice in
                    InvoicesSectionInvoiceView(invoice: invoice)
                }
                
                Spacer().frame(height: 40)
            }
        }
    }
}
