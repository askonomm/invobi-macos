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
    @Binding var showMetaView: Bool
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
                
                Spacer()
                
                if showMetaView {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.08)) {
                            showMetaView = false
                        }
                    }) {
                        Label("Close settings", systemImage: "arrow.forward.to.line")
                            .font(.title)
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.plain)
                    .offset(x: -210)
                }
            }
            
            Spacer().frame(height: 10)
            
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.08)) {
                        showMetaView = !showMetaView
                    }
                }) {
                    Text("Issued \(displayDate(invoice.dateIssued ?? Date.now))")
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#bbb") : Color(hex: "#666"))
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            
            Spacer().frame(height: 5)
            
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.08)) {
                        showMetaView = !showMetaView
                    }
                }) {
                    Text("Due \(displayDate(invoice.dueDate ?? Date.now))")
                        .foregroundColor(colorScheme == .dark ? Color(hex: "#bbb") : Color(hex: "#666"))
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
        }
            
        .padding(.horizontal, 40)
    }
    
    func onAppear() {
        self.itemNr = self.invoice.nr != nil ? "\(self.invoice.nr!)" : ""
    }
    
    func save() {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.invoice.nr = self.itemNr
            try? self.context.save()
        }
    }
}
