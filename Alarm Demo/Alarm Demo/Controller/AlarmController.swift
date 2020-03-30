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
    
    @IBAction func addNewAlarm(_ sender: UIBarButtonItem){
        if let addAlarmVC = self.storyboard?.instantiateViewController(identifier: "addAlarmVC", creator: { coder in
            AddAlarmController(coder: coder)
        }) {
            let navController = UINavigationController(rootViewController: addAlarmVC)
            
            navigationBarSetup(navController)
            modifyExistAlarm = false
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem){
        UIView.animate(withDuration: 0.5) {
            self.alarmTableView.isEditing.toggle()
            self.isEditMode = self.alarmTableView.isEditing
            sender.title = (self.alarmTableView.isEditing == true ? "Done" : "Edit")
        }
    }
    
    private func navigationBarSetup(_ navController: UINavigationController){
        navController.navigationBar.barTintColor = .black
        navController.navigationBar.tintColor = .white
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
}

// MARK: - TableView DataSource
extension AlarmController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data: TimePickerManager = mockDataLists[indexPath.row]
        if isEditMode {
            if let addAlarmVC = self.storyboard?.instantiateViewController(identifier: "addAlarmVC", creator: { coder in
                AddAlarmController(coder: coder, data: data)
            }) {
                let navController = UINavigationController(rootViewController: addAlarmVC)
                modifyExistAlarm = true
                addAlarmVC.modifyExistRow = indexPath.row
                addAlarmVC.temporaryTimeSaver = data.time
                addAlarmVC.alarmLabel = data.label
                addAlarmVC.modifyExistTime = true
                addAlarmVC.modifyExistRow = modifyExistRow
                addAlarmVC.selectedRepeatDays = data.repeatDay
                
                navigationBarSetup(navController)
                modifyExistAlarm = false
                self.present(navController, animated: true, completion: nil)
            }
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
