//
//  SplashView.swift
//  Invobi
//
//  Created by Asko Nomm on 20.06.2023.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .center) {
                Image("Icon")
                    .resizable()
                    .cornerRadius(35)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 25, y: 2)
                    .overlay(RoundedRectangle(cornerRadius: 35).stroke(.white, lineWidth: 2))
                    .frame(width: 60, height: 60)
                
                Spacer().frame(height: 15)
                
                Group {
                    Circle()
                        .fill(.white)
                        .frame(width: 8, height: 8)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.05), radius: 1, y: 1)
                        .offset(x: 0)
                    
                    Spacer().frame(height: 5)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 11, height: 11)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.05), radius: 1, y: 1)
                        .offset(x: -14)
                    
                    Spacer().frame(height: 5)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 15, height: 15)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.05), radius: 1, y: 1)
                        .offset(x: -4)
                }
                
                Spacer().frame(height: 20)
                
                Text("Oh-no! There's no invoices!")
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.05), radius: 1, y: 1)
                
                Spacer().frame(height: 50)
                
                Button(action: addInvoice) {
                    Label("Create Invoice", systemImage: "plus")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(getGradient("button-bg"))
                        .cornerRadius(25)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 20, y: 2)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        //.background(colorScheme == .dark ? Color(hex: "#111") : Color.white)
        .background(getGradient("bg"))
    }
    
    private func getGradient(_ k: String) -> LinearGradient {
        switch k {
        case "bg":
            return colorScheme == .dark ?
                LinearGradient(colors: [Color(hex: "#0086E8"), Color(hex: "#7B00C6")], startPoint: .top, endPoint: .bottom) :
                LinearGradient(colors: [Color(hex: "#EBF7FF"), Color(hex: "#ECCEFF")], startPoint: .top, endPoint: .bottom)
        case "button-bg":
            return colorScheme == .dark ?
                LinearGradient(colors: [Color(hex: "#2E005F"), Color(hex: "#110041")], startPoint: .top, endPoint: .bottom) :
                LinearGradient(colors: [Color(hex: "#B775FF"), Color(hex: "#8E66FF")], startPoint: .top, endPoint: .bottom)
        default:
            return LinearGradient(colors: [Color(hex: "#AFFFA1"), Color(hex: "#85FF91")], startPoint: .top, endPoint: .bottom)
        }
    }
    
    private func addInvoice() {
        withAnimation(.easeInOut(duration: 0.08)) {
            let invoice = Invoice(context: context)
            invoice.nr = ""
            invoice.createdAt = Date()
            invoice.status = "DRAFT"
            
            let item = InvoiceItem(context: context)
            item.name = ""
            item.qty = 1
            item.price = 0
            item.order = 0
            
            invoice.addToItems(item)
            
            try? context.save()
            
            appState.selectedInvoice = invoice
            appState.view = Views.invoice
        }
    }
}
