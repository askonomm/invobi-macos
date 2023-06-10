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
        animation: .default)
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
                            ListInvoiceItemView(invoice: invoice, navPath: self.$navPath)
                        }
                        
                        if filteredStatus == "ALL" {
                            ListInvoiceItemView(invoice: invoice, navPath: self.$navPath)
                        }
                    }
                }.frame(maxWidth: .infinity).padding(20)
            }
            .background(Color.white)
                .navigationDestination(for: Invoice.self) { invoice in
                    InvoiceView(invoice: invoice, navPath: self.$navPath)
                }
        }
        .navigationTitle("Invoices")
        .toolbar {
            if self.navPath.isEmpty {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        self.navPath.append(self.addInvoice())
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

    private func addInvoice() -> Invoice {
        let newItem = Invoice(context: context)
        newItem.nr = ""
        newItem.createdAt = Date()

        do {
            try context.save()
            return newItem
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
