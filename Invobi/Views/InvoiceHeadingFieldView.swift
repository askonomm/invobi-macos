//
//  InvoiceHeadingFieldView.swift
//  Invobi
//
//  Created by Asko Nomm on 11.06.2023.
//

import SwiftUI

struct InvoiceHeadingFieldView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    var fields: Array<InvoiceField>
    @ObservedObject var field: InvoiceField
    @Binding var showActionsForField: InvoiceField?
    var moveUp: (_ field: InvoiceField) -> Void
    var moveDown: (_ field: InvoiceField) -> Void
    var delete: (_ field: InvoiceField) -> Void
    var isFirst: Bool
    var isLast: Bool
    @State private var label = ""
    @State private var value = ""
    
    var body: some View {
        ZStack(alignment: .center) {
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
                    if self.field.value != nil {
                        self.value = self.field.value!
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
            .padding(.vertical, 6)
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(colorScheme == .dark ? Color(hex: "#333") : Color(hex: "#e5e5e5")))
            .offset(x: 24)
            
            if showActionsForField == field {
                InvoiceHeadingFieldActionsView(field: field,
                                               moveUp: moveUp,
                                               moveDown: moveDown,
                                               delete: delete,
                                               isFirst: isFirst,
                                               isLast: isLast)
            }
        }
        .onHover { over in
            withAnimation(.easeInOut(duration: 0.08)) {
                if over {
                    showActionsForField = field
                } else {
                    showActionsForField = .none
                }
            }
        }
        .offset(x: -24)
    }
}
