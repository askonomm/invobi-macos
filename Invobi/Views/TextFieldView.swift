//
//  TextFieldView.swift
//  Invobi
//
//  Created by Asko Nomm on 11.06.2023.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var value: String
    var onAppear: () -> Void
    var save: () -> Void
    @State private var disabled = true
    
    var body: some View {
        TextField("Name", text: $value)
            .onAppear(perform: {
                onAppear()
                DispatchQueue.main.async {
                    self.disabled = false
                }
            })
            .onDisappear(perform: save)
            .onDebouncedChange(of: $value, debounceFor: 0.25, perform: { _ in
                save()
            })
            .disabled(self.disabled)
            .textFieldStyle(.plain)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Color(hex: "#e5e5e5")))
    }
}
