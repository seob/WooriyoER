//
//  MgrCmtCell.swift
//  PinPle
//
//  Created by WRY_010 on 2020/02/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//


import UIKit

class MgrCmtCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var imgMgr: UIImageView!
    @IBOutlet weak var btnInclude: UIButton!
    @IBOutlet weak var btnException: UIButton! 
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.makeRounded()
        btnInclude.setImage(UIImage.init(named: "er_checkbox"), for: .selected)
        btnInclude.setImage(UIImage.init(named: "icon_nonecheck"), for: .normal)
        btnException.setImage(UIImage.init(named: "er_checkbox"), for: .selected)
        btnException.setImage(UIImage.init(named: "icon_nonecheck"), for: .normal)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
