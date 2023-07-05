//
//  Utils.swift
//  Invobi
//
//  Created by Asko Nomm on 10.06.2023.
//

import Foundation
import SwiftUI

func getDayDiff(_ a: Date, _ b: Date) -> Int {
    let diffs = Calendar.current.dateComponents([.day], from: a, to: b)
    
    return diffs.day!
}

func displayDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    dateFormatter.locale = Locale(identifier: "en_US")
    
    return dateFormatter.string(from: date)
}

func calculateTotal(_ invoice: Invoice) -> Decimal {
    if invoice.items == nil {
        return 0
    }

    let items = invoice.items!.allObjects as! [InvoiceItem]
    
    // get subtotal
    let subTotal: Decimal = items.reduce(0) { result, item in
        let total: Decimal = (item.qty! as Decimal) * (item.price! as Decimal)
        
        return result + total
    }
    
    // get total discounted
    var discountedTotal: Decimal = 0
    
    if invoice.discounts != nil {
        let discounts = invoice.discounts!.allObjects as! [InvoiceDiscount]
        
        discountedTotal = discounts.reduce(0) { result, item in
            return result + ((item.percentage! as Decimal / 100) * subTotal)
        }
    }
    
    let subTotalDiscounted = subTotal - discountedTotal
    
    // get total taxed
    var taxedTotal: Decimal = 0
    
    if invoice.taxations != nil {
        let taxations = invoice.taxations!.allObjects as! [InvoiceTaxation]
        
        taxedTotal = taxations.reduce(0) { result, item in
            return result + ((item.percentage! as Decimal / 100) * subTotalDiscounted)
        }
    }
    
    return subTotalDiscounted + taxedTotal
}

func calculateDiscountTotal(invoice: Invoice, percentage: Decimal) -> Decimal {
    withAnimation(.easeInOut(duration: 0.08)) {
        var items: Array<InvoiceItem> = []
        
        if invoice.items != nil {
            items = invoice.items!.allObjects as! [InvoiceItem]
        }
        
        let subTotal: Decimal = items.reduce(0) { result, item in
            let total: Decimal = (item.qty! as Decimal) * (item.price! as Decimal)
            
            return result + total
        }
        
        var discount = (percentage / 100) * subTotal
        
        discount.negate()
        
        return discount
    }
}

func calculateTaxTotal(invoice: Invoice, percentage: Decimal) -> Decimal {
    var items: Array<InvoiceItem> = []
    
    if invoice.items != nil {
        items = invoice.items!.allObjects as! [InvoiceItem]
    }
    
    let subTotal: Decimal = items.reduce(0) { result, item in
        let total: Decimal = (item.qty! as Decimal) * (item.price! as Decimal)
        
        return result + total
    }
    
    // get total discounted
    var discountedTotal: Decimal = 0
    
    if invoice.discounts != nil {
        let discounts = invoice.discounts!.allObjects as! [InvoiceDiscount]
        
        discountedTotal = discounts.reduce(0) { result, item in
            return result + ((item.percentage! as Decimal / 100) * subTotal)
        }
    }
    
    let subTotalDiscounted = subTotal - discountedTotal
    
    return (percentage / 100) * subTotalDiscounted
}

func getCurrencies() -> Array<String> {
    return ["AED",
            "ARS",
            "AUD",
            "BGN",
            "BHD",
            "BRL",
            "CAD",
            "CHF",
            "CLP",
            "CNY",
            "COP",
            "CZK",
            "DKK",
            "EUR",
            "GBP",
            "HKD",
            "HUF",
            "IDR",
            "IDR",
            "ILS",
            "INR",
            "JPY",
            "KRW",
            "MXN",
            "MYR",
            "NOK",
            "NZD",
            "PEN",
            "PHP",
            "PLN",
            "RON",
            "RUB",
            "SAR",
            "SEK",
            "SGD",
            "THB",
            "TRY",
            "TWD",
            "USD",
            "ZAR"]
}
