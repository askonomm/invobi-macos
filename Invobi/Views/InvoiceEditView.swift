//
//  InvoiceEditView.swift
//  Invobi
//
//  Created by Asko Nomm on 05.07.2023.
//

import SwiftUI

struct InvoiceEditView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    @Binding var showMetaView: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView {
                VStack {
                    Group {
                        Spacer().frame(height: 35)
                        InvoiceNrView(invoice: invoice, showMetaView: $showMetaView)
                        Spacer().frame(height: 40)
                        InvoiceHeadingView(invoice: invoice)
                    }
                    
                    Group {
                        Spacer().frame(height: 40)
                        InvoiceItemsView(invoice: invoice)
                        Spacer().frame(height: 40)
                    }
                    
                    Group {
                        InvoiceSubTotalView(invoice: invoice)
                        Spacer().frame(height: 15)
                        InvoiceDiscountsView(invoice: invoice)
                        Spacer().frame(height: 15)
                        InvoiceTaxationsView(invoice: invoice)
                    }
                    
                    Group {
                        Spacer().frame(height: 40)
                        InvoiceTotalView(invoice: invoice)
                        InvoicePaymentDetailsView(invoice: invoice)
                    }
                }
            }
            
            if showMetaView {
                HStack {
                    Spacer()
                    
                    VStack {
                        InvoiceMetaView(invoice: invoice)
                    }
                    .frame(width: 200)
                    .padding()
                    .background(colorScheme == .dark ? Color(hex: "#272727") : Color(hex: "#fafafa"))
                    .border(width: 1, edges: [.leading], color: colorScheme == .dark ? Color(hex: "#444") : Color(hex: "#e5e5e5"))
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: colorScheme == .dark ? 0.15 : 0.04), radius: 14, x: -2)
                }
                .transition(.move(edge: .trailing))
            }
        }
    }
}
