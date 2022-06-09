//
//  CustomPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/21.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class CustomPopUp: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    
    var contents = ""
    var focusTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textLabel.text = contents
        btnOk.backgroundColor = EnterpriseColor.btnColor
        btnOk.setTitleColor(EnterpriseColor.lblColor, for: .normal)
        
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if self.focusTextField != nil {
                self.focusTextField!.becomeFirstResponder()
            }
        }
    }
}
