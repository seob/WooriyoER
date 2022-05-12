//
//  TTeamCell.swift
//  PinPle
//
//  Created by WRY_010 on 27/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class MTTeamCell: UITableViewCell{
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblManager: UILabel!
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnTemshow: UIButton!
    @IBOutlet weak var btnBG: UIButton!
    @IBOutlet weak var imgBG: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                
    }    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
