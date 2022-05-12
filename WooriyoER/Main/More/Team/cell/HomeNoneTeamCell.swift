//
//  HomeNoneTeamCell.swift
//  PinPle
//
//  Created by seob on 2021/03/02.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class HomeNoneTeamCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnTemshow: UIButton! 
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
