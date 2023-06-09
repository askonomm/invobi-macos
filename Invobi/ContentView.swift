//
//  ContentView.swift
//  Invobi
//
//  Created by Asko Nomm on 07.06.2023.
//

import SwiftUI
import CoreData

struct ListInvoiceItemView: View {
    var invoice: Invoice
    @Binding var navPath: NavigationPath
    
    var body: some View {
        Button(action: {
            self.navPath.append(self.invoice)
        }) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Invoice #")
                            .font(.title3)
                            .fontWeight(.light)
                            .foregroundColor(Color(hex: "#777"))
                        Text("\(invoice.nr!)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .offset(x: -6)
                        Spacer()
                    }.frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    HStack(alignment: .top) {
                        Text("$500")
                        Spacer()
                        // green: 59CE8F
                        
                        if invoice.status != nil && invoice.status == "UNPAID" {
                            Text("Unpaid")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .foregroundColor(Color.white)
                                .background(Color(hex: "#FF1E00"))
                                .clipShape(Capsule())
                                .offset(y:-3)
                        }
                        
                        else if invoice.status != nil && invoice.status == "PAID" {
                            Text("Paid")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .foregroundColor(Color.white)
                                .background(Color(hex: "#59CE8F"))
                                .clipShape(Capsule())
                                .offset(y:-3)
                        } else {
                            Text("Draft")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .foregroundColor(Color.black)
                                .background(Color(hex: "#eee"))
                                .clipShape(Capsule())
                                .offset(y:-3)
                        }
                    }.frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.top, 15)
            .padding(.bottom, 10)
            .background(Color.white)
        }
        .buttonStyle(.plain)
        .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(hex: "#eeeeee")))
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Invoice.createdAt, ascending: true)],
        animation: .default)
    private var invoices: FetchedResults<Invoice>
    @State private var navPath = NavigationPath()
    @State private var editInvoiceView = false
    
    let columns = [
        GridItem(.adaptive(minimum: 250))
    ]

    var body: some View {
        NavigationStack(path: self.$navPath) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(invoices) { invoice in
                        ListInvoiceItemView(invoice: invoice, navPath: self.$navPath)
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
                        self.navPath.append(self.addItem())
                    }) {
                        Label("Create Invoice", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addItem() -> Invoice {
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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { invoices[$0] }.forEach(context.delete)

            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
