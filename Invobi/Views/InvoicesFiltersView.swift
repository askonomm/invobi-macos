//
//  InvoicesFiltersView.swift
//  Invobi
//
//  Created by Asko Nomm on 05.07.2023.
//

import SwiftUI

struct InvoicesFiltersDueDateFilterView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var filterByDueDate: Bool
    @Binding var dueDate: Date
    
    var body: some View {
        let colorA = colorScheme == .dark ? "#373737" : "#fff"
        let colorB = colorScheme == .dark ? "#373737" : "#fbfbfb"
        let colorC = colorScheme == .dark ? "#555" : "#ccc"
        let colorD = colorScheme == .dark ? "#272727" : "#fafafa"
        
        HStack {
            if filterByDueDate {
                HStack {
                    Label("Due date", systemImage: "clock")
                    
                    Spacer().frame(width: 10)
                    
                    DatePicker("Due date", selection: $dueDate, displayedComponents: [.date])
                        .datePickerStyle(.field)
                        .frame(width: 65, height: 25)
                    
                    Spacer().frame(width: 20)
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.08)) {
                            filterByDueDate = !filterByDueDate
                        }
                    }) {
                        Label("Remove due date filter", systemImage: "minus.circle.fill")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.plain)
                    .frame(height: 27)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
                .frame(height: 29)
            } else {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.08)) {
                        filterByDueDate = !filterByDueDate
                    }
                }) {
                    Label("Due date", systemImage: "clock")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 2)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .frame(height: 29)
            }
        }
        .background(LinearGradient(colors: [Color(hex: filterByDueDate ? colorB : colorA), Color(hex: filterByDueDate ? colorB : colorD)], startPoint: .top, endPoint: .bottom))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: colorC), lineWidth: 1))
        .cornerRadius(8)
        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: filterByDueDate ? 0 : 0.05), radius: 5, y: 2)
    }
}

struct InvoicesFiltersStatusFilterView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var filterByStatus: Bool
    @Binding var status: String
    
    var body: some View {
        let colorA = colorScheme == .dark ? "#373737" : "#fff"
        let colorB = colorScheme == .dark ? "#373737" : "#fbfbfb"
        let colorC = colorScheme == .dark ? "#555" : "#ccc"
        let colorD = colorScheme == .dark ? "#272727" : "#fafafa"
        
        HStack {
            if filterByStatus {
                HStack {
                    Label("Status", systemImage: "tray.2")
                    
                    Spacer().frame(width: 10)
                    
                    Picker("Status", selection: $status) {
                        Text("Draft").tag("DRAFT")
                        Text("Unpaid").tag("UNPAID")
                        Text("Paid").tag("PAID")
                        Text("Overdue").tag("OVERDUE")
                    }
                        .labelsHidden()
                        .frame(width: 90, height: 25)
                    
                    Spacer().frame(width: 8)
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.08)) {
                            filterByStatus = !filterByStatus
                        }
                    }) {
                        Label("Remove status filter", systemImage: "minus.circle.fill")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.plain)
                    .frame(height: 27)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
                .frame(height: 29)
            } else {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.08)) {
                        filterByStatus = !filterByStatus
                    }
                }) {
                    Label("Status", systemImage: "tray.2")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 2)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .frame(height: 29)
            }
        }
        .background(LinearGradient(colors: [Color(hex: filterByStatus ? colorB : colorA), Color(hex: filterByStatus ? colorB : colorD)], startPoint: .top, endPoint: .bottom))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: colorC), lineWidth: 1))
        .cornerRadius(8)
        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: filterByStatus ? 0 : 0.05), radius: 5, y: 2)
    }
}

struct InvoicesFiltersView: View {
    @Binding var filterByDueDate: Bool
    @Binding var dueDate: Date
    @Binding var filterByStatus: Bool
    @Binding var status: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Filters".uppercased())
                    .font(.callout)
                
                Spacer()
            }
            
            Spacer().frame(height: 15)
            
            HStack {
                InvoicesFiltersDueDateFilterView(filterByDueDate: $filterByDueDate, dueDate: $dueDate)
                Spacer().frame(width: 10)
                InvoicesFiltersStatusFilterView(filterByStatus: $filterByStatus, status: $status)
                Spacer()
            }
            
            Spacer().frame(height: 40)
        }
    }
}
