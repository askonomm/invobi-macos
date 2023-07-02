//
//  InvoiceTaxationsTaxationActionsView.swift
//  Invobi
//
//  Created by Asko Nomm on 02.07.2023.
//

import SwiftUI

struct InvoiceTaxationsTaxationActionsView: View {
    @ObservedObject var taxation: InvoiceTaxation
    var moveUp: (_ taxation: InvoiceTaxation) -> Void
    var moveDown: (_ taxation: InvoiceTaxation) -> Void
    var delete: (_ taxation: InvoiceTaxation) -> Void
    var isFirst: Bool
    var isLast: Bool
    
    var body: some View {
        HStack {
            Menu {
                if !isFirst {
                    Button(action: {
                        moveUp(taxation)
                    }) {
                        Image(systemName: "chevron.up")
                        Text("Move up")
                    }
                    .accessibilityLabel("Move taxation up")
                }
                
                if !isLast {
                    Button(action: {
                        moveDown(taxation)
                    }) {
                        Image(systemName: "chevron.down")
                        Text("Move down")
                    }
                    .accessibilityLabel("Move taxation down")
                }
                
                Button(action: {
                    delete(taxation)
                }) {
                    Image(systemName: "trash")
                    Text("Delete")
                }
                .accessibilityLabel("Delete taxation")
            } label: {
                Label("Taxation actions", systemImage: "gearshape.fill")
                    .font(.largeTitle)
                    .labelStyle(.iconOnly)
            }
            .menuStyle(.borderlessButton)
            .menuIndicator(.hidden)
            .frame(width: 30)
            
            Spacer()
        }
    }
}
