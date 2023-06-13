//
//  InvoiceHeadingFieldView.swift
//  Invobi
//
//  Created by Asko Nomm on 11.06.2023.
//

import SwiftUI

struct InvoiceHeadingFieldView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var field: InvoiceField
    @State private var label = ""
    @State private var value = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                TextField("Label (optional)", text: $label, axis: .vertical)
                .onAppear {
                    if self.field.label != nil {
                        self.label = self.field.label!
                    }
                }
                .onDebouncedChange(of: $label, debounceFor: 0.25, perform: { _ in
                    self.field.label = self.label
                    try? context.save()
                })
                .textFieldStyle(.plain)
                .font(.callout)
                .fontWeight(.semibold)
                .textCase(.uppercase)
                .offset(y: 1)
                
                TextField("Value", text: $value, axis: .vertical)
                .onAppear {
                    DispatchQueue.main.async {
                        if self.field.value != nil {
                            self.value = self.field.value!
                        }
                    }
                }
                .onDebouncedChange(of: $value, debounceFor: 0.25, perform: { _ in
                    self.field.value = self.value
                    try? context.save()
                })
                .textFieldStyle(.plain)
                .offset(y: -2)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color(hex: "#e5e5e5")))
            
            HStack(alignment: .top) {
                Spacer()
                
                Button(action: {
                    self.context.delete(self.field)
                }) {
                    Label("Delete field", systemImage: "minus.circle.fill")
                    .font(.title3)
                    .labelStyle(.iconOnly)
                }
                .buttonStyle(.plain)
                .offset(x: 8, y: -8)
            }
        }
    }
}
