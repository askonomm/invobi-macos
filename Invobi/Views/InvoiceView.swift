//
//  InvoiceView.swift
//  Invobi
//
//  Created by Asko Nomm on 07.06.2023.
//

import SwiftUI

struct InvoiceView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    var onDelete: (_ invoice: Invoice) -> Void
    @State private var showConfig = false
    private let statuses = ["DRAFT", "UNPAID", "PAID", "OVERDUE"]
    @State private var status = "DRAFT"
    private let currencies = ["EUR", "USD"]
    @State private var currency = "EUR"
    @State private var view = "preview"
    
    var body: some View {
        VStack {
            if view == "edit" {
                ScrollView {
                    Group {
                        Spacer().frame(height: 35)
                        InvoiceNrView(invoice: invoice)
                        Spacer().frame(height: 40)
                        InvoiceHeadingView(invoice: invoice)
                    }
                    
                    Group {
                        Spacer().frame(height: 40)
                        InvoiceItemsView(invoice: invoice)
                        Spacer().frame(height: 40)
                    }
                    
                    Group {
                        InvoiceSubTotalView(invoice: invoice)
                        Spacer().frame(height: 15)
                        InvoiceTaxationsView(invoice: invoice)
                    }
                    
                    Group {
                        Spacer().frame(height: 40)
                        InvoiceTotalView(invoice: invoice)
                        Spacer().frame(height: 15)
                        InvoicePaymentDetailsView(invoice: invoice)
                    }
                    
                    Spacer()
                }
            }
            
            if view == "preview" {
                ScrollView {
                    InvoicePreviewView(invoice: invoice)
                    
                    Spacer()
                }
            }
        }
        .background(Color.white)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    onDelete(self.invoice)
                }) {
                    Label("Delete Invoice", systemImage: "trash")
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Picker("", selection: $view) {
                    Text("Edit").tag("edit")
                    Text("Preview").tag("preview")
                }
                .pickerStyle(.inline)
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    self.savePDF(invoice: invoice)
                }) {
                    Label("Save PDF", systemImage: "square.and.arrow.down").labelStyle(.titleAndIcon)
                }
            }
        }
        .navigationTitle("Edit Invoice")
    }
    
    @MainActor func savePDF(invoice: Invoice) {
        let view = InvoicePreviewView(invoice: invoice).frame(width: 800)
        
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.pdf]
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        panel.title = "Save PDF"
        panel.message = "Choose a folder and a name to store the invoice"
        panel.nameFieldLabel = "PDF name:"
        
        if panel.runModal() == .OK {
            let renderer = ImageRenderer(content: view)
            
            renderer.render { size, context in
                // 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
                var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                
                // 5: Create the CGContext for our PDF pages
                guard let pdf = CGContext(panel.url! as CFURL, mediaBox: &box, nil) else {
                    return
                }
                
                // 6: Start a new PDF page
                pdf.beginPDFPage(nil)
                
                // 7: Render the SwiftUI view data onto the page
                context(pdf)
                
                // 8: End the page and close the file
                pdf.endPDFPage()
                pdf.closePDF()
            }
        }
    }
}
