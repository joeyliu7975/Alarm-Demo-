//
//  ViewController.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/9/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

class AlarmController: UIViewController{
    
    @IBOutlet weak var alarmTableView: UITableView! {
        didSet {
            alarmTableView.allowsSelection = false
            alarmTableView.allowsSelectionDuringEditing = true
            alarmTableView.separatorColor = UIColor.gray
            alarmTableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var leftBarbuttonItem: UIBarButtonItem!
    
    // Image for AccessoryView
    let arrowImage = UIImage(named: "arrow")
    
    //    let timeFormatterManager = TimeFormatterManager()
    var mockDataLists = [TimePickerManager](){
        didSet{
            saveUserDefault()
        }
    }
    var isEditMode: Bool = false
    var modifyExistAlarm: Bool = false
    var modifyExistRow: Int = -1
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadUserDefault()
        nibRegister()
    }
    
    func nibRegister() {
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        alarmTableView.register(nib, forCellReuseIdentifier: "TableViewCell")
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem){
        UIView.animate(withDuration: 0.5) {
            self.alarmTableView.isEditing.toggle()
            self.isEditMode = self.alarmTableView.isEditing
            sender.title = (self.alarmTableView.isEditing == true ? "Done" : "Edit")
        }
    }
}

// MARK: - TableView DataSource
extension AlarmController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditMode {
            modifyExistAlarm = true
            modifyExistRow = indexPath.row
            performSegue(withIdentifier: "goToAddAlarm", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockDataLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.delegate = self
        
        //開關起動時，找到這個index的位置
        cell.indexPath = indexPath
        
        cell.editingAccessoryView = UIImageView(image: arrowImage)
        
        let item = self.mockDataLists[indexPath.row]
        let repeatDayString = StaticTableViewCell.repeatDayBoolToString(input: item.repeatDay)
        
        // 1. Label with Repeat day, also if Repeat Day start with "E.." and it will be lowercased
        //2. only Label
        let labelWithRepeats = repeatDayString.prefix(1) == "E" ? "\(item.label), \(repeatDayString.lowercasedFirstLetter())" : "\(item.label), \(repeatDayString)"
        let label = item.label
        
        cell.alarmLabel.text = repeatDayString.isNever ? label : labelWithRepeats
        cell.activateSwitch.isOn = item.switchButtonIsOn
        cell.timeLabel.text = item.time
        
        // decreasing AM/PM size
        switch item.time.count{
        case 7:
            let amountText = NSMutableAttributedString.init(string: "\(item.time)")
            amountText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                      NSAttributedString.Key.foregroundColor: UIColor.white],
                                     range: NSMakeRange(5,2))
            cell.timeLabel.attributedText = amountText
        case 8:
            let amountText = NSMutableAttributedString.init(string: "\(item.time)")
            amountText.setAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                      NSAttributedString.Key.foregroundColor: UIColor.white],
                                     range: NSMakeRange(6,2))
            cell.timeLabel.attributedText = amountText
        default:
            break
        }
        
        // timeLabel and alarmLabel TextColor become white when switch is active, else become gray
        let color: UIColor = item.switchButtonIsOn ? .white : .gray
        cell.timeLabel.textColor = color
        cell.alarmLabel.textColor = color
        
        return cell
    }
}

// MARK: - TableView Delegate
extension AlarmController: UITableViewDelegate{
    // Editing Mode trailing EditingStyle
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.mockDataLists.remove(at: indexPath.row)
            self.alarmTableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//MARK: -UISwitch Delegate
extension AlarmController: SwitchIsOnDelegate{
    func switchIndexOn(index: Int) {  
        mockDataLists[index].switchButtonIsOn.toggle()
    }
}

// MARK: - Prepare for Segue
extension AlarmController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addController = segue.destination as? AddAlarmController{
        if modifyExistAlarm == true {
            //107行決定現在時間，109行決定是否進入isEditing，
            addController.temporaryTimeSaver = mockDataLists[modifyExistRow].time
            addController.alarmLabel = mockDataLists[modifyExistRow].label
            addController.modifyExistTime = true
            addController.modifyExistRow = modifyExistRow
            addController.selectedRepeatDays = mockDataLists[modifyExistRow].repeatDay
        }
        modifyExistAlarm = false
    }
    }
}
