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
            VStack {
                HStack {
                    Text(title.uppercased())
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 10)
                
                ForEach(Array(invoices.enumerated()), id: \.element) { index, invoice in
                    VStack {
                        if index > 0 {
                            Spacer().frame(height: 10)
                        }
                        
                        InvoicesSectionInvoiceView(invoice: invoice)
                    }
                }
                
                Spacer().frame(height: 40)
            }
        }
    }
}
