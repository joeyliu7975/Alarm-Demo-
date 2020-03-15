//
//  ViewController.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/9/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

class AlarmController: UIViewController{
    
    @IBOutlet weak var alarmTableView: UITableView!
    @IBOutlet weak var leftBarbuttonItem: UIBarButtonItem!
    
    var isEditMode: Bool = false
    var modifyExistAlarm: Bool = false
    var mockDataLists = [TimePickerManager]()
    var modifyExistRow: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        nibRegister()
        tableViewSeparator()
        alarmTableView.allowsSelection = false
    }
    
    func nibRegister() {
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        alarmTableView.register(nib, forCellReuseIdentifier: "TableViewCell")
    }
    
    func tableViewSeparator() {
        alarmTableView.separatorColor = UIColor.gray
        alarmTableView.tableFooterView = UIView()
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem){
        UIView.animate(withDuration: 0.5) {
            self.alarmTableView.isEditing.toggle()
            self.alarmTableView.allowsSelection.toggle()
            self.isEditMode = self.alarmTableView.isEditing
            sender.title = (self.alarmTableView.isEditing == true ? "Done" : "Edit")
        }
    }
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue){
    }
    
    @IBAction func save(_ unwindSegue: UIStoryboardSegue){
    }
    
    func bubbleSorted(){
        for i in 0 ... mockDataLists.count - 1{
//            guard mockDataLists.count >= 1 else { return }
            let currentOne = timeFormatter(time: mockDataLists[i].time)
            for a in 0 ... mockDataLists.count - 1{
                let replaceOne = timeFormatter(time: mockDataLists[a].time)
                if currentOne < replaceOne {
                    let tempData:TimePickerManager = mockDataLists[i]
                    mockDataLists[i] = mockDataLists[a]
                    mockDataLists[a] = tempData
                }
            }
        }
    }
    
    func timeFormatter(time: String) -> Date{
        let string = time
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        let result = df.date(from: string)
        return result!
    }
}

extension AlarmController: UITableViewDataSource, UITableViewDelegate
{
    
    // Trailing Swipe to Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.mockDataLists.remove(at: indexPath.row)
            self.alarmTableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // Editing Mode trailing EditingStyle
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditMode {
            modifyExistAlarm = true
            modifyExistRow = indexPath.row
//            alarmTableView.cellForRow(at: indexPath)?.selectionStyle = .gray
            performSegue(withIdentifier: "goToAddAlarm", sender: nil)
        }
//        else {
//            alarmTableView.cellForRow(at: indexPath)?.selectionStyle = .none
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addController = segue.destination as? AddAlarmController
        if modifyExistAlarm == true {
            //81行決定現在時間，82行決定是否進入isEditing，
            addController?.temporaryTimeSaver = mockDataLists[modifyExistRow].time
            addController?.modifyExistTime = true
            addController?.modifyExistRow = modifyExistRow
        }
        modifyExistAlarm = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockDataLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let arrowImage = UIImage(named: "arrow")
        //生成時設定好 selectionStyle
//        alarmTableView.cellForRow(at: indexPath)?.selectionStyle = isEditMode ? .gray : .none
        
        //應該改動 mockDataLists[indexPath.row[的switchButtonIsOn]的Boolean值
        self.mockDataLists[indexPath.row].switchButtonIsOn = cell.switchSendBackValue
        
        self.alarmTableView.allowsSelectionDuringEditing = true
        
        cell.timeLabel.text = self.mockDataLists[indexPath.row].time
        
        // 當開關被關掉時，把開關打開
        if cell.activateSwitch.isOn == false && self.mockDataLists[indexPath.row].switchButtonIsOn == false && indexPath.row == modifyExistRow{
            self.mockDataLists[indexPath.row].switchButtonIsOn = true
            cell.activateSwitch.isOn = self.mockDataLists[indexPath.row].switchButtonIsOn
            cell.switchAction(cell.activateSwitch)
        }
        
        self.mockDataLists[indexPath.row].switchButtonIsOn = cell.activateSwitch.isOn
        
        cell.editingAccessoryView = UIImageView(image: arrowImage)
        
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
