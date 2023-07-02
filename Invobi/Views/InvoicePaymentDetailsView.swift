//
//  InvoicePaymentDetailsView.swift
//  Invobi
//
//  Created by Asko Nomm on 16.06.2023.
//

import SwiftUI

struct InvoicePaymentDetailsView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    @State private var showActionsForField: InvoiceField?
    @State private var fields: Array<InvoiceField> = []
    
    var body: some View {
        VStack {
            if fields.count > 0 {
                VStack {
                    HStack {
                        Text("Payment Details")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(colorScheme == .dark ? Color(hex: "#eee") : Color(hex: "#333"))
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height: 15)
                    
                    ForEach(fields, id: \.self) { field in
                        ZStack {
                            InvoicePaymentsDetailsDetailView(invoice: invoice, field: field)
                                .offset(x: 24)
                            
                            if showActionsForField == field {
                                InvoicePaymentDetailsDetailActionsView(field: field,
                                                                       moveUp: moveUp,
                                                                       moveDown: moveDown,
                                                                       delete: delete,
                                                                       isFirst: isFirst(field),
                                                                       isLast: isLast(field))
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
                    
                    Spacer().frame(height: 15)
                    
                    HStack {
                        Button(action: addField) {
                            Text("Add field")
                        }
                        
                        Spacer()
                    }
                    
                }
                .padding(.all, 40)
                .border(width: 1, edges: [.top], color: colorScheme == .dark ? Color(hex: "#333") : Color(hex: "#e5e5e5"))
                .frame(maxWidth: .infinity)
            } else {
                HStack {
                    Button(action: addField) {
                        Text("Add payment details")
                    }
                    
                    Spacer()
                }
                .padding(.all, 40)
                .border(width: 1, edges: [.top], color: colorScheme == .dark ? Color(hex: "#333") : Color(hex: "#e5e5e5"))
            }
        }
        .onAppear {
            self.fields = getFields()
        }
    }
    
    private func addField() {
        withAnimation(.easeInOut(duration: 0.08)) {
            let field = InvoiceField(context: context)
            field.label = ""
            field.value = ""
            field.order = getFields().last != nil ? getFields().last!.order + 1 : 0
            field.location = "PAYMENT_DETAILS"
            
            invoice.addToFields(field)
            fields.append(field)
            
            try? context.save()
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
    
    private func moveUp(_ field: InvoiceField) {
        withAnimation(.easeInOut(duration: 0.08)) {
            let currentOrder = field.order
            let newOrder = currentOrder - 1
            
            let replacingField = fields.first { field in
                return field.order == newOrder
            }
            
            field.order = newOrder
            fields[Int(currentOrder)] = replacingField!
            fields[Int(newOrder)] = field
            replacingField!.order = currentOrder
            
            self.showActionsForField = .none
            
            try? context.save()
        }
    }
    
    private func moveDown(_ field: InvoiceField) {
        withAnimation(.easeInOut(duration: 0.08)) {
            let currentOrder = field.order
            let newOrder = currentOrder + 1
            
            let replacingField = fields.first { field in
                return field.order == newOrder
            }
            
            field.order = newOrder
            fields[Int(currentOrder)] = replacingField!
            fields[Int(newOrder)] = field
            replacingField!.order = currentOrder
            
            self.showActionsForField = .none
            
            try? context.save()
        }
    }
    
    private func delete(_ field: InvoiceField) {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.context.delete(field)
            
            // Remove field
            self.fields.removeAll { f in
                return f.order == field.order
            }
            
            // Re-order all fields because there can now be a gap
            fields.indices.forEach { index in
                let f = fields[index]
                f.order = Int32(index)
            }
            
            self.showActionsForField = .none
            
            try? context.save()
        }
    }
    
    private func isFirst(_ field: InvoiceField) -> Bool {
        return fields.first == field
    }
    
    private func isLast(_ field: InvoiceField) -> Bool {
        return fields.last == field
    }
}
