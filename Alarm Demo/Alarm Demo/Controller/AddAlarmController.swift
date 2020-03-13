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
    let currentDateTime = Date()
    
    var timeTemporarySaver: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        alarmTimePicker.backgroundColor = .black
        alarmTimePicker.setValue(UIColor.white, forKey: "textColor")
        
        let formatter = timeFormatter()
        alarmTimePicker.setDate(currentDateTime, animated: false)
        
        timeTemporarySaver = formatter.string(from: currentDateTime)
    }
    
    @IBAction func myTimePicker(_ sender: UIDatePicker){
        let dateValue = timeFormatter()
        timeTemporarySaver = dateValue.string(from: alarmTimePicker.date)
    }
    
    // cancel barbuttonItem tag = 1, save barbuttonItem tag = 2.
    
    override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
        let alarmController = segue.destination as? AlarmController
        
        navigationBackItem()
        
        guard let button = sender as? UIBarButtonItem else { return }
        if button.tag == 2 {
            alarmController?.mockDataLists.append(TimePickerManager(time: timeTemporarySaver))
        } else {
            return
        }
        alarmController?.alarmTableView.reloadData()
    }
    
    func navigationBackItem() {
        let backItem = UIBarButtonItem()
        backItem.title = "back"
        backItem.tintColor = UIColor.orange
        navigationItem.backBarButtonItem = backItem
    }
    func timeFormatter() -> DateFormatter {
        let dateValue = DateFormatter()
        dateValue.dateFormat = "HH:mm a"
        dateValue.timeStyle = .short
        return dateValue
    }
}
