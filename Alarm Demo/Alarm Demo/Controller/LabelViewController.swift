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
    //承接static cell內部label值的方法
    var tempLabel: String?
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            self.textField.clearButtonMode = .always
            self.textField.textColor = .white
            textField.tintColor = .orange
            textField.becomeFirstResponder()
            guard let tempLabel = tempLabel else { return }
            textField.text = tempLabel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let text = textField.text, !text.isEmpty else {
            textField.text = "Alarm"
            delegate?.passText(alarmName: "Alarm")
            return
        }
        delegate?.passText(alarmName: text)
    }
}
