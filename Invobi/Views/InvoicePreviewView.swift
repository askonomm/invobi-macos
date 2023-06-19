//
//  SwiftUIView.swift
//  Invobi
//
//  Created by Asko Nomm on 17.06.2023.
//

import SwiftUI

struct InvoicePreviewView: View {
    @Environment(\.managedObjectContext) private var context
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
                InvoiceSubTotalView(invoice: invoice)
                InvoiceTaxationsPreviewView(invoice: invoice)
            }
            
            Group {
                Spacer().frame(height: 40)
                InvoiceTotalView(invoice: invoice)
                Spacer().frame(height: 20)
                InvoicePaymentDetailsPreviewView(invoice: invoice)
            }
        }
        
        Spacer()
    }
}
