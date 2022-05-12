//
//  PersonMgrListCell.swift
//  PinPle
//
//  Created by seob on 2020/06/02.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class PersonMgrListCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpot: UILabel! 
    @IBOutlet weak var vwNoMgr: UIView!
    @IBOutlet weak var btnCell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.makeRounded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}
