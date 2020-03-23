//
//  TableViewInsideContainerViewTableViewController.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/11/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

protocol SnoozeDelegate{
    func snoozeIndexOn(index: Int)
}

class StaticTableViewCell: UITableViewController {
    
    @IBOutlet weak var repeatDayLabel: UILabel! {
        didSet {
            repeatDayLabel.text = StaticTableViewCell.repeatDayBoolToString(input: repeatDayStatus)
        }
    }
    @IBOutlet weak var alarmNameLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var snoozeLabel: UILabel!
    @IBOutlet weak var alarmName: UILabel!
    @IBOutlet weak var snoozeSwitch: UISwitch! {
        didSet {
            snoozeSwitch.isOn = true
        }
    }
    @IBOutlet weak var addAlarmSettingTableView: UITableView! {
        didSet {
            addAlarmSettingTableView.tableFooterView = UIView()
        }
    }
    
    var delegate: PassTextFieldDelegate?
    var delegateDay: PassDayCheckmarks?
    var delegateSnooz: SnoozeDelegate?
    var repeatDayStatus = [Bool](repeating: false, count: 7)
    var repeatDayString: String = ""
    var alarmString: String = "Alarm"
    var deleteRow: Int = -1
    var editMode: Bool = false
    
    @IBOutlet weak var deleteAlarm: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmName.text = alarmString
        deleteAlarm.isHidden = !editMode
    }
    
    @IBAction func ActivateSnoozSwich(_ sender: UISwitch) {
        switch sender.isOn {
        case true:
            snoozeLabel.textColor = UIColor.white
            delegateSnooz?.snoozeIndexOn(index: sender.tag)
        default:
            snoozeLabel.textColor = UIColor.gray
            delegateSnooz?.snoozeIndexOn(index: sender.tag)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        let section:Int = editMode ? 2 : 1
        return section
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.black
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            addAlarmSettingTableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "goToRepeat", sender: nil)
        case (0 ,1):
            addAlarmSettingTableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "goToLabel", sender: nil)
        default:
            addAlarmSettingTableView.deselectRow(at: indexPath, animated: true)
            break
        }
    }
    // MARK: - Navigation
}

extension StaticTableViewCell: PassDayCheckmarks{
    func passDayCheckMarks(array: [Bool]) {
        (repeatDayStatus, repeatDayLabel.text) = (array, StaticTableViewCell.repeatDayBoolToString(input: array))
        delegateDay?.passDayCheckMarks(array: repeatDayStatus)
    }
}

extension StaticTableViewCell: PassTextFieldDelegate{
    func passText(alarmName: String) {
        (self.alarmName.text, alarmString) = (alarmName, alarmName)
        //Pass Data back to AddAlarmVC
        delegate?.passText(alarmName: alarmString)
    }
}

// MARK: -Prepare的步驟
extension StaticTableViewCell {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // To Select Repeat Days
        if let repeatDayDestination = segue.destination as? RepeatViewController {
            repeatDayDestination.delegate = self
            if repeatDayStatus.count != 0{
                repeatDayDestination.dayCheckmarks = repeatDayStatus
            }
        }
        // To Modify Label
        if let labelDestination = segue.destination as? LabelViewController {
            labelDestination.delegate = self
            labelDestination.tempLabel = alarmString
        }
        
        if let alarmDestination = segue.destination as? AlarmController {
            alarmDestination.mockDataLists.remove(at: deleteRow)
            //            deleteRow = -1
            alarmDestination.editButton(alarmDestination.leftBarbuttonItem);     self.tabBarController?.tabBar.isHidden = false
            alarmDestination.alarmTableView.allowsSelection = false
            alarmDestination.alarmTableView.reloadData()
        }
    }
}

enum repeatDays {
    case never
    case weekdays
    case weekends
    case everydays
    case other
}
// MARK: -重複日期判斷

extension StaticTableViewCell {

    static func repeatDayBoolToString(input: [Bool]) -> String{
        var labels = [String]()
        var showLabel: String = ""
        for (index, value) in input.enumerated() {
            if value {
                switch index {
                case 0:
                    labels.append("Sun")
                case 1:
                    labels.append("Mon")
                case 2:
                    labels.append("Tue")
                case 3:
                    labels.append("Wed")
                case 4:
                    labels.append("Thu")
                case 5:
                    labels.append("Fri")
                case 6:
                    labels.append("Sat")
                default:
                    continue
                }
            }
        }
        
        switch labels {
        case ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]:
            showLabel = "Everyday"
        case ["Sun", "Sat"]:
            showLabel = "Weekends"
        case ["Mon", "Tue", "Wed", "Thu", "Fri"]:
            showLabel = "Weekdays"
        case []:
            showLabel = "Never"
        case ["Sun"]:
            showLabel = "Every Sunday"
        case ["Mon"]:
            showLabel = "Every Monday"
        case ["Tue"]:
            showLabel = "Every Tuesday"
        case ["Wed"]:
            showLabel = "Every Wednesay"
        case ["Thu"]:
            showLabel = "Every Thursday"
        case ["Fri"]:
            showLabel = "Every Friday"
        case ["Sat"]:
            showLabel = "Every Satday"
        default:
            for i in 0...labels.count - 1 {
                if i != 0 {
                    showLabel += " \(labels[i])"
                } else {
                    showLabel += "\(labels[i])"
                }
            }
        }
        return showLabel
    }
}

/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
 
 // Configure the cell...
 
 return cell
 }
 */

/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */
