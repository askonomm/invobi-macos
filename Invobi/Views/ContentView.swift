//
//  ContentView.swift
//  Invobi
//
//  Created by Asko Nomm on 07.06.2023.
//

import SwiftUI
import CoreData

struct SplashView: View {
    @Environment(\.colorScheme) private var colorScheme
    var addInvoice: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .center) {
                Image("icon")
                    .resizable()
                    .frame(width: 110, height: 110)
                Spacer().frame(height: 10)
                Text("You have no invoices yet. ")
                    .font(.title3)
                    .foregroundColor(colorScheme == .dark ? Color(hex: "#ddd") : Color(hex: "#777"))
                Spacer().frame(height: 40)
                Button(action: addInvoice) {
                    Label("Create Invoice", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? Color(hex: "#111") : Color.white)
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
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
            if invoices.isEmpty {
                SplashView(addInvoice: {
                    onSelect(self.addInvoice())
                })
            } else {
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
                .background(colorScheme == .dark ? Color(hex: "#191919") : Color.white)
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
