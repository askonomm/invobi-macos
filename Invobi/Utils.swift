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
