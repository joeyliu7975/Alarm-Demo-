//
//  TableViewInsideContainerViewTableViewController.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/11/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

class TableViewInsideContainerViewTableViewController: UITableViewController {
    
    @IBOutlet weak var repeatDayLabel: UILabel! {
        didSet {
            repeatDayLabel.text = repeatDayBoolToString(input: statusTitles)
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
    var statusTitles = [Bool](repeating: false, count: 7)
    var statusString: String = ""
    var alarmString: String = "Alarm"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmName.text = alarmString
    }
    
    @IBAction func ActivateSnoozSwich(_ sender: UISwitch) {
        switch sender.isOn {
        case true:
            snoozeLabel.textColor = UIColor.white
        default:
            snoozeLabel.textColor = UIColor.gray
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            addAlarmSettingTableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "goToRepeat", sender: nil)
        case 1:
            addAlarmSettingTableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "goToLabel", sender: nil)
        default:
            addAlarmSettingTableView.deselectRow(at: indexPath, animated: true)
            break
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
}

extension TableViewInsideContainerViewTableViewController: PassDayCheckmarks{
    func passDayCheckMarks(array: [Bool]) {
        statusTitles = array
        repeatDayLabel.text = repeatDayBoolToString(input: array)
    }
}

extension TableViewInsideContainerViewTableViewController: PassTextFieldDelegate{
    func passText(alarmName: String) {
        self.alarmName.text = alarmName
        alarmString = alarmName
        //Pass Data back to AddAlarmVC
        delegate?.passText(alarmName: alarmString)
    }
}


// MARK: -Prepare的步驟
extension TableViewInsideContainerViewTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let repeatDayDestination = segue.destination as? RepeatViewController {
            repeatDayDestination.delegate = self
            repeatDayDestination.dayCheckmarks = statusTitles
        }
        
        if let labelDestination = segue.destination as? LabelViewController {
            labelDestination.delegate = self
            labelDestination.tempLabel = alarmString
        }
    }
}
// MARK: -重複日期判斷
extension TableViewInsideContainerViewTableViewController {
    func repeatDayBoolToString(input: [Bool]) -> String{
        var labels = [String]()
        var showLabel: String = ""
        for (index, value) in input.enumerated() {
            if value == true {
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
        print (labels)
        switch labels {
        case ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]:
            showLabel = "Everyday"
        case ["Sun", "Sat"]:
            showLabel = "Weekends"
        case ["Mon", "Tue", "Wed", "Thu", "Fri"]:
            showLabel = "Weekdays"
        case []:
            showLabel = "Never"
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
