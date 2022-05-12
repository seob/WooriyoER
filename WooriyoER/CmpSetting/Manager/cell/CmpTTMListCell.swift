//
//  JoinManagerCell.swift
//  PinPle
//
//  Created by WRY_010 on 05/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmpTTMListCell: UITableViewCell{
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var btnCell: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.makeRounded()
        btnCell.setImage(checkImg, for: .selected)
        btnCell.setImage(uncheckImg, for: .normal)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
