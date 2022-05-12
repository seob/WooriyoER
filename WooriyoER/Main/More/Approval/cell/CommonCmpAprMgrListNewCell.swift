//
//  CommonCmpAprMgrListNewCell.swift
//  PinPle
//
//  Created by seob on 2020/08/18.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class CommonCmpAprMgrListNewCell: UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var imgMgr: UIImageView!
    @IBOutlet weak var checkedBtn: UIButton!
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    var subscribeButtonAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.makeRounded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
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
