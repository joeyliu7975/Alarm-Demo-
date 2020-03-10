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
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue){
    }
    
    var onEditingMode: Bool = false
    var mockDataLists:[String] = ["10:00AM", "3:00PM", "5:00PM", "9:00PM"]
    
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
        alarmTableView.isEditing.toggle()
        onEditingMode = alarmTableView.isEditing
        sender.title = (alarmTableView.isEditing == true ? "Done" : "Edit")
        alarmTableView.reloadData()
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
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockDataLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        cell.timeLabel.text = self.mockDataLists[indexPath.row]
        
        switch onEditingMode {
        case true:
            cell.switchLabel.isHidden = true
        case false:
            cell.switchLabel.isHidden = false
        }
        return cell
    }
}
