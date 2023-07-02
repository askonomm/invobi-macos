//
//  InvoiceItemActionsView.swift
//  Invobi
//
//  Created by Asko Nomm on 02.07.2023.
//

import SwiftUI

struct InvoiceItemsItemActionsView: View {
    @ObservedObject var item: InvoiceItem
    var moveUp: (_ item: InvoiceItem) -> Void
    var moveDown: (_ item: InvoiceItem) -> Void
    var delete: (_ item: InvoiceItem) -> Void
    var isFirst: Bool
    var isLast: Bool
    
    var body: some View {
        HStack {
            Menu {
                if !isFirst {
                    Button(action: {
                        moveUp(item)
                    }) {
                        Image(systemName: "chevron.up")
                        Text("Move item up")
                    }
                }
                
                if !isLast {
                    Button(action: {
                        moveDown(item)
                    }) {
                        Image(systemName: "chevron.down")
                        Text("Move item down")
                    }
                }
                
                Button(action: {
                    delete(item)
                }) {
                    Image(systemName: "trash")
                    Text("Delete Item")
                }
            } label: {
                Label("Actions", systemImage: "gearshape.fill")
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
