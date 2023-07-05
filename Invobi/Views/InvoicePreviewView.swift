//
//  SwiftUIView.swift
//  Invobi
//
//  Created by Asko Nomm on 17.06.2023.
//

import SwiftUI

struct InvoicePreviewView: View {
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        VStack {
            Group {
                Spacer().frame(height: 35)
                InvoiceNrPreviewView(invoice: invoice)
                Spacer().frame(height: 40)
                InvoiceHeadingPreviewView(invoice: invoice)
            }
            
            Group {
                Spacer().frame(height: 40)
                InvoiceItemsPreviewView(invoice: invoice)
                Spacer().frame(height: 40)
            }
            
            Group {
                InvoiceSubTotalPreviewView(invoice: invoice)
                InvoiceDiscountsPreviewView(invoice: invoice)
                InvoiceTaxationsPreviewView(invoice: invoice)
            }
            
            Group {
                Spacer().frame(height: 40)
                InvoiceTotalPreviewView(invoice: invoice)
                InvoicePaymentDetailsPreviewView(invoice: invoice)
            }
        }
    }
}
