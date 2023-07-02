//
//  InvoicePaymentDetailsDetailView.swift
//  Invobi
//
//  Created by Asko Nomm on 02.07.2023.
//

import SwiftUI

struct InvoicePaymentsDetailsDetailView: View {
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
