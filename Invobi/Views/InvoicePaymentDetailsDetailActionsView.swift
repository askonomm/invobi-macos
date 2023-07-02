//
//  InvoicePaymentDetailsDetailActionsView.swift
//  Invobi
//
//  Created by Asko Nomm on 02.07.2023.
//

import SwiftUI

struct InvoicePaymentDetailsDetailActionsView: View {
    @ObservedObject var field: InvoiceField
    var moveUp: (_ field: InvoiceField) -> Void
    var moveDown: (_ field: InvoiceField) -> Void
    var delete: (_ field: InvoiceField) -> Void
    var isFirst: Bool
    var isLast: Bool
    
    var body: some View {
        HStack {
            Menu {
                if !isFirst {
                    Button(action: {
                        moveUp(field)
                    }) {
                        Image(systemName: "chevron.up")
                        Text("Move up")
                    }
                    .accessibilityLabel("Move field up")
                }
                
                if !isLast {
                    Button(action: {
                        moveDown(field)
                    }) {
                        Image(systemName: "chevron.down")
                        Text("Move down")
                    }
                    .accessibilityLabel("Move field down")
                }
                
                Button(action: {
                    delete(field)
                }) {
                    Image(systemName: "trash")
                    Text("Delete")
                }
                .accessibilityLabel("Delete field")
            } label: {
                Label("Field actions", systemImage: "gearshape.fill")
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
