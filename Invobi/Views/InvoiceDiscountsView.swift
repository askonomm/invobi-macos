//
//  InvoiceDiscountsView.swift
//  Invobi
//
//  Created by Asko Nomm on 04.07.2023.
//

import SwiftUI

struct InvoiceDiscountsView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @State private var showActionsForDiscount: InvoiceDiscount?
    @State private var discounts: Array<InvoiceDiscount> = []

    var body: some View {
        VStack {
            ForEach(Array(discounts.enumerated()), id: \.element) { index, discount in
                VStack {
                    if index > 0 {
                        Spacer().frame(height: 15)
                    }
                    
                    ZStack {
                        InvoiceDiscountsDiscountView(invoice: invoice, discount: discount)
                            .offset(x: 24)
                        
                        if showActionsForDiscount == discount {
                            InvoiceDiscountsDiscountActionsView(discount: discount,
                                                                moveUp: moveUp,
                                                                moveDown: moveDown,
                                                                delete: delete,
                                                                isFirst: isFirst(discount),
                                                                isLast: isLast(discount))
                        }
                    }
                    .onHover { over in
                        withAnimation(.easeInOut(duration: 0.08)) {
                            if over {
                                showActionsForDiscount = discount
                            } else {
                                showActionsForDiscount = .none
                            }
                        }
                    }
                    .offset(x: -24)
                }
            }
            
            if getDiscounts().count > 0 {
                Spacer().frame(height: 15)
            }
            
            HStack {
                Button(action: addDiscount) {
                    Text("Add discount")
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 40)
        .onAppear {
            discounts = getDiscounts()
        }
    }
    
    private func getDiscounts() -> Array<InvoiceDiscount> {
        var discounts: Array<InvoiceDiscount> = []
        
        if invoice.discounts != nil {
            discounts = invoice.discounts!.allObjects as! [InvoiceDiscount]
        }
        
        return discounts.sorted { a, b in
            return a.order < b.order
        }
    }
    
    private func addDiscount() {
        withAnimation(.easeInOut(duration: 0.08)) {
            let discount = InvoiceDiscount(context: context);
            discount.name = ""
            discount.percentage = 0
            discount.value = 0
            discount.useValue = false
            discount.order = getDiscounts().last != nil ? getDiscounts().last!.order + 1 : 0
            
            invoice.addToDiscounts(discount)
            discounts.append(discount)
            
            try? context.save()
        }
    }
    
    private func moveUp(_ discount: InvoiceDiscount) {
        withAnimation(.easeInOut(duration: 0.08)) {
            let currentOrder = discount.order
            let newOrder = currentOrder - 1
            
            let replacingDiscount = discounts.first { discount in
                return discount.order == newOrder
            }
            
            discount.order = newOrder
            discounts[Int(currentOrder)] = replacingDiscount!
            discounts[Int(newOrder)] = discount
            replacingDiscount!.order = currentOrder
            
            self.showActionsForDiscount = .none
            
            try? context.save()
        }
    }
    
    private func moveDown(_ discount: InvoiceDiscount) {
        withAnimation(.easeInOut(duration: 0.08)) {
            let currentOrder = discount.order
            let newOrder = currentOrder + 1
            
            let replacingDiscount = discounts.first { discount in
                return discount.order == newOrder
            }
            
            discount.order = newOrder
            discounts[Int(currentOrder)] = replacingDiscount!
            discounts[Int(newOrder)] = discount
            replacingDiscount!.order = currentOrder
            
            self.showActionsForDiscount = .none
            
            try? context.save()
        }
    }
    
    private func delete(_ discount: InvoiceDiscount) {
        withAnimation(.easeInOut(duration: 0.08)) {
            self.context.delete(discount)
            
            // Remove discount
            self.discounts.removeAll { i in
                return i.order == discount.order
            }
            
            // Re-order all discounts because there can now be a gap
            discounts.indices.forEach { index in
                let f = discounts[index]
                f.order = Int32(index)
            }
            
            self.showActionsForDiscount = .none
            
            try? context.save()
        }
    }
    
    private func isFirst(_ item: InvoiceDiscount) -> Bool {
        return discounts.first == item
    }
    
    private func isLast(_ item: InvoiceDiscount) -> Bool {
        return discounts.last == item
    }
}
