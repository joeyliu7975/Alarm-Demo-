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
        
        self.alarmTableView.allowsSelectionDuringEditing = true
        
        cell.timeLabel.text = self.mockDataLists[indexPath.row].time
        
        cell.editingAccessoryType = .disclosureIndicator
        
        return cell
    }
}
