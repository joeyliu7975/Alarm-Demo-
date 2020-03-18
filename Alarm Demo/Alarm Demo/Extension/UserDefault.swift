//
//  UserDefault.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/18/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

extension AlarmController {
    func saveUserDefault(){
           switch mockDataLists.count {
           case 0:
              removeUserDefault()
           default:
               let encoder = JSONEncoder()
               if let encoded = try? encoder.encode(mockDataLists) {
                   defaults.set(encoded, forKey: "data")
               }
           }
       }
       
       func loadUserDefault() {
           guard let data = defaults.data(forKey: "data") else { return }
           let decoder = JSONDecoder()
           if let loadedData = try? decoder.decode([TimePickerManager].self, from: data) {
               mockDataLists = loadedData
           }
       }
       
       func removeUserDefault() {
           let domain = Bundle.main.bundleIdentifier!
                     UserDefaults.standard.removePersistentDomain(forName: domain)
                     UserDefaults.standard.synchronize()
       }
}
