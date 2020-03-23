//
//  File.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/23/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

extension AlarmController{
    func bubbleSorted(){
    guard mockDataLists.count > 1 else { return }
    for external in 0 ... mockDataLists.count - 1{
            let currentOne = TimeFormatterManager.timeFormatter(time: mockDataLists[external].time)
            for inner in 0 ... mockDataLists.count - 1{
                let replaceOne = TimeFormatterManager.timeFormatter(time: mockDataLists[inner].time)
                if currentOne < replaceOne {
                    let tempData:TimePickerManager = mockDataLists[external]
                    mockDataLists[external] = mockDataLists[inner]
                    mockDataLists[inner] = tempData
                }
            }
        }
    }
}
