//
//  InvoiceView.swift
//  Invobi
//
//  Created by Asko Nomm on 07.06.2023.
//

import SwiftUI

struct InvoiceItemsView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Items")
            .font(.title3)
        }
        .frame(maxWidth: .infinity)
    }
}

struct InvoiceMetaView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    private let statuses = ["DRAFT", "UNPAID", "PAID", "OVERDUE"]
    @State private var status = "DRAFT"
    
    var body: some View {
        HStack(alignment: .top) {
            Menu {
                ForEach(statuses, id: \.self) { s in
                    Button(s.capitalized, action: {
                        status = s
                    })
                }
            } label: {
                Text(status)
                .foregroundColor(self.getColor(status: status))
                .font(.callout)
                .fontWeight(.semibold)
                
            }
            .onAppear {
                if self.invoice.status != nil {
                    self.status = self.invoice.status!
                }
            }
            .menuStyle(.borderlessButton)
            .frame(width: 80)
            .offset(x: -2)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    func getColor(status: String?) -> Color {
        if status == "UNPAID" {
            return Color(hex:"#ffbe0b")
        } else if status == "OVERDUE" {
            return Color(hex:"#FF1E00")
        } else if status == "PAID" {
            return Color(hex:"#59CE8F")
        } else {
            return Color(hex:"#999")
        }
    }
}

struct InvoiceView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @Binding var navPath: NavigationPath
    @State private var showConfig = false
    private let statuses = ["DRAFT", "UNPAID", "PAID", "OVERDUE"]
    @State private var status = "DRAFT"
    private let currencies = ["EUR", "USD"]
    @State private var currency = "EUR"
    
    var body: some View {
        VStack {
            ScrollView {
                Spacer().frame(height: 40)
                InvoiceMetaView(invoice: invoice)
                Spacer().frame(height: 10)
                InvoiceNrView(invoice: invoice)
                Spacer().frame(height: 40)
                InvoiceHeadingView(invoice: invoice)
                Spacer().frame(height: 40)
                InvoiceItemsView(invoice: invoice)

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
                Picker("Select currency", selection: self.$currency) {
                    ForEach(currencies, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: self.currency, perform: { value in
                    self.invoice.currency = value
                    try? self.context.save()
                })
                .onAppear {
                    self.currency = self.invoice.currency != nil ? self.invoice.currency! : "EUR"
                }
                .pickerStyle(.menu)
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    showConfig = true
                }) {
                    Label("X", systemImage: "gear")
                }.popover(isPresented: $showConfig) {
                    InvoiceSidebarView(invoice: invoice)
                    .padding(15)
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
