//
//  ExtensionString.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/18/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

extension String{
    
    func lowercasedFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
//
    mutating func lowercasedFirstLetter() {
        self = self.lowercasedFirstLetter()
    }
    
//    mutating func isNever() -> Bool {
//        if self == "Never" {
//            return true
//        } else {
//            return false
//        }
    
//    func isNever() -> Bool {
//        if self == "Never"{
//            return true
//        } else {
//            return false
//        }
//    }
    
    var isNever: Bool {
       self == "Never"
    }
}

