//
//  InvoiceNrView.swift
//  Invobi
//
//  Created by Asko Nomm on 10.06.2023.
//

import SwiftUI

struct InvoiceNrView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @State private var itemNr = ""
    @State private var disabled = true
    
    var body: some View {
        HStack {
            Text("Invoice #")
            .font(.largeTitle)
            .foregroundColor(Color.gray)
            .fontWeight(.light)
            
            TextField("Invoice number", text: $itemNr, onCommit: save)
            .font(.largeTitle)
            .fontWeight(.regular)
            .textFieldStyle(.plain)
            .disabled(self.disabled)
            .offset(x: -6)
            .onDebouncedChange(of: $itemNr, debounceFor: 0.25, perform: { _ in
                save()
            })
            .onAppear(perform: onAppear)
            .onDisappear(perform: save)
        }
        .padding(.horizontal, 40)
    }
    
    func onAppear() {
        self.itemNr = self.invoice.nr != nil ? "\(self.invoice.nr!)" : ""
        DispatchQueue.main.async {
            self.disabled = false
        }
    }
    
    func save() {
        self.invoice.nr = self.itemNr
        try? self.context.save()
    }
}
