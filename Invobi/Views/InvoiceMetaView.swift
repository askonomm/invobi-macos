//
//  InvoiceMetaView.swift
//  Invobi
//
//  Created by Asko Nomm on 12.06.2023.
//

import SwiftUI

struct InvoiceMetaView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    private let statuses = ["DRAFT", "PAID", "UNPAID", "OVERDUE"]
    @State private var status = "DRAFT"
    private let currencies = ["EUR", "USD"]
    @State private var showMeta = false
    @State private var currency = "EUR"
    @State private var dateIssued = Date.now
    @State private var showDateIssued = false
    @State private var dueDate = Date.now
    @State private var showDueDate = false
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    Text(String(localized: "Currency").uppercased())
                        .font(.subheadline)
                        //.fontWeight(.semibold)
                    Spacer()
                }
                
                Spacer().frame(height: 10)
                
                HStack {
                    Picker("Choose a currency", selection: $currency) {
                        ForEach(getCurrencies(), id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .onChange(of: currency) { _ in
                        withAnimation(.easeInOut(duration: 0.08)) {
                            self.invoice.currency = currency
                            try? context.save()
                        }
                    }
                    .onAppear {
                        if self.invoice.currency != nil {
                            self.currency = self.invoice.currency!
                        }
                    }
                    .labelsHidden()
                    .frame(width: 65)
                    
                    Spacer()
                }
            }
            
            Group {
                Spacer().frame(height: 20)
                Divider()
                Spacer().frame(height: 20)
            }
            
            Group {
                HStack {
                    Text(String(localized: "Status").uppercased())
                        .font(.subheadline)
                        //.fontWeight(.semibold)
                    Spacer()
                }
                
                Spacer().frame(height: 10)
                
                HStack {
                    Picker("Select status", selection: $status) {
                        Text("Draft").tag("DRAFT")
                        Text("Paid").tag("PAID")
                        Text("Unpaid").tag("UNPAID")
                        Text("Overdue").tag("OVERDUE")
                    }
                    .onChange(of: status) { _ in
                        withAnimation(.easeInOut(duration: 0.08)) {
                            self.invoice.status = status
                            try? context.save()
                        }
                    }
                    .onAppear {
                        if self.invoice.status != nil {
                            self.status = self.invoice.status!
                        }
                    }
                    .labelsHidden()
                    .frame(width: 90)
                    
                    Spacer()
                }
            }
            
            Group {
                Spacer().frame(height: 20)
                Divider()
                Spacer().frame(height: 20)
            }
            
            Group {
                HStack {
                    Text(String(localized: "Date issued").uppercased())
                        .font(.subheadline)
                        //.fontWeight(.semibold)
                    Spacer()
                }
                
                Spacer().frame(height: 10)
                
                DatePicker("Select issued date", selection: $dateIssued, displayedComponents: [.date])
                    .onChange(of: dateIssued) { _ in
                        withAnimation(.easeInOut(duration: 0.08)) {
                            self.invoice.dateIssued = dateIssued
                            try? context.save()
                        }
                    }
                    .onAppear {
                        if self.invoice.dateIssued != nil {
                            self.dateIssued = self.invoice.dateIssued!
                        }
                    }
                    .labelsHidden()
            }
            
            Group {
                Spacer().frame(height: 20)
                Divider()
                Spacer().frame(height: 20)
            }
            
            Group {
                HStack {
                    Text(String(localized: "Due date").uppercased())
                        .font(.subheadline)
                        //.fontWeight(.semibold)
                    Spacer()
                }
                
                Spacer().frame(height: 10)
                
                DatePicker("Select due date", selection: $dueDate, displayedComponents: [.date])
                    .onChange(of: dueDate) { _ in
                        withAnimation(.easeInOut(duration: 0.08)) {
                            self.invoice.dueDate = dueDate
                            try? context.save()
                        }
                    }
                    .onAppear {
                        if self.invoice.dueDate != nil {
                            self.dueDate = self.invoice.dueDate!
                        }
                    }
                    .labelsHidden()
            }
            
            Spacer()
        }
    }
}
