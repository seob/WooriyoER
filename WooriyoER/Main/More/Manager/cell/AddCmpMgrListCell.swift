//
//  AddCmpMgrListCell.swift
//  PinPle
//
//  Created by WRY_010 on 2019/11/11.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AddCmpMgrListCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpot: UILabel!    
    @IBOutlet weak var btnCell: UIButton!
    @IBOutlet weak var imgMgr: UIImageView! 
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgProfile.makeRounded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
