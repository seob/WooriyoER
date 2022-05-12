//
//  CustomActionPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/21.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class CustomActionPopUp: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    var contents = ""
    var focusTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textLabel.text = contents
        
    }
    
    @IBAction func cancelClick(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func okClick(_ sender: UIButton) {
        self.dismiss(animated: false) {
            print("-----------[CustomActionPopUp]---------------")
            UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/apple-store/id1493505553")!, options: [:], completionHandler: nil)
            
        }
    }
}
