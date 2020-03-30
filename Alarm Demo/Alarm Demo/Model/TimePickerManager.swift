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
//    var snooze: Bool = true
}

