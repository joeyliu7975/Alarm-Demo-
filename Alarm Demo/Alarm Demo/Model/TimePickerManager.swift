//
//  TimePickerManager.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/10/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

struct TimePickerManager:Codable {
    
    var time: String
    var switchButtonIsOn: Bool = true
    var label: String = "Alarm"
    var repeatDay = [Bool]()
    var info: String{
        var labels = [String]()
        var showLabel: String = ""
        for (index, value) in repeatDay.enumerated() {
            if value {
                switch index {
                case 0:
                    labels.append("Sun")
                case 1:
                    labels.append("Mon")
                case 2:
                    labels.append("Tue")
                case 3:
                    labels.append("Wed")
                case 4:
                    labels.append("Thu")
                case 5:
                    labels.append("Fri")
                case 6:
                    labels.append("Sat")
                default:
                    continue
                }
            }
        }
        
        switch labels {
        case ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]:
            showLabel = "Everyday"
        case ["Sun", "Sat"]:
            showLabel = "Weekends"
        case ["Mon", "Tue", "Wed", "Thu", "Fri"]:
            showLabel = "Weekdays"
        case []:
            showLabel = "Never"
        case ["Sun"]:
            showLabel = "Every Sunday"
        case ["Mon"]:
            showLabel = "Every Monday"
        case ["Tue"]:
            showLabel = "Every Tuesday"
        case ["Wed"]:
            showLabel = "Every Wednesay"
        case ["Thu"]:
            showLabel = "Every Thursday"
        case ["Fri"]:
            showLabel = "Every Friday"
        case ["Sat"]:
            showLabel = "Every Satday"
        default:
            for i in 0...labels.count - 1 {
                if i != 0 {
                    showLabel += " \(labels[i])"
                } else {
                    showLabel += "\(labels[i])"
                }
            }
        }
        return showLabel
    }
//    var snooze: Bool = true
}

