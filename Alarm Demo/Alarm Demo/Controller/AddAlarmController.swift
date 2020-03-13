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
    
    var temporaryTimeSaver: String = "5"
    var modifyExistTime: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        alarmTimePicker.backgroundColor = .black
        alarmTimePicker.setValue(UIColor.white, forKey: "textColor")
        
        let formatter = timeFormatter()
        alarmTimePicker.setDate(currentDateTime, animated: false)
        
        //如果是修改現有鬧鐘： TimePickerc變成原有鬧鐘時間，反之則採用當下時間
        print("\(temporaryTimeSaver)")
        temporaryTimeSaver = modifyExistTime ? temporaryTimeSaver : formatter.string(from: currentDateTime)
    }
    
    @IBAction func myTimePicker(_ sender: UIDatePicker){
        let dateValue = timeFormatter()
        temporaryTimeSaver = dateValue.string(from: alarmTimePicker.date)
    }
    
}

extension AddAlarmController {
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
    
    // UnwindSegue && Cancel barbuttonItem tag = 1, Save barbuttonItem tag = 2
    override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
        let alarmController = segue.destination as? AlarmController
        
        navigationBackItem()
        
        alarmController?.alarmTableView.isEditing = false
        alarmController?.leftBarbuttonItem.title = "Edit"
        //        alarmController?.modifyExistAlarm = false
        
        guard let button = sender as? UIBarButtonItem else { return }
        switch button.tag {
        case 2:
            alarmController?.mockDataLists.append(TimePickerManager(time: temporaryTimeSaver))
            modifyExistTime = false
        default:
            modifyExistTime = false
            break  
        }
        
        alarmController?.alarmTableView.reloadData()
    }
}
