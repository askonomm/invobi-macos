//
//  SwiftUIView.swift
//  Invobi
//
//  Created by Asko Nomm on 17.06.2023.
//

import SwiftUI

struct InvoicePreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        Text("hello")
    }
}
