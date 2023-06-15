//
//  InvoiceMetaView.swift
//  Invobi
//
//  Created by Asko Nomm on 12.06.2023.
//

import SwiftUI

struct InvoiceMetaView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var invoice: Invoice
    private let statuses = ["DRAFT", "PAID", "UNPAID", "OVERDUE"]
    @State private var status = "DRAFT"
    private let currencies = ["EUR", "USD"]
    @State private var showMeta = false
    @State private var hoveringStatusMenu = false
    @State private var hoveringCurrencyMenu = false
    @State private var hoveringDateIssuedMenu = false
    @State private var hoveringDueDateMenu = false
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
                .foregroundColor(Color(hex: "#999"))
                .frame(width: 22, height: 5)
                .padding(10)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .background(showMeta ? Color(hex: "#eee") : Color.white)
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
                        .onChange(of: hoveringCurrencyMenu) { _ in
                            self.hoveringCurrencyMenu = false
                        }
                        .onAppear {
                            if self.invoice.currency != nil {
                                self.currency = self.invoice.currency!
                            }
                        }
                        .menuStyle(.borderlessButton)
                        .frame(width: 45)
                        .overlay(RoundedRectangle(cornerRadius: 3, style: .continuous).stroke(hoveringCurrencyMenu ? Color(hex: "#bbb") : Color(hex: "#ccc")))
                        .onHover { over in
                            self.hoveringCurrencyMenu = over
                            
                        }
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
                        .onChange(of: hoveringStatusMenu) { _ in
                            self.hoveringStatusMenu = false
                        }
                        .onAppear {
                            if self.invoice.status != nil {
                                self.status = self.invoice.status!
                            }
                        }
                        .menuStyle(.borderlessButton)
                        .frame(width: 70)
                        .overlay(RoundedRectangle(cornerRadius: 3, style: .continuous).stroke(hoveringStatusMenu ? Color(hex: "#bbb") : Color(hex: "#ccc")))
                        .onHover { over in
                            self.hoveringStatusMenu = over
                            
                        }
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
                        .onChange(of: hoveringDateIssuedMenu) { _ in
                            self.hoveringDateIssuedMenu = false
                        }
                        .overlay(RoundedRectangle(cornerRadius: 3, style: .continuous).stroke(hoveringDateIssuedMenu ? Color(hex: "#bbb") : Color(hex: "#ccc")))
                        .onHover { over in
                            self.hoveringDateIssuedMenu = over
                        }
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
                        .onChange(of: hoveringDueDateMenu) { _ in
                            self.hoveringDueDateMenu = false
                        }
                        .overlay(RoundedRectangle(cornerRadius: 3, style: .continuous).stroke(hoveringDueDateMenu ? Color(hex: "#bbb") : Color(hex: "#ccc")))
                        .onHover { over in
                            self.hoveringDueDateMenu = over
                        }
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
