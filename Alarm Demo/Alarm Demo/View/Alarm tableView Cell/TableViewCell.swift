//
//  TableViewCell.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/9/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

protocol SwitchIsOnDelegate{
    func switchIndexOn(index: Int)
}

class TableViewCell: UITableViewCell{
    
    var delegate: SwitchIsOnDelegate?
    var indexPath: IndexPath?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var activateSwitch: UISwitch!
    
    var alarmController: AlarmController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func switchAction(_ sender: UISwitch){
        guard let row = indexPath?.row else { return }
        switch sender.isOn {
        case true:
            (timeLabel.textColor, alarmLabel.textColor) = (UIColor.white, UIColor.white)
            delegate?.switchIndexOn(index: row)
        default:
            (timeLabel.textColor, alarmLabel.textColor) = (UIColor.gray, UIColor.gray)
            delegate?.switchIndexOn(index: row)
        }
    }
}
