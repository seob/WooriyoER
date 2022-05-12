//
//  HolidayListCell.swift
//  PinPle
//
//  Created by WRY_010 on 02/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class HolidayListCell: UITableViewCell{
  
 
    @IBOutlet weak var lblHoliName: UILabel!
    @IBOutlet weak var lblHoliDay: UILabel!
    @IBOutlet weak var lblType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
}
