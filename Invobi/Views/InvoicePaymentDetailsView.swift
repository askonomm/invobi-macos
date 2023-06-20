//
//  InvoicePaymentDetailsView.swift
//  Invobi
//
//  Created by Asko Nomm on 16.06.2023.
//

import SwiftUI

struct InvoicePaymentsDetailView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @ObservedObject var field: InvoiceField
    @State private var label = ""
    @State private var value = ""
    
    var body: some View {
        HStack {
            TextFieldView(label: "Field label", value: $label, onAppear: onLabelAppear, save: onLabelSave)
                .fixedSize()
            Text(": ")
                .offset(x: -4)
            TextFieldView(label: "Field value", value: $value, onAppear: onValueAppear, save: onValueSave)
                .fixedSize()
                .offset(x: -4)
            Spacer()
        }
    }
    
    private func onLabelAppear() {
        if self.field.label != nil {
            self.label = self.field.label!
        }
    }
    
    private func onValueAppear() {
        if self.field.value != nil {
            self.value = self.field.value!
        }
    }
    
    private func onLabelSave() {
        self.field.label = self.label
        try? context.save()
    }
    
    private func onValueSave() {
        self.field.value = self.value
        try? context.save()
    }
}

struct InvoicePaymentDetailsView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        VStack {
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
                    
                    ForEach(getFields(), id: \.self) { field in
                        ZStack {
                            InvoicePaymentsDetailView(invoice: invoice, field: field)
                            
                            HStack {
                                Button(action: {
                                    context.delete(field)
                                    try? context.save()
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                }
                                .buttonStyle(.plain)
                                .offset(x: -8, y: -14)

                                Spacer()
                            }
                        }
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
    }
    
    private func addField() {
        let field = InvoiceField(context: context)
        field.label = ""
        field.value = ""
        field.order = getFields().last != nil ? getFields().last!.order + 1 : 0
        field.location = "PAYMENT_DETAILS"
        
        invoice.addToFields(field)
        
        try? context.save()
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
