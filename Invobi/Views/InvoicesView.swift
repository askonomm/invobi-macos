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
    @State private var filteredInvoices: Array<Invoice> = []
    @State private var showFilters = false
    @State private var filterByDueDate = false
    @State private var dueDate = Date()
    @State private var filterByStatus = false
    @State private var status = "DRAFT"
    
    let columns = [
        GridItem(.adaptive(minimum: 275))
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if showFilters {
                    InvoicesFiltersView(filterByDueDate: $filterByDueDate,
                                        dueDate: $dueDate,
                                        filterByStatus: $filterByStatus,
                                        status: $status)
                }
                
                if filteredInvoices.count > 0 {
                    ForEach(filteredInvoices, id: \.self) { invoice in
                        InvoicesInvoiceView(invoice: invoice)
                    }
                } else {
                    Text("Couldn't find any matching invoices.")
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity).padding(40)
        }
        .onAppear {
            filterInvoices()
        }
        .onChange(of: filterByDueDate) { _ in
            filterInvoices()
        }
        .onChange(of: dueDate) { _ in
            filterInvoices()
        }
        .onChange(of: filterByStatus) { _ in
            filterInvoices()
        }
        .onChange(of: status) { _ in
            filterInvoices()
        }
        .background(colorScheme == .dark ? Color(hex: "#191919") : Color.white)
        .navigationTitle(Text("Invoices"))
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: addInvoice) {
                    Label("Create Invoice", systemImage: "plus")
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.08)) {
                        showFilters = !showFilters
                    }
                }) {
                    if showFilters {
                        Label("Show filters", systemImage: "slider.horizontal.3")
                            .foregroundColor(Color.blue)
                    } else {
                        Label("Hide filters", systemImage: "slider.horizontal.3")
                    }
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
    
    private func filterInvoices() {
        var invoices = invoices.map { return $0 }
        
        // filtering by due date?
        if filterByDueDate {
            print(dueDate)
            invoices = invoices.filter { invoice in
                return invoice.dueDate != nil && Calendar.current.isDate(invoice.dueDate!, equalTo: dueDate, toGranularity: .day)
            }
        }
        
        // filtering by status?
        if filterByStatus {
            invoices = invoices.filter { invoice in
                if status == "DRAFT" {
                    return invoice.status == nil || invoice.status! == status
                } else {
                    return invoice.status != nil && invoice.status! == status
                }
            }
        }
        
        filteredInvoices = invoices
    }
    
    private func addInvoice() {
        withAnimation(.easeInOut(duration: 0.08)) {
            let invoice = Invoice(context: context)
            invoice.nr = ""
            invoice.dateIssued = Date()
            invoice.dueDate = Date()
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
