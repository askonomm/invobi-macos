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
                    .cornerRadius(20)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 20, y: 2)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 0, green: 0, blue: 0, opacity: 0.2), lineWidth: 1))
                    .frame(width: 65, height: 65)
                
                Spacer().frame(height: 15)
                
                Group {
                    Circle()
                        .fill(.white)
                        .frame(width: 8, height: 8)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 2, y: 2)
                        .offset(x: 0)
                    
                    Spacer().frame(height: 5)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 11, height: 11)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 2, y: 2)
                        .offset(x: -14)
                    
                    Spacer().frame(height: 5)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 15, height: 15)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 2, y: 2)
                        .offset(x: -4)
                }
                
                Spacer().frame(height: 20)
                
                Text("Beep-boop, could not find invoices.")
                    .font(.body)
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.1), radius: 2, y: 2)
                
                Spacer().frame(height: 50)
                
                Button(action: addInvoice) {
                    Label("Create Invoice", systemImage: "plus")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(LinearGradient(colors: [Color(hex: "#00BF13"), Color(hex: "#00B512")], startPoint: .top, endPoint: .bottom))
                .cornerRadius(25)
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 20, y: 2)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 0, green: 0, blue: 0, opacity: 0.4), lineWidth: 1))
                
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
                LinearGradient(colors: [Color(hex: "#003605"), Color(hex: "#003605")], startPoint: .top, endPoint: .bottom) :
                LinearGradient(colors: [Color(hex: "#AFFFA1"), Color(hex: "#85FF91")], startPoint: .top, endPoint: .bottom)
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
