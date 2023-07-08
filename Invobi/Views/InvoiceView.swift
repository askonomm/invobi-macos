//
//  InvoiceView.swift
//  Invobi
//
//  Created by Asko Nomm on 07.06.2023.
//

import SwiftUI

struct InvoiceView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @State private var showMetaView = false
    @State private var view = "edit"
    @State private var showSavePDFPopover = false
    @State private var savePDFWithFixedFormat = false
    @State private var savePDFFormat = "A4"
    
    var body: some View {
        VStack {
            if view == "edit" {
                InvoiceEditView(invoice: appState.selectedInvoice!, showMetaView: $showMetaView)
            }
            
            if view == "preview" {
                ScrollView {
                    InvoicePreviewView(invoice: appState.selectedInvoice!)
                }
            }
        }
        .background(colorScheme == .dark ? Color(hex: "#191919") : Color.white)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.08)) {
                        appState.view = Views.invoices
                    }
                }) {
                    Label("Back", systemImage: "chevron.backward")
                }
            }
            
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.08)) {
                        appState.view = Views.invoices
                        
                        context.delete(appState.selectedInvoice!)
                        try? context.save()
                    }
                }) {
                    Label("Delete Invoice", systemImage: "trash")
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Picker("", selection: $view.animation(.easeInOut(duration: 0.08))) {
                    Text("Edit").tag("edit")
                    Text("Preview").tag("preview")
                }
                .onChange(of: view) { _ in
                    if view == "preview" {
                        showMetaView = false
                    }
                }
                .pickerStyle(.inline)
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.08)) {
                        view = "edit"
                        showMetaView = !showMetaView
                    }
                }) {
                    if showMetaView {
                        Label("Hide settings", systemImage: "gearshape")
                            .foregroundColor(Color.blue)
                    } else {
                        Label("Show settings", systemImage: "gearshape")
                    }
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.08)) {
                        showSavePDFPopover = !showSavePDFPopover
                    }
                }) {
                    Label("PDF", systemImage: "square.and.arrow.down").labelStyle(.titleAndIcon)
                }
                .popover(isPresented: $showSavePDFPopover, arrowEdge: .bottom) {
                    VStack {
                        HStack {
                            Text("Fixed format")
                            Spacer()
                            Toggle("Fixed format", isOn: $savePDFWithFixedFormat)
                                .labelsHidden()
                                .toggleStyle(.switch)
                        }
                        
                        Spacer().frame(height: 15)
                        
                        Divider()
                        
                        Spacer().frame(height: 15)
                        
                        if savePDFWithFixedFormat {
                            Picker("Page format", selection: $savePDFFormat) {
                                Text("A4").tag("A4")
                                Text("US Letter").tag("Letter")
                            }
                            
                            Spacer().frame(height: 15)
                            
                            Divider()
                            
                            Spacer().frame(height: 15)
                        }
                        
                        Button(action: {
                            self.savePDF(invoice: appState.selectedInvoice!, format: savePDFWithFixedFormat ? savePDFFormat : "none")
                        }) {
                            Text("Save PDF")
                        }
                    }
                    .frame(width: 150)
                    .padding()
                }
            }
        }
        .navigationTitle(Text("Edit Invoice"))
    }
    
    @MainActor func savePDF(invoice: Invoice, format: String) {
        var pageWidth: Double = 0
        var pageHeight: Double = 0
        let dpi = Double(90)
        
        if format == "A4" {
            pageWidth = 8.27 * dpi
            pageHeight = 11.69 * dpi
        }
        
        if format == "Letter" {
            pageWidth = 8.5 * dpi
            pageHeight = 11 * dpi
        }
        
        let view = InvoicePreviewView(invoice: invoice).frame(width: format == "none" ? 800 : pageWidth)
        
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.pdf]
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        panel.title = String(localized: "Save PDF")
        panel.message = String(localized:"Choose a folder and a name to store the invoice")
        panel.nameFieldLabel = String(localized:"PDF name:")
        
        if panel.runModal() == .OK {
            let renderer = ImageRenderer(content: view)
            
            renderer.render { size, context in
                var box = CGRect(x: 0, y: 0, width: format == "none" ? size.width : pageWidth, height: format == "none" ? size.height : pageHeight)
                
                guard let pdf = CGContext(panel.url! as CFURL, mediaBox: &box, nil) else {
                    return
                }
                
                if format == "none" {
                    pdf.beginPDFPage(nil)
                    context(pdf)
                    pdf.endPDFPage()
                } else {
                    let totalHeight = size.height
                    let pageCount = Int(ceil(totalHeight / pageHeight))
                    let emptyOffset = (Double(pageCount) * pageHeight) - totalHeight
                    
                    for page in 0...(pageCount - 1) {
                        pdf.beginPDFPage(nil)
                        
                        /// Basically, since it goes from bottom to top, we're reversing our way from 0
                        /// which is the last page all the way to the top, which is negative `totalHeight`.
                        let y = -(((Double(pageCount - 1) - Double(page)) * pageHeight) - emptyOffset)
                        
                        
                        pdf.translateBy(x: 0, y: CGFloat(y))
                        context(pdf)
                        pdf.endPDFPage()
                    }
                }
                
                pdf.closePDF()
            }
        }
    }
}
