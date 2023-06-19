//
//  InvoiceHeadingFieldView.swift
//  Invobi
//
//  Created by Asko Nomm on 11.06.2023.
//

import SwiftUI

struct InvoiceHeadingFieldPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var field: InvoiceField
    
    var body: some View {
        VStack {
            if field.label != nil {
                HStack {
                    Text(field.label!.uppercased())
                        .font(.callout)
                        .fontWeight(.semibold)
                        .offset(y: 1)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 10)
            }
            
            if field.value != nil {
                HStack {
                    Text(field.value!)
                        .font(.title3)
                        .offset(y: -2)
                    
                    Spacer()
                }
            }
        }
    }
}
