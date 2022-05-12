//
//  SignTableViewCell.swift
//  PinPle
//
//  Created by seob on 2020/06/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class SignTableViewCell: UITableViewCell {

    @IBOutlet weak var signImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSel: UIButton!
    @IBOutlet weak var checkedBtn: UIButton!
    @IBOutlet weak var selBtn: UIButton!
    var subscribeButtonAction : (() -> ())?
    
    var onClick : (_ indexPathRow : Int) -> Void = {
        vod in
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        if (selected == true)
//        {
//            checkedBtn.setBackgroundImage(UIImage(named: "er_checkbox"), for: .normal)
//            checkedBtn.isSelected = true
//        }
//        else
//        {
//            checkedBtn.setBackgroundImage(UIImage(named: "icon_nonecheck"), for: .normal)
//            checkedBtn.isSelected = false
//        }
    }
 
}
