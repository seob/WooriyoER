//
//  NoticeListTableViewCell.swift
//  PinPle
//
//  Created by seob on 2022/01/27.
//  Copyright © 2022 WRY_010. All rights reserved.
//

import UIKit

class NoticeListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRegdt: UILabel!
    @IBOutlet weak var newImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
