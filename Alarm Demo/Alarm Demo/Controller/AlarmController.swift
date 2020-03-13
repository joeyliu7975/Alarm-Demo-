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
    // VC2
    var modifyExistRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        nibRegister()
        tableViewSeparator()
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
            self.isEditMode = self.alarmTableView.isEditing
            sender.title = (self.alarmTableView.isEditing == true ? "Done" : "Edit")
        }
    }
    
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue){
    }
    
    @IBAction func save(_ unwindSegue: UIStoryboardSegue){
    }
}

extension AlarmController: UITableViewDataSource, UITableViewDelegate {
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
            
            //  self.present(T##viewControllerToPresent: UIViewController##UIViewController, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
            
            performSegue(withIdentifier: "goToAddAlarm", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addController = segue.destination as? AddAlarmController
            if modifyExistAlarm == true {
                addController?.temporaryTimeSaver = mockDataLists[modifyExistRow].time
                print("\(mockDataLists[modifyExistRow].time)")
                addController?.modifyExistTime = modifyExistAlarm
            }
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    //        if (segue.identifier == "goToAddAlarm"){
    //            let addAlarmController = segue.destination as! AddAlarmController
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockDataLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let arrowImage = UIImage(named: "arrow")
        
        self.alarmTableView.allowsSelectionDuringEditing = true
        
        cell.timeLabel.text = self.mockDataLists[indexPath.row].time
        
        cell.editingAccessoryView = UIImageView(image: arrowImage)
        
        return cell
    }
    
}
