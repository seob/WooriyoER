//
//  TeamCell.swift
//  PinPle
//
//  Created by WRY_010 on 18/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell{

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblManager: UILabel!
    @IBOutlet weak var lblMember: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
