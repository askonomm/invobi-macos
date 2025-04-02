//
//  InvoiceTotalPreviewView.swift
//  Invobi
//
//  Created by Asko Nomm on 04.07.2023.
//

import SwiftUI

struct InvoiceTotalPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        HStack {
            Text("Total")
                .font(.title3)
                .fontWeight(.semibold)
            Spacer()
            Text(calculateTotal(invoice), format: .currency(code: invoice.currency ?? "EUR"))
                .font(.title3)
                .fontWeight(.semibold)
        }
        .padding(.all, 40)
        .border(width: 1, edges: [.top], color: colorScheme == .dark ? Color(hex: "#333") : Color(hex: "#e5e5e5"))
    }
}
