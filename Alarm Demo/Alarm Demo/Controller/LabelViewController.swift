//
//  LabelViewController.swift
//  Alarm Demo
//
//  Created by Joey Liu on 3/16/20.
//  Copyright © 2020 Joey Liu. All rights reserved.
//

import UIKit

protocol PassTextFieldDelegate {
    func passText(alarmName: String)
}

class LabelViewController: UIViewController{
    
    var delegate: PassTextFieldDelegate?
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            self.textField.clearButtonMode = .always
            self.textField.textColor = .white
            textField.text = textField.text == "" ? "Alarm" : textField.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        textField.text = textField.text == "" ? "Alarm" : textField.text
        delegate?.passText(alarmName: (textField.text)!)
    }
}
