//
//  AddAlarmController.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/10/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

class AddAlarmController: UIViewController{
       
    @IBOutlet weak var alarmTimePicker: UIDatePicker! {
        didSet {
            alarmTimePicker.backgroundColor = .black
            alarmTimePicker.setValue(UIColor.white, forKey: "textColor")
        }
    }
    let currentDateTime = Date()
    
    var timePickerManager: TimePickerManager?
    var tableViewCell: TableViewCell?
    var temporaryTimeSaver: String = ""
    var modifyExistTime: Bool = false
    var modifyExistRow: Int = -1
    //label顯示畫面初始化質：
    var alarmLabel: String = "Alarm" 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
        
        let formatter = timeFormatter()
         //如果是修改現有鬧鐘： TimePickerc變成原有鬧鐘時間，反之則採用當下時間
        temporaryTimeSaver = modifyExistTime ? temporaryTimeSaver : formatter.string(from: currentDateTime)
        
        //判斷是否有存取現有Alarm
        
        switch temporaryTimeSaver {
        case "":
            alarmTimePicker.setDate(currentDateTime, animated: false)
        default:
            let string = temporaryTimeSaver
            let df = DateFormatter()
            df.dateFormat = "hh:mm a"
            let result = df.date(from: string)
            alarmTimePicker.setDate(result!, animated: false)
        }
    }
}

extension AddAlarmController{
   
    // UnwindSegue && Cancel barbuttonItem tag = 1, Save barbuttonItem tag = 2
    override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
        let alarmController = segue.destination as? AlarmController
        
        if let staticTableView = segue.destination as? TableViewInsideContainerViewTableViewController {
            staticTableView.delegate = self
            staticTableView.alarmString = alarmLabel
        }
        
        navigationBackItem()
        
        alarmController?.alarmTableView.isEditing = false
        alarmController?.leftBarbuttonItem.title = "Edit"
        alarmController?.isEditMode  = false
        
        // MARK: -Switch(Cancel/Save鍵, modifyExistTime)
        guard let button = sender as? UIBarButtonItem else { return }
        switch (button.tag, modifyExistTime) {
        case (2, false):
            alarmController?.mockDataLists.append(TimePickerManager(time: temporaryTimeSaver, label: alarmLabel))
            modifyExistTime = false
            self.tabBarController?.tabBar.isHidden = false
            alarmController?.bubbleSorted()
            alarmController?.alarmTableView.reloadData()
        case (2, true):
            alarmController?.mockDataLists[modifyExistRow].time = temporaryTimeSaver
            alarmController?.mockDataLists[modifyExistRow].switchButtonIsOn = true
            alarmController?.mockDataLists[modifyExistRow].label = alarmLabel
            modifyExistTime = false
            self.tabBarController?.tabBar.isHidden = false
            alarmController?.bubbleSorted()
            alarmController?.alarmTableView.reloadData()
        default:
            modifyExistTime = false
            alarmController?.alarmTableView.allowsSelection = false
            self.tabBarController?.tabBar.isHidden = false
            break
        }
    }
}

extension AddAlarmController: PassTextFieldDelegate{
    func passText(alarmName: String) {
           alarmLabel = alarmName
       }
}

// MARK: -時間轉換 && DatePicker && NavigationBackItem
extension AddAlarmController {
    @IBAction func myTimePicker(_ sender: UIDatePicker){
        let dateValue = timeFormatter()
        temporaryTimeSaver = dateValue.string(from: alarmTimePicker.date)
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
