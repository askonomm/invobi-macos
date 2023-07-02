//
//  InvoicesView.swift
//  Invobi
//
//  Created by Asko Nomm on 20.06.2023.
//

import SwiftUI

struct InvoicesSectionInvoiceView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.08)) {
                appState.selectedInvoice = invoice
                appState.view = Views.invoice
            }
        }) {
            VStack {
                HStack {
                    HStack {
                        Text("#")
                            .font(.title3)
                            .foregroundColor(Color.gray)
                            .fontWeight(.light)
                        
                        Text(invoice.nr ?? "")
                            .font(.title3)
                            .offset(x: -5)
                        
                        Spacer().frame(width: 8)
                        
                        Text(calculateTotal(invoice), format: .currency(code: invoice.currency ?? "EUR"))
                            .fontWeight(.light)
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    if invoice.status != "DRAFT" && invoice.status != "PAID" {
                        Text("Due \(displayDate(invoice.dueDate ?? Date.now))")
                            .opacity(0.5)
                    }
                }
                Spacer().frame(height: 10)
            }
        }
        .buttonStyle(.plain)
        .border(width: 1, edges: [.bottom], color: colorScheme == .dark ? Color(hex: "#333") : Color(hex: "#e5e5e5"))
        .contentShape(Rectangle())
        .onAppear {
            if invoice.dueDate != nil {
                if getDayDiff(invoice.dueDate!, Date.now) > 0 {
                    self.invoice.status = "OVERDUE"
                    try? context.save()
                }
            }
        }
    }
    
    private func calculateTotal(_ invoice: Invoice) -> Decimal {
        if invoice.items == nil {
            return 0
        }

        let items = invoice.items!.allObjects as! [InvoiceItem]
        
        // get subtotal
        let subTotal: Decimal = items.reduce(0) { result, item in
            let total: Decimal = (item.qty! as Decimal) * (item.price! as Decimal)
            
            return result + total
        }
        
        // get total taxed
        var taxedTotal: Decimal = 0
        
        if invoice.taxations != nil {
            let taxations = invoice.taxations!.allObjects as! [InvoiceTaxation]
            
            taxedTotal = taxations.reduce(0) { result, item in
                return result + ((item.percentage! as Decimal / 100) * subTotal)
            }
        }
        
        return subTotal + taxedTotal
    }
}

struct InvoicesSectionView: View {
    var title: String
    var invoices: Array<Invoice>
    
    var body: some View {
        if invoices.count > 0 {
            VStack {
                HStack {
                    Text(title.uppercased())
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
                Spacer().frame(height: 10)
                
                ForEach(Array(invoices.enumerated()), id: \.element) { index, invoice in
                    VStack {
                        if index > 0 {
                            Spacer().frame(height: 10)
                        }
                        
                        InvoicesSectionInvoiceView(invoice: invoice)
                    }
                }
                
                Spacer().frame(height: 40)
            }
        }
    }
}

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
