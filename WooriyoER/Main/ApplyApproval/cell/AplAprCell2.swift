//
//  AplAprCell2.swift
//  PinPle
//
//  Created by seob on 2020/07/23.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class AplAprCell2: UITableViewCell { 
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTemName: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var btnApr: UIButton!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblBtnType: UILabel!
    @IBOutlet weak var imgBtn: UIImageView!
    @IBOutlet weak var imgType: UIImageView!
    
        
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
        let refflag         =   data.refflag
        let enname          =   data.enname
        let aprstatus       =   data.aprstatus
        
        //신청종류 코드(0.출장 1.야간근로 2.휴일근로)
        var typeImg = UIImage()
        switch type {
            case 0:
                typeImg = UIImage.init(named: "r_229d93")!;
                lblType.text = "출장";
                lblType.textColor = .init(hexString: "#229D93");
            case 1:
                typeImg = UIImage.init(named: "r_ea6f45")!;
                lblType.text = "연장";
                lblType.textColor = .init(hexString: "#EA6F45");
            case 2:
                typeImg = UIImage.init(named: "r_ea6f45")!;
                lblType.text = "특근";
                lblType.textColor = .init(hexString: "#EA6F45");
            default:
                break;
        }
        
        let hour = (diffmin%(8*60))/60
        let min = (diffmin%(8*60))%60
        
        var timeStr = ""
        
        if diffmin >= 480 {
            timeStr = "1d "
        }else {
            if hour > 0 {
                timeStr = String(hour) + "h "
            }
            if min > 0 {
                timeStr = timeStr + String(min) + "m"
            }
        }
        
        var refflagStr = ""
        if refflag == 0 { // 결재자
            switch aprstatus {
                case 1:
                    refflagStr = "보류"
                    imgBtn.image = UIImage.init(named: "line_btn_50")!;
                default:
                    refflagStr = "결재"
                    imgBtn.image = UIImage.init(named: "line_btn_50")!;
            }
        }else{ //참조자
            refflagStr = "참조"
            imgBtn.image = UIImage.init(named: "gray_btn_50")!;
        }
        
        imgProfile.sd_setImage(with: URL(string: profimg), placeholderImage: UIImage(named: "no_picture"))
        imgType.image = typeImg
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
        
        
        lblContent.text = " / " + timeStr + " / " + aprdtStr + setWeek(aprdt)
        lblBtnType.text = refflagStr
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
