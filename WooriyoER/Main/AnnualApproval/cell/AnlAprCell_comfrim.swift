//
//  AnlAprCell_comfrim.swift
//  PinPle
//
//  Created by seob on 2021/01/25.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class AnlAprCell_comfrim : UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTemName: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblaprname: UILabel!
    @IBOutlet weak var lblaprStatus: UILabel!
    @IBOutlet weak var btnApr: UIButton!
    
    var aprflag = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.borderColor = UIColor.clear.cgColor
        imgProfile.clipsToBounds = true
        lblaprStatus.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bindData(data: AnualListArr) {
        let type    =   data.type
        let aprdt    =   data.aprdt
        let diffmin =   data.diffmin
        let spot    =   data.spot
        let name    =   data.name
        let tname   =   data.tname
        let profimg =   data.profimg
        let enname  =   data.enname
        let aprstatus = data.aprstatus 
        let aprname     =   data.aprname  // 2021.01.25 추가 결재중 결재자 이름
        let aprspot     =   data.aprspot // 2021.01.25 추가 결재중 결재자 이름
        let starttm         =   data.starttm
        let endtm           =   data.endtm
        let strReason    = data.reason // 2022.04.04 연차사유 추가
        
        var typeStr = "" 
        if data.batch == 1 {
            typeStr = "일괄연차";
        }else{
            switch type {
                case 0:
                    typeStr = "연차"
                case 1:
                    typeStr = "오전반차"
                case 2:
                    typeStr = "오후반차"
                case 3:
                    typeStr = "조퇴"
                case 4:
                    typeStr = "외출"
                case 5:
                    typeStr = "병가"
                case 6:
                    typeStr = "공가"
                case 7:
                    typeStr = "경조사"
                case 8:
                    typeStr = "교육/훈련"
                case 9:
                    typeStr = "포상휴가"
                case 10:
                    typeStr = "공민권"
                case 11:
                    typeStr = "생리휴가"
                default:
                    break;
            }
        }
        
        
        let hour = (diffmin%(8*60))/60
        let min = (diffmin%(8*60))%60
        
        var timeStr = ""
        var tmStr = ""
        // schdl 여부에 따른 오전반차 오후반차 인경우 고정 4h - 2020.03.24 osan
        if diffmin >= 480 {
            timeStr = "1d "
        }else {
            switch (type, moreCmpInfo.schdl) {
                case (0, 0), (0, 1): // 연차
                    timeStr = "1d"
                case (1, 1) , (2, 1) : //오전 오후 반차
                    timeStr =  "4h"
                default:
                    if hour > 0 {
                        timeStr = String(hour) + "h "
                    }
                    if min > 0 {
                        timeStr = timeStr + String(min) + "m"
                    }
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
        
        lblTemName.textColor = .init(hexString: "#808080")
        lblSpot.textColor = .init(hexString: "#808080")
        lblName.textColor = .init(hexString: "#808080")
        lblContent.textColor = .init(hexString: "#808080") // 2021.01.25 완료된 Text color 808080
        let str = aprdt.replacingOccurrences(of: "-", with: ".")
        let start = str.index(str.startIndex, offsetBy: 2)
        let end = str.index(before: str.endIndex)
        let aprdtStr = str[start...end]
        // 멀티 신청 시 2020.04.02 seob
        if data.batch > 0 {
            var batchdiff = 0 // h
            var remainder = 0 // m
            var multiStr = ""
            if data.batchdiff > 0 {
                batchdiff = (data.batchdiff / 8)
                remainder = (data.batchdiff % 8)
            }
            
            if batchdiff > 0 && remainder > 0 {
                multiStr = "\(batchdiff)d \(remainder)h"
            }else if batchdiff > 0 && remainder == 0 {
                multiStr = "\(batchdiff)d"
            }else if batchdiff == 0 && remainder > 0 {
                multiStr = "\(remainder)h"
            }
            lblContent.text =  typeStr + " / " + multiStr + " / " + aprdtStr + setWeek(aprdt) + " " + strReason
        }else{
            lblContent.text =  typeStr + " / " + timeStr + " / " + aprdtStr + setWeek(aprdt) + " " + tmStr + " " + strReason
        }
        
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

