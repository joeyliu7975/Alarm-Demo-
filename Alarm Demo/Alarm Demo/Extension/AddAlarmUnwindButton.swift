//
//  AddAlarmUnwindButton.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/18/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

extension AlarmController {
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue){
       }
       
       @IBAction func save(_ unwindSegue: UIStoryboardSegue){
    }
    
    @IBAction func deleteAlarm(_ unwindSegue: UIStoryboardSegue){
    }
}

//MARK: -PassedTextFieldLabel
extension AddAlarmController: PassTextFieldDelegate{
    func passText(alarmName: String) {
        alarmLabel = alarmName
    }
}

//MARK: -PassedSelectedDay[Bool]
extension AddAlarmController: PassDayCheckmarks{
    func passDayCheckMarks(array: [Bool]) {
        selectedRepeatDays = array
    }
}
