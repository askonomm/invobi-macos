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
                VStack {
                    HStack(alignment: .top) {
                        Button(action: {
                            delete(field)
                        }) {
                            Label("Delete field", systemImage: "minus.circle.fill")
                                .foregroundColor(Color.red)
                                .font(.title3)
                                .labelStyle(.iconOnly)
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                    }
                    
                    if !isFirst(field) {
                        HStack(alignment: .top) {
                            Button(action: {
                                moveUp(field)
                            }) {
                                Label("Move field up", systemImage: "chevron.up.circle.fill")
                                    .foregroundColor(Color.gray)
                                    .font(.title3)
                                    .labelStyle(.iconOnly)
                            }
                            .buttonStyle(.plain)
                            
                            Spacer()
                        }
                    }
                    
                    if !isLast(field) {
                        HStack(alignment: .top) {
                            Button(action: {
                                moveDown(field)
                            }) {
                                Label("Move field down", systemImage: "chevron.down.circle.fill")
                                    .foregroundColor(Color.gray)
                                    .font(.title3)
                                    .labelStyle(.iconOnly)
                            }
                            .buttonStyle(.plain)
                            
                            Spacer()
                        }
                    }
                }
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
    
    private func isFirst(_ field: InvoiceField) -> Bool {
        return fields.first == field
    }
    
    private func isLast(_ field: InvoiceField) -> Bool {
        return fields.last == field
    }
}
