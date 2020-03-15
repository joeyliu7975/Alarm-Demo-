//
//  RepeatViewController.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/15/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

enum everyday {
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
}

class RepeatViewController: UIViewController {
    
    @IBOutlet weak var repeatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "RepeatTableViewCell", bundle: nil)
        repeatTableView.register(nib, forCellReuseIdentifier: "RepeatTableViewCell")
    }
}

extension RepeatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        repeatTableView.deselectRow(at: indexPath, animated: true)
        
        repeatTableView.cellForRow(at: indexPath)?.accessoryType = repeatTableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = repeatTableView.dequeueReusableCell(withIdentifier: "RepeatTableViewCell", for: indexPath) as! RepeatTableViewCell
        cell.repeatDaysLabel.text = "Hello worldr"
        
        return cell
    }
}
