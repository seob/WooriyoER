//
//  HomeMTTeamCell.swift
//  PinPle
//
//  Created by seob on 2021/02/18.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class HomeMTTeamCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblManager: UILabel!
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnTemshow: UIButton!
    @IBOutlet weak var btnBG: UIButton!
    @IBOutlet weak var imgBG: UIImageView!
    
    @IBOutlet weak var btnhomeSel: UIButton!
    @IBOutlet weak var nonVW: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
