//
//  TimeFormatterManager.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/16/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

class TimeFormatterManager {
    static func timeFormatter(time: String) -> Date{
        let string = time
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        let result = df.date(from: string)
        return result!
    }
    
    static func timeFormatter() -> DateFormatter {
        let dateValue = DateFormatter()
        dateValue.dateFormat = "HH:mm a"
        dateValue.timeStyle = .short
        return dateValue
    }
}
