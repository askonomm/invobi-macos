//
//  InvoiceSidebarView.swift
//  Invobi
//
//  Created by Asko Nomm on 10.06.2023.
//

import SwiftUI

struct InvoiceSidebarView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    @State private var dateIssued = Date.now
    @State private var dueDate = Date.now
    private let currencies = ["EUR", "USD"]
    @State private var currency = "EUR"
    private let statuses = ["DRAFT", "UNPAID", "PAID", "OVERDUE"]
    @State private var status = "DRAFT"
    

    var body: some View {
        VStack(alignment: .leading) {
            // Date issued
            Group {
                Text("Date issued")
                    .font(.caption2)
                    .textCase(.uppercase)
                
                DatePicker("Select date issued", selection: self.$dateIssued, displayedComponents: .date)
                    .onChange(of: self.dateIssued, perform: { value in
                        self.invoice.dateIssued = value
                        try? self.context.save()
                    })
                    .onAppear {
                        self.dateIssued = self.invoice.dateIssued != nil ? self.invoice.dateIssued! : Date.now
                    }
                    .labelsHidden()
            }
                
            Spacer().frame(height:25)
            
            // Due date
            Group {
                Text("Due date")
                    .font(.caption2)
                    .textCase(.uppercase)
                
                DatePicker("Select due date", selection: self.$dueDate, displayedComponents: .date)
                    .onChange(of: self.dueDate, perform: { value in
                        self.invoice.dueDate = value
                        try? self.context.save()
                    })
                    .onAppear {
                        self.dueDate = self.invoice.dueDate != nil ? self.invoice.dueDate! : Date.now
                    }
                    .labelsHidden()
            }
            
            Spacer().frame(height:25)
            
            // Currency
            Group {
                Text("Currency")
                    .font(.caption2)
                    .textCase(.uppercase)
                
                Picker("Select currency", selection: self.$currency) {
                    ForEach(currencies, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: self.currency, perform: { value in
                    self.invoice.currency = value
                    try? self.context.save()
                })
                .onAppear {
                    self.currency = self.invoice.currency != nil ? self.invoice.currency! : "EUR"
                }
                .pickerStyle(.menu)
                .labelsHidden()
            }
            
            Spacer().frame(height:25)
            
            // Status
            Group {
                Text("Status")
                    .font(.caption2)
                    .textCase(.uppercase)
                
                Picker("Select status", selection: self.$status) {
                    ForEach(statuses, id: \.self) {
                        Text($0.capitalized)
                    }
                }
                .onChange(of: self.status, perform: { value in
                    self.invoice.status = value
                    try? self.context.save()
                })
                .onAppear {
                    self.status = self.invoice.status != nil ? self.invoice.status! : "DRAFT"
                }
                .pickerStyle(.menu)
                .labelsHidden()
            }
            
            Spacer()
        }
    }
}
