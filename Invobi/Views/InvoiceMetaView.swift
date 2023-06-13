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
    @State private var showStatuses = false
    @State private var currency = "EUR"
    @State private var showCurrencies = false
    @State private var dateIssued = Date.now
    @State private var showDateIssued = false
    @State private var dueDate = Date.now
    @State private var showDueDate = false
    
    var body: some View {
        HStack(alignment: .top) {
            Button(action: {
                showCurrencies = !showCurrencies
            }) {
                Label(currency, systemImage: currencySystemImageName(currency))
                .foregroundColor(Color(hex: "#666"))
                .font(.callout)
                
                if showCurrencies {
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
            .onAppear {
                DispatchQueue.main.async {
                    if self.invoice.currency != nil {
                        self.currency = self.invoice.currency!
                    }
                }
            }
            .popover(isPresented: $showCurrencies, arrowEdge: .bottom) {
                VStack {
                    Text("Currency".uppercased())
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#666"))
                    
                    Spacer().frame(height: 10)
                    
                    ForEach(currencies, id: \.self) { s in
                        if s != currency {
                            Button("\(currencySignByCode(code: s)) \(s)", action: {
                                currency = s
                                invoice.currency = s
                                try? context.save()
                                showCurrencies = false
                            })
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .buttonStyle(.plain)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .foregroundColor(Color(hex: "#444"))
                            .background(Color(hex: "#fff"))
                            .cornerRadius(6)
                        }
                    }
                }
                .padding()
            }
            
            Spacer().frame(width: 20)
            
            Button(action: {
                showStatuses = !showStatuses
            }) {
                Label(status.uppercased(), systemImage: "list.bullet.clipboard")
                .foregroundColor(getColor(status: status))
                .font(.callout)
                
                if showStatuses {
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
            .onAppear {
                DispatchQueue.main.async {
                    if self.invoice.status != nil {
                        self.status = self.invoice.status!
                    }
                }
            }
            .popover(isPresented: $showStatuses, arrowEdge: .bottom) {
                VStack {
                    Text("Status".uppercased())
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#666"))
                    
                    Spacer().frame(height: 10)
                    
                    ForEach(statuses, id: \.self) { s in
                        if s != status {
                            Button("\(currencySignByCode(code: s)) \(s)", action: {
                                status = s
                                invoice.status = s
                                try? context.save()
                                showStatuses = false
                            })
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                            .buttonStyle(.plain)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .foregroundColor(getStatusAltColor(status: s))
                            .background(getStatusBorderColor(status: s))
                            .cornerRadius(6)
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            Button(action: {
                showDateIssued = !showDateIssued
            }) {
                Label("\(dateIssued.formatted(.dateTime.day().month().year()))".uppercased(), systemImage: "clock")
                .foregroundColor(Color(hex: "#666"))
                .font(.callout)
                
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
            .onAppear {
                DispatchQueue.main.async {
                    if self.invoice.dateIssued != nil {
                        self.dateIssued = self.invoice.dateIssued!
                    }
                }
            }
            .popover(isPresented: $showDateIssued, arrowEdge: .bottom) {
                VStack {
                    Text("Date issued".uppercased())
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#666"))
                        .padding(.top)
                    
                    Spacer().frame(height: 10)
                    
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
            }
            
            Spacer().frame(width: 20)
            
            Button(action: {
                showDueDate = !showDueDate
            }) {
                Label("\(dueDate.formatted(.dateTime.day().month().year()))".uppercased(), systemImage: "alarm.waves.left.and.right")
                .foregroundColor(Color(hex: "#666"))
                .font(.callout)
                
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
            .onAppear {
                DispatchQueue.main.async {
                    if self.invoice.dueDate != nil {
                        self.dueDate = self.invoice.dueDate!
                    }
                }
            }
            .popover(isPresented: $showDueDate, arrowEdge: .bottom) {
                VStack {
                    Text("Due date".uppercased())
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#666"))
                        .padding(.top)
                    
                    Spacer().frame(height: 10)
                    
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
            }
        }
        .padding(.horizontal, 40)
    }
    
    func getColor(status: String?) -> Color {
        if status == "UNPAID" {
            return Color(hex:"#ffbe0b")
        } else if status == "OVERDUE" {
            return Color(hex:"#FF1E00")
        } else if status == "PAID" {
            return Color(hex:"#59CE8F")
        } else {
            return Color(hex:"#999")
        }
    }
}
