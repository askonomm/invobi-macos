//
//  InvoiceNrView.swift
//  Invobi
//
//  Created by Asko Nomm on 10.06.2023.
//

import SwiftUI

struct InvoiceNrPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        VStack {
            HStack {
                Text("\(Text("Invoice")) #")
                    .font(.largeTitle)
                    .foregroundColor(Color.gray)
                    .fontWeight(.light)
                
                Text(invoice.nr ?? "")
                    .font(.largeTitle)
                    .fontWeight(.regular)
                    .textFieldStyle(.plain)
                    .fixedSize()
                    .offset(x: -6)

                Spacer()
            }
            
            Spacer().frame(height: 10)
            
            HStack {
                Text("\(Text("Issued")) \((invoice.dateIssued != nil ? invoice.dateIssued! : Date.now).formatted(.dateTime.day().month().year()))")
                    .foregroundColor(colorScheme == .dark ? Color(hex: "#bbb") : Color(hex: "#666"))
                Spacer()
            }
            
            Spacer().frame(height: 5)
            
            HStack {
                Text("\(Text("Due")) \((invoice.dueDate != nil ? invoice.dueDate! : Date.now).formatted(.dateTime.day().month().year()))")
                    .foregroundColor(colorScheme == .dark ? Color(hex: "#bbb") : Color(hex: "#666"))
                Spacer()
            }
        }
            
        .padding(.horizontal, 40)
    }
}
