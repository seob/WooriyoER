//
//  AplAprCell_comfrim.swift
//  PinPle
//
//  Created by seob on 2021/01/25.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit 

class AplAprCell_comfrim : UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTemName: UILabel!
    @IBOutlet weak var lblContent: MarqueeLabel!
    @IBOutlet weak var btnApr: UIButton!
    @IBOutlet weak var lblaprname: UILabel!
    @IBOutlet weak var lblaprStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.borderColor = UIColor.clear.cgColor
        imgProfile.clipsToBounds = true
        btnApr.isEnabled = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bindData(data: ApplyListArr) {
        let aprdt           =   data.aprdt
        let type            =   data.type
        let diffmin         =   data.diffmin
        let spot            =   data.spot
        let name            =   data.name
        let tname           =   data.tname
        let profimg         =   data.profimg
        let enname          =   data.enname
        let aprstatus       =   data.aprstatus
        let aprname         =   data.aprname  // 2021.01.25 추가 결재중 결재자 이름
        let aprspot         =   data.aprspot // 2021.01.25 추가 결재중 결재자 이름
        let starttm         =   data.starttm
        let endtm           =   data.endtm
        
        //신청종류 코드(0.출장 1.야간근로 2.휴일근로)
        
        var typeStr = ""
        switch type {
            case 0:
                typeStr = "출장"
            case 1:
                typeStr = "연장"
            case 2:
                typeStr = "특근"
            default:
                break;
        }
        
        let hour = (diffmin%(8*60))/60
        let min = (diffmin%(8*60))%60
        
        var timeStr = ""
        var tmStr = ""
        if diffmin >= 480 {
            timeStr = "1d "
        }else {
            if hour > 0 {
                timeStr = String(hour) + "h "
            }
            if min > 0 {
                timeStr = timeStr + String(min) + "m"
            }
            tmStr = starttm + " ~ " + endtm
        }
        
    
        
        imgProfile.sd_setImage(with: URL(string: profimg), placeholderImage: UIImage(named: "no_picture"))
        lblSpot.text = spot
        
        var nameStr = name
        if enname != "" {
            nameStr += "(" + enname + ")"
        }
        lblName.text = nameStr
        lblTemName.text = tname
        
        let str = aprdt.replacingOccurrences(of: "-", with: ".")
        let start = str.index(str.startIndex, offsetBy: 2)
        let end = str.index(before: str.endIndex)
        let aprdtStr = str[start...end]
        
        lblTemName.textColor = .init(hexString: "#808080")
        lblSpot.textColor = .init(hexString: "#808080")
        lblName.textColor = .init(hexString: "#808080")
        lblContent.textColor = .init(hexString: "#808080") // 2021.01.25 완료된 Text color 808080
        lblContent.text = typeStr + " / " + timeStr + " / " + aprdtStr + setWeek(aprdt) + " " + tmStr
        var aplStr = ""
        if aprspot != "" {
            aplStr = "\(aprname) \(aprspot)"
        }else{
            aplStr = "\(aprname)"
        }
        lblaprname.text = "\(aplStr)"
        
        var aprstatusStr = ""
        switch aprstatus {
            case 0:
                aprstatusStr = "결재중"
            case 1:
                aprstatusStr = "보류"
            case 2:
                aprstatusStr = ""
            case 3:
                aprstatusStr = "반려"
            default:
                aprstatusStr = "결재중"
        }
        lblaprStatus.text = "\(aprstatusStr)"
    }
    
    func setWeek(_ str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: str)
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday], from: date!)
        var week = ""
        
        switch comps.weekday {
            case 1:
                week = "일";
            case 2:
                week = "월";
            case 3:
                week = "화";
            case 4:
                week = "수";
            case 5:
                week = "목";
            case 6:
                week = "금";
            case 7:
                week = "토";
            default:
                break;
        }
        
        return "(" + week + ")"
    }
}
