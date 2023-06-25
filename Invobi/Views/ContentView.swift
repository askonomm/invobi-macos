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
    @Environment(\.colorScheme) private var colorScheme
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Invoice.createdAt, ascending: false)],
        animation: .none)
    private var invoices: FetchedResults<Invoice>
    @State private var navPath = NavigationPath()

    var body: some View {
        NavigationStack(path: self.$navPath) {
            if invoices.isEmpty {
                SplashView(addInvoice: {
                    onSelect(self.addInvoice())
                })
            } else {
                InvoicesView(onSelect: onSelect, onDelete: onDelete, addInvoice: addInvoice, navPath: $navPath)
                    .id(navPath.count)
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
        invoice.status = "DRAFT"
        
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
