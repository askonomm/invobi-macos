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

func getDueInText(date: Date) -> String {
    let dueDays = getDayDiff(Date.now, date)
    
    if dueDays > 1 {
        return "Due in \(dueDays) days"
    }
    
    if dueDays == 1 {
        return "Due tomorrow"
    }
    
    if dueDays == 0 {
        return "Due today"
    }
    
    if dueDays == -1 {
        return "Due yesterday"
    }
    
    if dueDays < -1 {
        return "Due \(abs(dueDays)) days ago"
    }
    
    return ""
}
