//
//  AddAlarmController.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/10/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

class AddAlarmController: UIViewController {

    @IBOutlet weak var alarmTimePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        alarmTimePicker.backgroundColor = .black
        alarmTimePicker.setValue(UIColor.white, forKey: "textColor")
    }

    
}
