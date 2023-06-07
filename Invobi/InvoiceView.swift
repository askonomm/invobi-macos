//
//  InvoiceView.swift
//  Invobi
//
//  Created by Asko Nomm on 07.06.2023.
//

import SwiftUI

struct InvoiceNrView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @State private var itemNr = ""
    
    var body: some View {
        HStack {
            Text("Invoice #")
            .font(.largeTitle)
            .foregroundColor(Color.gray)
            .fontWeight(.light)
            
            TextField("Invoice number", text: $itemNr, onCommit: {
                self.invoice.nr = self.itemNr
                try? self.context.save()
            })
            .font(.largeTitle)
            .fontWeight(.medium)
            .textFieldStyle(.plain)
            .offset(x: -6)
            .onDebouncedChange(of: $itemNr, debounceFor: 0.25, perform: { _ in
                self.invoice.nr = self.itemNr
                try? self.context.save()
            })
            .onAppear {
                self.itemNr = self.invoice.nr != nil ? "\(self.invoice.nr!)" : ""
            }
            .onDisappear {
                self.invoice.nr = self.itemNr
                try? self.context.save()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
}

struct InvoiceHeadingView: View {
    var sizeWidth: CGFloat
    @State private var fromName = ""
    @State private var toName = ""
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("From")
                    .font(.title3)
                    
                    TextField("Name", text: $fromName)
                    .textFieldStyle(.roundedBorder)
                    
                    Button(action: {
                        
                    }) {
                        Text("Add field")
                    }
                }
                .padding(.leading, 25)
                .padding(.trailing, 12.5)
                .padding([.top, .bottom], 10)
            }
            .frame(width: self.sizeWidth * 0.5)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("To")
                    .font(.title3)
                    
                    TextField("Name", text: $toName)
                    .textFieldStyle(.roundedBorder)
 
                    Button(action: {
                        
                    }) {
                        Text("Add field")
                    }
                }
                .padding(.trailing, 32)
                .padding(.leading, 12.5)
                .padding([.top, .bottom], 10)
            }
            .frame(width: self.sizeWidth * 0.5)
        }
    }
}

struct InvoiceView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                InvoiceNrView(invoice: invoice)
                Divider().frame(width: geometry.size.width).offset(x: -4)
                InvoiceHeadingView(sizeWidth: geometry.size.width)
                Divider().frame(width: geometry.size.width).offset(x: -4)
                
                Spacer()
            }.toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        context.delete(self.invoice)
                    }) {
                        Label("Delete Invoice", systemImage: "trash")
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        let view = PDFView(nr: self.invoice.nr!)
                        self.savePDF(view: view)
                    }) {
                        Label("Save PDF", systemImage: "square.and.arrow.down").labelStyle(.titleAndIcon)
                    }
                }
            }.background(Color.white)
        }
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
