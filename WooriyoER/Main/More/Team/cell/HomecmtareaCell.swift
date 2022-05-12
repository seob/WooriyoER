//
//  HomecmtareaCell.swift
//  PinPle
//
//  Created by seob on 2021/02/18.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class HomecmtareaCell: UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTemName: UILabel!
    @IBOutlet weak var btnDel: UIButton!
    @IBOutlet weak var cmtareaImageView: UIImageView!
    
    let onWifiImg = UIImage.init(named: "icon_wifi_on")
    let offWifiImg = UIImage.init(named: "icon_wifi_off")
    let noneWifiImg = UIImage.init(named: "icon_wifi_none")
    
    let onGPSImg = UIImage.init(named: "icon_gps_on")
    let offGPSImg = UIImage.init(named: "icon_gps_off")
    let noneGPSImg = UIImage.init(named: "icon_gps_none")
    
    let onBconImg = UIImage.init(named: "icon_beacon_on")
    let offBconImg = UIImage.init(named: "icon_beacon_off")
    let noneBconImg = UIImage.init(named: "icon_beacon_none")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.borderColor = UIColor.clear.cgColor
        imgProfile.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func bindData(data: HomeCmtAreaInfo) {
        let name       =   data.name
        let profimg    =   data.profimg
        let spot       =   data.spot
        let cmtarea    =   data.cmtarea
        let wifinm     =   data.wifinm
        let locaddr    =   data.locaddr
        let beacon     = data.beacon
 
        self.lblName.text = name
        let defaultProfimg = UIImage(named: "logo_pre")
        if profimg.urlTrim() != "img_photo_default.png" {
            self.imgProfile.setImage(with: profimg)
        }else{
            self.imgProfile.image = defaultProfimg
        }
        self.lblSpot.text = spot

        switch cmtarea {
            case 1:
                self.cmtareaImageView.image = onWifiImg
                self.lblTemName.text = "\(wifinm)"
            case 2:
                self.cmtareaImageView.image = onGPSImg
                self.lblTemName.text = "\(locaddr)"
            case 3:
                self.cmtareaImageView.image = onBconImg
                self.lblTemName.text = "\(beacon)"
            default:
                self.lblTemName.text = ""
        }
    }
}
