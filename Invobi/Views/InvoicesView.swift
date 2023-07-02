//
//  InvoicesView.swift
//  Invobi
//
//  Created by Asko Nomm on 20.06.2023.
//

import SwiftUI

struct InvoicesView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Invoice.createdAt, ascending: false)],
        animation: .none)
    private var invoices: FetchedResults<Invoice>
    
    let columns = [
        GridItem(.adaptive(minimum: 275))
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                InvoicesSectionView(title: "Drafts", invoices: getInvoices(status: "DRAFT"))
                InvoicesSectionView(title: "Overdue", invoices: getInvoices(status: "OVERDUE"))
                InvoicesSectionView(title: "Unpaid", invoices: getInvoices(status: "UNPAID"))
                InvoicesSectionView(title: "Paid", invoices: getInvoices(status: "PAID"))
                Spacer()
            }
            .frame(maxWidth: .infinity).padding(40)
        }
        .background(colorScheme == .dark ? Color(hex: "#191919") : Color.white)
        .navigationTitle("Invoices")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: addInvoice) {
                    Label("Create Invoice", systemImage: "plus")
                }
            }
        }
    }
    
    private func getInvoices(status: String) -> Array<Invoice> {
        return invoices.filter { invoice in
            if status == "DRAFT" {
                return invoice.status == status || invoice.status == nil
            }
            
            return invoice.status == status
        }
    }
    
    private func addInvoice() {
        withAnimation(.easeInOut(duration: 0.08)) {
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
            
            appState.selectedInvoice = invoice
            appState.view = Views.invoice
        }
    }
}
