//
//  InvoiceHeadingLocationPreviewView.swift
//  Invobi
//
//  Created by Asko Nomm on 06.07.2023.
//

import SwiftUI

struct InvoiceHeadingLocationPreviewView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    var location: String
    @State private var draggedField: InvoiceField?
    @State private var name = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image
            if location == "FROM" && invoice.fromImage != nil {
                ImageView(imageData: invoice.fromImage!)
                Spacer().frame(height: 15)
            }
            
            if location == "TO" && invoice.toImage != nil {
                ImageView(imageData: invoice.toImage!)
                Spacer().frame(height: 15)
            }
            
            // Name
            if location == "FROM" && invoice.fromName != nil {
                Text(invoice.fromName!)
                    .font(.title3)
            }
            
            if location == "TO" && invoice.toName != nil {
                Text(invoice.toName!)
                    .font(.title3)
            }
            
            // Fields
            ForEach(getFields()) { field in
                Spacer().frame(height: 20)
                InvoiceHeadingFieldPreviewView(field: field)
            }
        }
    }

    private func getFields() -> Array<InvoiceField> {
        var fields: Array<InvoiceField> = []
        
        if invoice.fields != nil {
            fields = invoice.fields!.allObjects as! [InvoiceField]
        }
        
        fields = fields.filter { field in
            return field.location == self.location
        }
        
        return fields.sorted { a, b in
            a.order < b.order
        }
    }
}
