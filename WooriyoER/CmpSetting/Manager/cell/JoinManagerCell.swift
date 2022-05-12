//
//  JoinManagerCell.swift
//  PinPle
//
//  Created by WRY_010 on 05/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import Foundation

class JoinManagerCell: UITableViewCell{
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
