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
            Button(action: {
                showMeta = !showMeta
            }) {
                Image(systemName: "ellipsis")
                .resizable()
                .foregroundColor(colorScheme == .dark ? Color(hex: "#777") : Color(hex: "#999"))
                .frame(width: 22, height: 5)
                .padding(10)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .background(showMeta ? colorScheme == .dark ? Color(hex: "#333") : Color(hex: "#eee") : colorScheme == .dark ? Color(hex: "#272727") : Color.white)
            .cornerRadius(10)
            .popover(isPresented: $showMeta, arrowEdge: .bottom) {
                VStack(alignment: .leading) {
                    HStack {
                        Label("Currency: ", systemImage: "centsign.circle")
                            .fontWeight(.semibold)
                        
                        Menu {
                            ForEach(currencies, id: \.self) { s in
                                if s != currency {
                                    Button(s, action: {
                                        currency = s
                                        invoice.currency = s
                                        try? context.save()
                                    })
                                }
                            }
                        } label: {
                            Text(currency)
                        }
                        .onAppear {
                            if self.invoice.currency != nil {
                                self.currency = self.invoice.currency!
                            }
                        }
                        .menuStyle(.borderlessButton)
                        .frame(width: 45)
                        .overlay(RoundedRectangle(cornerRadius: 3, style: .continuous).stroke(colorScheme == .dark ? Color(hex: "#777") : Color(hex: "#ccc")))
                        .offset(x: -8)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Label("Status: ", systemImage: "list.clipboard")
                            .fontWeight(.semibold)
                        
                        Menu {
                            ForEach(statuses, id: \.self) { s in
                                if s != status {
                                    Button(s.capitalized, action: {
                                        status = s
                                        invoice.status = s
                                        try? context.save()
                                    })
                                }
                            }
                        } label: {
                            Text(status.capitalized)
                        }
                        .onAppear {
                            if self.invoice.status != nil {
                                self.status = self.invoice.status!
                            }
                        }
                        .menuStyle(.borderlessButton)
                        .frame(width: 70)
                        .overlay(RoundedRectangle(cornerRadius: 3, style: .continuous).stroke(colorScheme == .dark ? Color(hex: "#777") : Color(hex: "#ccc")))
                        .offset(x: -8)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Label("Date issued: ", systemImage: "clock")
                            .fontWeight(.semibold)
                        
                        Button(action: {
                            showDateIssued = !showDateIssued
                        }) {
                            Text("\(dateIssued.formatted(.dateTime.day().month().year()))")
                            
                            if showDateIssued {
                                Image(systemName: "chevron.up")
                                    .resizable()
                                    .fontWeight(.bold)
                                    .frame(width: 7, height: 5)
                            } else {
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .fontWeight(.bold)
                                    .frame(width: 7, height: 5)
                            }
                        }
                        .contentShape(Rectangle())
                        .buttonStyle(.plain)
                        .overlay(RoundedRectangle(cornerRadius: 3, style: .continuous).stroke(colorScheme == .dark ? Color(hex: "#777") : Color(hex: "#ccc")))
                        .onAppear {
                            DispatchQueue.main.async {
                                if self.invoice.dateIssued != nil {
                                    self.dateIssued = self.invoice.dateIssued!
                                }
                            }
                        }
                        .popover(isPresented: $showDateIssued, arrowEdge: .bottom) {
                            DatePicker("Set date issued", selection: $dateIssued, displayedComponents: [.date])
                                .onChange(of: dateIssued) { _ in
                                    self.invoice.dateIssued = dateIssued
                                    try? context.save()
                                    self.showDateIssued = false
                                }
                                .datePickerStyle(.graphical)
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                        }
                        .offset(x: -6)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Label("Due date: ", systemImage: "clock.fill")
                            .fontWeight(.semibold)
                        
                        Button(action: {
                            showDueDate = !showDueDate
                        }) {
                            Text("\(dueDate.formatted(.dateTime.day().month().year()))")
                            
                            if showDueDate {
                                Image(systemName: "chevron.up")
                                    .resizable()
                                    .fontWeight(.bold)
                                    .frame(width: 7, height: 5)
                            } else {
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .fontWeight(.bold)
                                    .frame(width: 7, height: 5)
                            }
                        }
                        .contentShape(Rectangle())
                        .buttonStyle(.plain)
                        .overlay(RoundedRectangle(cornerRadius: 3, style: .continuous).stroke(colorScheme == .dark ? Color(hex: "#777") : Color(hex: "#ccc")))
                        .onAppear {
                            DispatchQueue.main.async {
                                if self.invoice.dueDate != nil {
                                    self.dueDate = self.invoice.dueDate!
                                }
                            }
                        }
                        .popover(isPresented: $showDueDate, arrowEdge: .bottom) {
                            DatePicker("Set due date", selection: $dueDate, displayedComponents: [.date])
                                .onChange(of: dueDate) { _ in
                                    self.invoice.dueDate = dueDate
                                    try? context.save()
                                    self.showDueDate = false
                                }
                                .datePickerStyle(.graphical)
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                        }
                        .offset(x: -6)
                        
                        Spacer()
                    }
                }
                .padding()
            }
        }
    }
}
