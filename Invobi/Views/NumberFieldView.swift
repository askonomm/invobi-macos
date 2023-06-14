//
//  NumberFieldView.swift
//  Invobi
//
//  Created by Asko Nomm on 13.06.2023.
//

import SwiftUI

struct NumberFieldView: View {
    var label: String = ""
    @Binding var value: Decimal
    var onAppear: () -> Void
    var save: () -> Void

    var body: some View {
        TextField(label, value: $value, format: .number)
        .onAppear(perform: {
            onAppear()
        })
        .onDebouncedChange(of: $value, debounceFor: 0.25, perform: { _ in
            save()
        })
        .textFieldStyle(.plain)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Color(hex: "#e5e5e5")))
    }
}
