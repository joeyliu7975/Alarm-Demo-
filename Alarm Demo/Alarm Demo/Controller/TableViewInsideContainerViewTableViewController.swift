//
//  TableViewInsideContainerViewTableViewController.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/11/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

class TableViewInsideContainerViewTableViewController: UITableViewController {
    
    @IBOutlet weak var addAlarmSettingTableView: UITableView!
    @IBOutlet weak var repeatDayLabel: UILabel!
    @IBOutlet weak var alarmNameLabel: NSLayoutConstraint!
    @IBOutlet weak var alarmName: UILabel!
    
    var statusTitles = [Bool](repeating: false, count: 7)
    var statusLabel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAlarmSettingTableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            addAlarmSettingTableView.deselectRow(at: indexPath, animated: true)
            
            performSegue(withIdentifier: "goToRepeat", sender: nil)
            //                let storyBoard : UIStoryboard = UIStoryboard(name: "AddAlarm", bundle:nil)
            //                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "goToRepeat")
        //                self.present(nextViewController, animated:true, completion:nil)
        case 1:
            addAlarmSettingTableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "goToLabel", sender: nil)
            //               let storyBoard : UIStoryboard = UIStoryboard(name: "AddAlarm", bundle:nil)
            //                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "goToLabel")
        //                self.present(nextViewController, animated:true, completion:nil)
        default:
            addAlarmSettingTableView.deselectRow(at: indexPath, animated: true)
            break
        }
    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 4
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
    

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if let repeatDayDestination = segue.destination as? RepeatViewController {
            repeatDayDestination.delegate = self
        }
        
        if let labelDestination = segue.destination as? LabelViewController {
            labelDestination.delegate = self
        }
     }
}

extension TableViewInsideContainerViewTableViewController: PassDayCheckmarks, PassTextFieldDelegate {
    func passText(alarmName: String) {
        self.alarmName.text = alarmName
    }
    
    func passDayCheckMarks(array: [Bool]) {
        statusTitles = array
        }
    }

struct WeekDay {
    let rawValue: Int
    let name: String
    
    static let mon = WeekDay(rawValue: 1, name: "Monday")
    static let tue = WeekDay(rawValue: 1<<1, name: "Tuesday")
    static let wed = WeekDay(rawValue: 1<<2, name: "Wednesday")
    static let thu = WeekDay(rawValue: 1<<3, name: "Thursday")
    static let fri = WeekDay(rawValue: 1<<4, name: "Friday")
    static let sat = WeekDay(rawValue: 1<<5, name: "Saturday")
    static let sun = WeekDay(rawValue: 1<<6, name: "Sunday")
    
    static let all: [WeekDay] = [.mon, .tue, .wed, .thu, .fri, .sat, .sun]
    func isIncluded(in schedule: Int) -> Bool {
      return schedule & rawValue == rawValue
    }
}
