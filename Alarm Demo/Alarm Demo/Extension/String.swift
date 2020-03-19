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

    var isNever: Bool {
       self == "Never"
    }
}

