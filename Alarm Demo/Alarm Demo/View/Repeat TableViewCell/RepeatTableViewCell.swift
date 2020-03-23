//
//  RepeatTableViewCell.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/15/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

class RepeatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repeatDaysLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
