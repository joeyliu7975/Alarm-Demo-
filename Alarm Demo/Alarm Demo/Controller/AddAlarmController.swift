//
//  AddAlarmController.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/10/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

enum ManageExistTime {
    case existAlarm
    case newAlarm
}

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
    var selectedRepeatDays = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        //判斷是否有存取現有Alarm
        switch manageTime(time: temporaryTimeSaver) {
        case .newAlarm:
            alarmTimePicker.setDate(currentDateTime, animated: false)
        case .existAlarm:
            let string = temporaryTimeSaver
            let df = DateFormatter()
            df.dateFormat = "hh:mm a"
            let result = df.date(from: string)
            alarmTimePicker.setDate(result!, animated: false)
        }
    }
    
    //一開始的程式SetUp
    func setup(){
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
        self.navigationItem.title = modifyExistTime ? "Edit Alarm" : "Add Alarm"
        
        let formatter = TimeFormatterManager.timeFormatter()
        
        //如果是修改現有鬧鐘： TimePickerc變成原有鬧鐘時間，反之則採用當下時間
        temporaryTimeSaver = modifyExistTime ? temporaryTimeSaver : formatter.string(from: currentDateTime)
    }
    
    // enum判斷式，把現在時間導入
    func manageTime(time: String) -> ManageExistTime {
        if temporaryTimeSaver.isEmpty {
            return .newAlarm
        }
        return .existAlarm
    }
}

// MARK: -Pass Data to AlarmVC and StaticViewCell
extension AddAlarmController{
    // UnwindSegue && Cancel barbuttonItem tag = 1, Save barbuttonItem tag = 2
    override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
        if let alarmController = segue.destination as? AlarmController {
            alarmController.alarmTableView.isEditing = false
            alarmController.leftBarbuttonItem.title = "Edit"
            //            alarmController.isEditMode  = false
            // MARK: -畫面切回 Alarm Controller的狀況
            guard let button = sender as? UIBarButtonItem else { return }
            
            
            // Alarm CV properties回到default:
            func alarmVCsetUp(){
                modifyExistTime = false
                self.tabBarController?.tabBar.isHidden = false
                alarmController.bubbleSorted()
                alarmController.alarmTableView.reloadData()
            }
            
            switch (button.tag, modifyExistTime) {
            case (2, false):
                if selectedRepeatDays.count != 0{
                    alarmController.mockDataLists.append(TimePickerManager(time: temporaryTimeSaver, label: alarmLabel, repeatDay: selectedRepeatDays))
                } else {
                    alarmController.mockDataLists.append(TimePickerManager(time: temporaryTimeSaver, label: alarmLabel))
                }
                
                alarmVCsetUp()
            case (2, true):
                alarmController.mockDataLists[modifyExistRow].time = temporaryTimeSaver
                alarmController.mockDataLists[modifyExistRow].switchButtonIsOn = true
                alarmController.mockDataLists[modifyExistRow].label = alarmLabel
                if selectedRepeatDays.count != 0 {
                    alarmController.mockDataLists[modifyExistRow].repeatDay = selectedRepeatDays
                }
                
                alarmVCsetUp()
            default:
                alarmController.alarmTableView.allowsSelection = false
                
                alarmVCsetUp()
            }
        }
        // MARK:-畫面轉向Static TableView的狀況
        if let staticTableView = segue.destination as? StaticTableViewCell {
            
            //Label名稱和Repeat dayd的delegate
            staticTableView.delegate = self
            staticTableView.delegateDay = self
            
            //把值從Add Alarm傳給Container view中的staticViewCell
            staticTableView.alarmString = alarmLabel
            staticTableView.repeatDayStatus = selectedRepeatDays
            staticTableView.deleteRow = modifyExistRow
            staticTableView.editMode = modifyExistTime
        }
        
        navigationBackItem()
    }
}

// MARK: -時間轉換 && DatePicker && NavigationBackItem
extension AddAlarmController {
    @IBAction func myTimePicker(_ sender: UIDatePicker){
        let dateValue = TimeFormatterManager.timeFormatter()
        temporaryTimeSaver = dateValue.string(from: alarmTimePicker.date)
    }
    
    func navigationBackItem() {
        let backItem = UIBarButtonItem()
        backItem.title = "back"
        backItem.tintColor = UIColor.orange
        navigationItem.backBarButtonItem = backItem
    }
}
