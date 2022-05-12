//
//  InappTableViewCell.swift
//  PinPle
//
//  Created by seob on 2020/06/19.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class InappTableViewCell: UITableViewCell {
    @IBOutlet weak var checkedBtn: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    var subscribeButtonAction : (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if (selected == true)
        {
            checkedBtn.setBackgroundImage(UIImage(named: "er_checkbox"), for: .normal)
            checkedBtn.isSelected = true
        }
        else
        {
            checkedBtn.setBackgroundImage(UIImage(named: "icon_nonecheck"), for: .normal)
            checkedBtn.isSelected = false
        }
    }
    
    @IBAction func subscribeButtonTapped(_ sender: UIButton){
        // if the closure is defined (not nil)
        // then execute the code inside the subscribeButtonAction closure
        subscribeButtonAction?()
    }
    
}

