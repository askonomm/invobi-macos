//
//  SplashView.swift
//  Invobi
//
//  Created by Asko Nomm on 20.06.2023.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.colorScheme) private var colorScheme
    var addInvoice: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .center) {
                if colorScheme == .dark {
                    Image("icon")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .opacity(0.5)
                } else {
                    Image("icon")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                
                Spacer().frame(height: 10)
                
                Text("You have no invoices yet. ")
                    .font(.title3)
                    .foregroundColor(colorScheme == .dark ? Color(hex: "#ddd") : Color(hex: "#777"))
                
                Spacer().frame(height: 40)
                
                Button(action: addInvoice) {
                    Label("Create Invoice", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? Color(hex: "#111") : Color.white)
    }
}
