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
    
    var mockData:[String] = ["10", "15", "20", "25"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        leftBarItem()
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
    
    func leftBarItem() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.orange
    }
    
}

extension AlarmController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.mockData.remove(at: indexPath.row)
            self.alarmTableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        cell.timeLabel.text = self.mockData[indexPath.row]
        
        return cell
    }
    
    
}
