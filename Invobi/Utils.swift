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
        return Color(hex:"#fff")
    }
}

func getStatusAltColor(status: String?) -> Color {
    if status == "UNPAID" {
        return Color(hex:"#fff")
    } else if status == "OVERDUE" {
        return Color(hex:"#fff")
    } else if status == "PAID" {
        return Color(hex:"#fff")
    } else {
        return Color(hex:"#444")
    }
}

func getStatusBorderColor(status: String?) -> Color {
    if status == "UNPAID" {
        return Color(hex:"#ffbe0b")
    } else if status == "OVERDUE" {
        return Color(hex:"#FF1E00")
    } else if status == "PAID" {
        return Color(hex:"#59CE8F")
    } else {
        return Color(hex:"#e5e5e5")
    }
}

func currencySignByCode(code: String) -> String {
    switch code {
    case "EUR":
        return "€"
    case "USD":
        return "$"
    default:
        return ""
    }
}

func currencySystemImageName(_ code: String) -> String {
    switch code {
    case "EUR":
        return "eurosign"
    case "USD":
        return "dollarsign"
    default:
        return ""
    }
}

func getDueInText(date: Date) -> String {
    let dueDays = getDayDiff(Date.now, date)
    
    if dueDays > 1 {
        return "Due in \(dueDays) days".uppercased()
    }
    
    if dueDays == 1 {
        return "Due tomorrow".uppercased()
    }
    
    if dueDays == 0 {
        return "Due today".uppercased()
    }
    
    if dueDays == -1 {
        return "Due yesterday".uppercased()
    }
    
    if dueDays < -1 {
        return "Due \(abs(dueDays)) days ago"
    }
    
    return ""
}
