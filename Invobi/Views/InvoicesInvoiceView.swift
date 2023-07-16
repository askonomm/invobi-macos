//
//  InvoicesSectionInvoiceView.swift
//  Invobi
//
//  Created by Asko Nomm on 02.07.2023.
//

import SwiftUI

struct InvoicesInvoiceView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var invoice: Invoice
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.08)) {
                appState.selectedInvoice = invoice
                appState.view = Views.invoice
            }
        }) {
            VStack(spacing: 0) {
                Spacer().frame(height: 8)
                HStack {
                    HStack {
                        Text("#")
                            .font(.title3)
                            .foregroundColor(Color.gray)
                            .fontWeight(.light)
                        
                        Text(invoice.nr ?? "")
                            .font(.title3)
                            .offset(x: -5)
                        
                        Spacer().frame(width: 8)
                        
                        Text(calculateTotal(invoice), format: .currency(code: invoice.currency ?? "EUR"))
                            .fontWeight(.light)
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    Text((invoice.dueDate != nil ? invoice.dueDate! : Date.now).formatted(.dateTime.day().month().year()))
                        .opacity(0.5)
                    
                    Spacer().frame(width: 10)
                    
                    HStack {
                        Spacer()
                        Text(NSLocalizedString(invoice.status!.capitalized, comment: "").uppercased())
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(getInvoiceStatusForegroundColor(invoice.status))
                        Spacer()
                    }
                    .padding(.vertical, 3)
                    .background(getInvoiceStatusBackgroundColor(invoice.status))
                    .cornerRadius(8)
                    .frame(width: 80)
                }
                Spacer().frame(height: 10)
            }
            
            .accessibilityLabel("\(Text("Invoice")) \(invoice.nr ?? "")")
            .border(width: 1, edges: [.bottom], color: colorScheme == .dark ? Color(hex: "#333") : Color(hex: "#e5e5e5"))
            .contentShape(Rectangle())
            .onAppear {
                if invoice.dueDate != nil {
                    if getDayDiff(invoice.dueDate!, Date.now) > 0 && invoice.status != "PAID" {
                        self.invoice.status = "OVERDUE"
                        try? context.save()
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private func getInvoiceStatusForegroundColor(_ status: String?) -> Color {
        if status == nil || status == "DRAFT" || status == "UNPAID" {
            return colorScheme == .dark ? .white : Color(hex: "#333")
        }
        
        return Color.white
    }
    
    private func getInvoiceStatusBackgroundColor(_ status: String?) -> Color {
        if status == nil || status == "DRAFT" {
            return colorScheme == .dark ? Color(hex: "#373737") : Color(hex: "#eee")
        }
        
        if status == "PAID" {
            return colorScheme == .dark ? Color(hex: "#05a47b") : Color(hex: "#06d6a0")
        }
        
        if status == "UNPAID" {
            return colorScheme == .dark ? Color(hex: "#ffb711") : Color(hex: "#ffd166")
        }
        
        return Color(hex: "#ef476f")
    }
}
