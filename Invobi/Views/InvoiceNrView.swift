//
//  InvoiceNrView.swift
//  Invobi
//
//  Created by Asko Nomm on 10.06.2023.
//

import SwiftUI

struct InvoiceNrView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    @State private var itemNr = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Invoice #")
                    .font(.largeTitle)
                    .foregroundColor(Color.gray)
                    .fontWeight(.light)
                
                TextField("Invoice number", text: $itemNr, onCommit: save)
                    .font(.largeTitle)
                    .fontWeight(.regular)
                    .textFieldStyle(.plain)
                    .fixedSize()
                    .offset(x: -6)
                    .onDebouncedChange(of: $itemNr, debounceFor: 0.25, perform: { _ in
                        save()
                    })
                    .onAppear(perform: onAppear)
                
                Spacer().frame(width: 10)
                InvoiceMetaView(invoice: invoice)
                Spacer()
            }
            
            Spacer().frame(height: 10)
            
            HStack {
                Text(getDueInText(date: invoice.dueDate ?? Date.now))
                    .foregroundColor(colorScheme == .dark ? Color(hex: "#bbb") : Color(hex: "#666"))
                Spacer()
            }
        }
            
        .padding(.horizontal, 40)
    }
    
    func onAppear() {
        self.itemNr = self.invoice.nr != nil ? "\(self.invoice.nr!)" : ""
    }
    
    func save() {
        self.invoice.nr = self.itemNr
        try? self.context.save()
    }
}
