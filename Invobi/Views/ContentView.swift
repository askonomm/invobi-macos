//
//  ContentView.swift
//  Invobi
//
//  Created by Asko Nomm on 07.06.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Invoice.createdAt, ascending: false)],
        animation: .none)
    private var invoices: FetchedResults<Invoice>
    @State private var navPath = NavigationPath()
    @State private var editInvoiceView = false
    @State private var filteredStatus = "ALL"
    
    let columns = [
        GridItem(.adaptive(minimum: 275))
    ]

    var body: some View {
        NavigationStack(path: self.$navPath) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(invoices) { invoice in
                        if filteredStatus != "ALL" && ((invoice.status == filteredStatus) || (invoice.status == nil && filteredStatus == "DRAFT")) {
                            ListInvoiceItemView(invoice: invoice, onSelect: onSelect)
                        }
                        
                        else if filteredStatus == "ALL" {
                            ListInvoiceItemView(invoice: invoice, onSelect: onSelect)
                        } else {
                            EmptyView()
                        }
                    }
                }.frame(maxWidth: .infinity).padding(40)
            }
            .background(Color.white)
            .navigationTitle("Invoices")
            .navigationDestination(for: Invoice.self) { invoice in
                InvoiceView(invoice: invoice, onDelete: onDelete)
            }
            .toolbar {
                if self.navPath.isEmpty {
                    ToolbarItem(placement: .navigation) {
                        Button(action: {
                            let invoice = self.addInvoice()
                            
                            onSelect(invoice)
                        }) {
                            Label("Create Invoice", systemImage: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .secondaryAction) {
                        Picker(selection: $filteredStatus, label: Text("Sorting options")) {
                            Text("All").tag("ALL")
                            Text("Unpaid").tag("UNPAID")
                            Text("Paid").tag("PAID")
                            Text("Overdue").tag("OVERDUE")
                            Text("Draft").tag("DRAFT")
                        }
                    }
                }
            }
        }
        .frame(minWidth: 750)
    }
    
    private func onSelect(_ invoice: Invoice) {
        self.navPath.append(invoice)
    }
    
    private func onDelete(invoice: Invoice) {
        self.navPath.removeLast(self.navPath.count)
        context.delete(invoice)
    }

    private func addInvoice() -> Invoice {
        let invoice = Invoice(context: context)
        invoice.nr = ""
        invoice.createdAt = Date()
        
        let item = InvoiceItem(context: context)
        item.name = ""
        item.qty = 1
        item.price = 0
        item.order = 0
        
        invoice.addToItems(item)

        try? context.save()
        
        return invoice
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
