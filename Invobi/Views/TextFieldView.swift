//
//  TextFieldView.swift
//  Invobi
//
//  Created by Asko Nomm on 11.06.2023.
//

import SwiftUI

struct TextFieldView: View {
    @Environment(\.colorScheme) private var colorScheme
    var label: String = ""
    @Binding var value: String
    var onAppear: () -> Void
    var save: () -> Void
    var numberField: Bool = false
    
    var body: some View {
        TextField(LocalizedStringKey(label), text: $value)
        .onAppear(perform: {
            onAppear()
        })
        .onDebouncedChange(of: $value, debounceFor: 0.25, perform: { _ in
            save()
        })
        .textFieldStyle(.plain)
        .padding(.leading, 10)
        .padding(.trailing, 6)
        .padding(.vertical, 6)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(colorScheme == .dark ? Color(hex: "#333") : Color(hex: "#e5e5e5")))
    }
}
