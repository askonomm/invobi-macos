//
//  InvoiceDiscountsDiscountActionsView.swift
//  Invobi
//
//  Created by Asko Nomm on 04.07.2023.
//

import SwiftUI

struct InvoiceDiscountsDiscountActionsView: View {
    @ObservedObject var discount: InvoiceDiscount
    var moveUp: (_ discount: InvoiceDiscount) -> Void
    var moveDown: (_ discount: InvoiceDiscount) -> Void
    var delete: (_ discount: InvoiceDiscount) -> Void
    var isFirst: Bool
    var isLast: Bool
    
    var body: some View {
        HStack {
            Menu {
                if !isFirst {
                    Button(action: {
                        moveUp(discount)
                    }) {
                        Image(systemName: "chevron.up")
                        Text("Move up")
                    }
                    .accessibilityLabel("Move discount up")
                }
                
                if !isLast {
                    Button(action: {
                        moveDown(discount)
                    }) {
                        Image(systemName: "chevron.down")
                        Text("Move down")
                    }
                    .accessibilityLabel("Move discount down")
                }
                
                Button(action: {
                    delete(discount)
                }) {
                    Image(systemName: "trash")
                    Text("Delete")
                }
                .accessibilityLabel("Delete discount")
            } label: {
                Label("Discount actions", systemImage: "gearshape.fill")
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
