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
            alarmTableView.reloadData()
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
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue){
    }
    
    @IBAction func save(_ unwindSegue: UIStoryboardSegue){
    }
    
    func bubbleSorted(){
        for external in 0 ... mockDataLists.count - 1{
            let currentOne = TimeFormatterManager.timeFormatter(time: mockDataLists[external].time)
            for inner in 0 ... mockDataLists.count - 1{
                let replaceOne = TimeFormatterManager.timeFormatter(time: mockDataLists[inner].time)
                if currentOne < replaceOne {
                    let tempData:TimePickerManager = mockDataLists[external]
                    mockDataLists[external] = mockDataLists[inner]
                    mockDataLists[inner] = tempData
                }
            }
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
        cell.activateSwitch.tag = indexPath.row
        
        cell.editingAccessoryView = UIImageView(image: arrowImage)
        
        cell.timeLabel.text = self.mockDataLists[indexPath.row].time
        cell.alarmLabel.text = self.mockDataLists[indexPath.row].label
        
        cell.activateSwitch.isOn = self.mockDataLists[indexPath.row].switchButtonIsOn
        
        switch cell.activateSwitch.isOn {
        case true:
            cell.timeLabel.textColor = UIColor.white
            cell.alarmLabel.textColor = UIColor.white
        default:
            cell.timeLabel.textColor = UIColor.gray
            cell.alarmLabel.textColor = UIColor.gray
        }
        return cell
    }
}

// MARK: - TableView Delegate
extension AlarmController: UITableViewDelegate{
    // Editing Mode trailing EditingStyle
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.mockDataLists.remove(at: indexPath.row)
            self.alarmTableView.deleteRows(at: [indexPath], with: .automatic)
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

//MARK: -UISnoozeSwitch Delegate
extension AlarmController: SnoozeDelegate{
    func snoozeIndexOn(index: Int) {
    }
}

// MARK: - Prepare for Segue
extension AlarmController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addController = segue.destination as? AddAlarmController
        if modifyExistAlarm == true {
            //107行決定現在時間，109行決定是否進入isEditing，
            addController?.temporaryTimeSaver = mockDataLists[modifyExistRow].time
            addController?.alarmLabel = mockDataLists[modifyExistRow].label
            addController?.modifyExistTime = true
            addController?.modifyExistRow = modifyExistRow
            addController?.selectedRepeatDays = mockDataLists[modifyExistRow].repeatDay
        }
        modifyExistAlarm = false
    }
}

extension AlarmController{
    func saveUserDefault(){
        switch mockDataLists.count {
        case 0:
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
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
}
