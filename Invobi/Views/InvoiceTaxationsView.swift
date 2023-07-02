//
//  InvoiceTaxations.swift
//  Invobi
//
//  Created by Asko Nomm on 14.06.2023.
//

import SwiftUI

struct InvoiceTaxationsView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @State private var showActionsForTaxation: InvoiceTaxation?
    @State private var taxations: Array<InvoiceTaxation> = []

    var body: some View {
        VStack {
            ForEach(Array(taxations.enumerated()), id: \.element) { index, taxation in
                VStack {
                    if index > 0 {
                        Spacer().frame(height: 15)
                    }
                    
                    ZStack {
                        InvoiceTaxationsTaxationView(invoice: invoice, taxation: taxation)
                            .offset(x: 24)
                        
                        if showActionsForTaxation == taxation {
                            InvoiceTaxationsTaxationActionsView(taxation: taxation,
                                                                moveUp: moveUp,
                                                                moveDown: moveDown,
                                                                delete: delete,
                                                                isFirst: isFirst(taxation),
                                                                isLast: isLast(taxation))
                        }
                    }
                    .onHover { over in
                        withAnimation(.easeInOut(duration: 0.08)) {
                            if over {
                                showActionsForTaxation = taxation
                            } else {
                                showActionsForTaxation = .none
                            }
                        }
                    }
                    .offset(x: -24)
                }
            }
            
            if getTaxations().count > 0 {
                Spacer().frame(height: 15)
            }
            
            HStack {
                Button(action: addTaxation) {
                    Text("Add taxation")
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 40)
        .onAppear {
            taxations = getTaxations()
        }
    }
    
    private func getTaxations() -> Array<InvoiceTaxation> {
        var taxations: Array<InvoiceTaxation> = []
        
        if invoice.taxations != nil {
            taxations = invoice.taxations!.allObjects as! [InvoiceTaxation]
        }
        
        return taxations.sorted { a, b in
            return a.order < b.order
        }
    }
    
    private func addTaxation() {
        withAnimation(.easeInOut(duration: 0.08)) {
            let taxation = InvoiceTaxation(context: context);
            taxation.name = ""
            taxation.percentage = 0
            taxation.order = getTaxations().last != nil ? getTaxations().last!.order + 1 : 0
            
            invoice.addToTaxations(taxation)
            taxations.append(taxation)
            
            try? context.save()
        }
    }
    
    private func moveUp(_ taxation: InvoiceTaxation) {
        withAnimation(.easeInOut(duration: 0.08)) {
            let currentOrder = taxation.order
            let newOrder = currentOrder - 1
            
            let replacingTaxation = taxations.first { taxation in
                return taxation.order == newOrder
            }
            
            taxation.order = newOrder
            taxations[Int(currentOrder)] = replacingTaxation!
            taxations[Int(newOrder)] = taxation
            replacingTaxation!.order = currentOrder
            
            self.showActionsForTaxation = .none
            
            try? context.save()
        }
    }
    
    private func moveDown(_ taxation: InvoiceTaxation) {
        withAnimation(.easeInOut(duration: 0.08)) {
            let currentOrder = taxation.order
            let newOrder = currentOrder + 1
            
            let replacingTaxation = taxations.first { taxation in
                return taxation.order == newOrder
            }
            
            taxation.order = newOrder
            taxations[Int(currentOrder)] = replacingTaxation!
            taxations[Int(newOrder)] = taxation
            replacingTaxation!.order = currentOrder
            
            self.showActionsForTaxation = .none
            
            try? context.save()
        }
    }
    
    private func delete(_ taxation: InvoiceTaxation) {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.context.delete(taxation)
            
            // Remove taxation
            self.taxations.removeAll { i in
                return i.order == taxation.order
            }
            
            // Re-order all taxations because there can now be a gap
            taxations.indices.forEach { index in
                let f = taxations[index]
                f.order = Int32(index)
            }
            
            self.showActionsForTaxation = .none
            
            try? context.save()
        }
    }
    
    private func isFirst(_ item: InvoiceTaxation) -> Bool {
        return taxations.first == item
    }
    
    private func isLast(_ item: InvoiceTaxation) -> Bool {
        return taxations.last == item
    }
}
