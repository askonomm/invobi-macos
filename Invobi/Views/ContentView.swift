//
//  ContentView.swift
//  Invobi
//
//  Created by Asko Nomm on 07.06.2023.
//

import SwiftUI
import CoreData

enum Views {
    case invoices
    case invoice
}

class AppState: ObservableObject {
    @Published var selectedInvoice: Invoice?
    @Published var view: Views = Views.invoices
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Invoice.createdAt, ascending: false)],
        animation: .none)
    private var invoices: FetchedResults<Invoice>
    @StateObject var appState = AppState()

    var body: some View {
        VStack {
            switch appState.view {
            case .invoice:
                InvoiceView()
                    .transition(.move(edge: .trailing))
            case .invoices:
                if invoices.isEmpty {
                    SplashView()
                        .transition(.move(edge: .leading))
                } else {
                    InvoicesView()
                        .transition(.move(edge: .leading))
                }
            }
        }
        .environmentObject(appState)
        .environment(\.locale, .init(identifier: "et"))
        .frame(minWidth: 750, minHeight: 800)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
