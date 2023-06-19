//
//  Separator.swift
//  Invobi
//
//  Created by Asko Nomm on 19.06.2023.
//

import SwiftUI

struct SeparatorView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Rectangle()
            .padding(0)
            .frame(height: 2)
            .border(width: 1, edges: [.top], color: colorScheme == .dark ? Color.black : Color(hex: "#e5e5e5"))
            .border(width: 1, edges: [.bottom], color: colorScheme == .dark ? Color(hex: "#373737") : Color(hex: "#e5e5e5"))
            .clipped()
    }
}
