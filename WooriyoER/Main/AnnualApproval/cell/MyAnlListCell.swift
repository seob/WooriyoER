//
//  MyAnlListCell.swift
//  PinPle
//
//  Created by seob on 2020/02/18.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class MyAnlListCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var btnCell: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
