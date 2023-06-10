//
//  Utils.swift
//  Invobi
//
//  Created by Asko Nomm on 10.06.2023.
//

import Foundation
import SwiftUI

func currencyCodeToSign(currency: String) -> String {
    return ""
}

func getDayDiff(_ a: Date, _ b: Date) -> Int {
    let diffs = Calendar.current.dateComponents([.day], from: a, to: b)
    
    return diffs.day! - 1
}

func getStatusColor(status: String?) -> Color {
    if status == "UNPAID" {
        return Color(hex:"#ffbe0b")
    } else if status == "OVERDUE" {
        return Color(hex:"#FF1E00")
    } else if status == "PAID" {
        return Color(hex:"#59CE8F")
    } else {
        return Color(hex:"#ddd")
    }
}

func getStatusTextColor(status: String?) -> Color {
    if status == "UNPAID" {
        return Color(hex:"#f77f00")
    } else if status == "OVERDUE" {
        return Color(hex:"#DD1A00")
    } else if status == "PAID" {
        return Color(hex:"#30A265")
    } else {
        return Color(hex:"#777")
    }
}
