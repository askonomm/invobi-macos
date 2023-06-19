//
//  InvoicePaymentDetailsView.swift
//  Invobi
//
//  Created by Asko Nomm on 16.06.2023.
//

import SwiftUI

struct InvoicePaymentsDetailPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @ObservedObject var field: InvoiceField
    
    var body: some View {
        HStack {
            Text((field.label ?? "") + ": ")
                .fontWeight(.semibold)
                .fixedSize()
            Text(field.value ?? "")
                .fixedSize()
                .offset(x: -8)
            Spacer()
        }
    }
}

struct InvoicePaymentDetailsPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        if getFields().count > 0 {
            VStack {
                HStack {
                    Text("Payment Details")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#eee") : Color(hex: "#333"))
                    
                    Spacer()
                }
                
                Spacer().frame(height: 15)
                
                ForEach(Array(getFields().enumerated()), id: \.element) { index, field in
                    if index > 0 {
                        Spacer().frame(height: 10)
                    }
                    
                    InvoicePaymentsDetailPreviewView(invoice: invoice, field: field)
                }
            }
            .padding(.all, 40)
            .border(width: 1, edges: [.top], color: colorScheme == .dark ? Color(hex: "333") : Color(hex: "#e5e5e5"))
        }
    }
    
    private func getFields() -> Array<InvoiceField> {
        if self.invoice.fields == nil {
            return []
        }
        
        let fields = self.invoice.fields!.allObjects as! [InvoiceField]
    
        let filteredFields = fields.filter { field in
            return field.location == "PAYMENT_DETAILS"
        }
        
        return filteredFields.sorted { a, b in
            a.order < b.order
        }
    }
}
