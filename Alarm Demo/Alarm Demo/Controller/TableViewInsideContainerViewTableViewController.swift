//
//  TableViewInsideContainerViewTableViewController.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/11/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

class TableViewInsideContainerViewTableViewController: UITableViewController {
    
    @IBOutlet weak var repeatDayLabel: UILabel!
    @IBOutlet weak var alarmNameLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var alarmName: UILabel!
    @IBOutlet weak var addAlarmSettingTableView: UITableView! {
        didSet {
            addAlarmSettingTableView.tableFooterView = UIView()
        }
    }
    
    var delegate: PassTextFieldDelegate?
    var statusTitles = [Bool]()
    var statusString: String = ""
    var alarmString: String = "Alarm"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmName.text = alarmString
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
        }
        
        if let labelDestination = segue.destination as? LabelViewController {
            labelDestination.delegate = self
            labelDestination.tempLabel = alarmString
        }
    }
}
//    func passDayCheckMarks(array: [Bool]) {
//        statusTitles = array
//        let allDay = [
//            true,
//            true,
//            true,
//            true,
//            true,
//            true,
//            true,
//        ]
//        let weekDay = [
//            true,
//            true,
//            true,
//            true,
//            true,
//            false,
//            false,
//        ]
//
//        let weekend = [
//            false,
//            false,
//            false,
//            false,
//            false,
//            true,
//            true,
//        ]
//        let never = [
//            false,
//            false,
//            false,
//            false,
//            false,
//            false,
//            false,
//        ]
//        switch statusTitles {
//        case allDay:
//            print(1)
//        case weekDay:
//            print(2)
//        case weekend:
//            print(3)
//        case never:
//            print(4)
//        default:
//            print(0)
//        }
//    }



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
