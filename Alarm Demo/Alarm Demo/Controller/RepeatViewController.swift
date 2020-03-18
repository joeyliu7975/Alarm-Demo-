//
//  RepeatViewController.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/15/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

enum SevenDay: CaseIterable{
    case Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
}

protocol PassDayCheckmarks{
    func passDayCheckMarks(array: [Bool])
}

class RepeatViewController: UIViewController {
    
    var delegate: PassDayCheckmarks?
    
    @IBOutlet weak var repeatTableView: UITableView!
    var days = [String]()
    var dayCheckmarks = [Bool](repeating: false, count: 7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "RepeatTableViewCell", bundle: nil)
        repeatTableView.register(nib, forCellReuseIdentifier: "RepeatTableViewCell")
        makeSevenDays()
    }
    
    //viewWillDisappear 此層頁面從最上層被拉開時(未完全消失)，上一層畫面會收到viewWillDisappear裡面的訊息
    //viewDidDisappear 此層頁面完全消失時，上一層畫面會收到viewDidDisappear裡面的訊息
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.passDayCheckMarks(array: dayCheckmarks)
    }
   
    func makeSevenDays(){
        for day in SevenDay.allCases{
            days.append("Every \(day)")
        }
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
        //紀錄所勾選的日子
        dayCheckmarks[indexPath.row].toggle()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = repeatTableView.dequeueReusableCell(withIdentifier: "RepeatTableViewCell", for: indexPath) as! RepeatTableViewCell
        cell.repeatDaysLabel.text = days[indexPath.row]
        //判斷剛進來時Checkmark狀態是否被勾選
        cell.accessoryType = dayCheckmarks[indexPath.row] ? .checkmark : .none
        cell.tintColor = .orange
        
        return cell
    }
}
