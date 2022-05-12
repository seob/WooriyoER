//
//  NewTeamListCell.swift
//  PinPle
//
//  Created by seob on 2020/03/18.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class NewTeamListCell: UITableViewCell {
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var checkedBtn: UIButton!
    
    var subscribeButtonAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if (selected == true)
        {
            checkedBtn.setBackgroundImage(UIImage(named: "er_checkbox"), for: .normal)
            checkedBtn.isSelected = false
        }
        else
        {
            checkedBtn.setBackgroundImage(UIImage(named: "icon_nonecheck"), for: .normal)
            checkedBtn.isSelected = true
        }
    }
    
    @IBAction func subscribeButtonTapped(_ sender: UIButton){
      // if the closure is defined (not nil)
      // then execute the code inside the subscribeButtonAction closure
      subscribeButtonAction?()
    }
}
