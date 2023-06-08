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
        sortDescriptors: [NSSortDescriptor(keyPath: \Invoice.created_at, ascending: true)],
        animation: .default)
    private var invoices: FetchedResults<Invoice>

    var body: some View {
        NavigationView {
            List {
                ForEach(invoices) { invoice in
                    NavigationLink {
                        InvoiceView(invoice: invoice)
                    } label: {
                        Text("\(invoice.nr ?? "")")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Create Invoice", systemImage: "plus")
                    }
                }
            }
            
            Text("Create an invoice or select an existing one.")
        }
        .navigationTitle("")
    }

    private func addItem() {
        withAnimation {
            let newItem = Invoice(context: context)
            newItem.nr = "Untitled"
            newItem.created_at = Date()

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
