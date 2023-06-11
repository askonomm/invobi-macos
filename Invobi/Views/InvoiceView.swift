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
    @Binding var navPath: NavigationPath
    @State private var showConfig = false
    
    var body: some View {
        VStack {
            ScrollView {
                InvoiceNrView(invoice: invoice)
                InvoiceHeadingView(invoice: invoice)

                Spacer()
            }
        }
        .background(Color.white)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    context.delete(self.invoice)
                    self.navPath.removeLast(self.navPath.count)
                    
                }) {
                    Label("Delete Invoice", systemImage: "trash")
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    showConfig = true
                }) {
                    Label("X", systemImage: "gear")
                }.popover(isPresented: $showConfig) {
                    InvoiceSidebarView(invoice: invoice)
                    .padding(20)
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    print(self.navPath)
                    let view = PDFView(nr: self.invoice.nr!)
                    self.savePDF(view: view)
                }) {
                    Label("Save PDF", systemImage: "square.and.arrow.down").labelStyle(.titleAndIcon)
                }
            }
        }
        .navigationTitle("Edit Invoice")
    }
    
    @MainActor func savePDF(view: PDFView) {
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

//
//struct InvoiceView_Previews: PreviewProvider {
//    static var previews: some View {
//        InvoiceView()
//    }
//}
