//
//  TableViewCell.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/9/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell{
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var activateSwitch: UISwitch!
    var switchSendBackValue: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func switchAction(_ sender: UISwitch){
        switchWillReturnValue(isOn: sender.isOn)
        switch sender.isOn {
        case true:
            timeLabel.textColor = UIColor.white
            alarmLabel.textColor = UIColor.white
            switchSendBackValue = true
        default:
            timeLabel.textColor = UIColor.gray
            alarmLabel.textColor = UIColor.gray
            switchSendBackValue = false
        }
    }
    
    func switchWillReturnValue(isOn: Bool){
    }

    
}
