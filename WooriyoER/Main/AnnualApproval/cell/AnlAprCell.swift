//
//  AnlAprCell.swift
//  PinPle
//
//  Created by WRY_010 on 14/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class AnlAprCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblSpot: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTemName: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var btnApr: UIButton!
    @IBOutlet weak var lblBtnType: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var imgBtn: UIImageView!
    
    var aprflag = 0
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
    
    func bindData(data: AnualListArr) {
        let type    =   data.type
        let aprdt    =   data.aprdt
        let diffmin =   data.diffmin
        let spot    =   data.spot
        let ddctn   =   data.ddctn
        let name    =   data.name
        let tname   =   data.tname
        let profimg =   data.profimg
        let refflag =   data.refflag
        let enname  =   data.enname
        let aprstatus = data.aprstatus
        let complateType = data.complete // 2021.01.25 추가 0 : 미결재 , 1: 완료
        
        //연차종류코드(0.연차 1.오전반차 2.오후반차 3.조퇴 4.외출 5.병가 6.공가 7.경조 8.교육훈련 9.포상 10.공민권 11.생리)
        var typeImg = UIImage()
        if data.anualaprsub.count > 0 {
            typeImg = UIImage.init(named: "r_45a7cb")!;
            lblType.text = "일괄연차";
            lblType.textColor = .init(hexString: "#45A7CD");
        }else{
            switch type {
                case 0:
                    typeImg = UIImage.init(named: "r_45a7cb")!;
                    lblType.text = "연차";
                    lblType.textColor = .init(hexString: "#45A7CD");
                case 1:
                    typeImg = UIImage.init(named: "r_am_45a7cb")!;
                    lblType.text = "오전반차";
                    lblType.textColor = .init(hexString: "#45A7CD");
                case 2:
                    typeImg = UIImage.init(named: "r_pm_45a7cb")!;
                    lblType.text = "오후반차";
                    lblType.textColor = .init(hexString: "#45A7CD");
                case 3:
                    typeImg = UIImage.init(named: "r_6849af")!;
                    lblType.text = "조퇴";
                    lblType.textColor = .init(hexString: "#6849AF");
                case 4:
                    typeImg = UIImage.init(named: "r_6849af")!;
                    lblType.text = "외출";
                    lblType.textColor = .init(hexString: "#6849AF");
                case 5:
                    typeImg = UIImage.init(named: "r_grey")!;
                    lblType.text = "병가";
                    lblType.textColor = .gray;
                case 6:
                    typeImg = UIImage.init(named: "r_384dad")!;
                    lblType.text = "공가";
                    lblType.textColor = .init(hexString: "#384DAD");
                case 7:
                    typeImg = UIImage.init(named: "r_384dad")!;
                    lblType.text = "경조사";
                    lblType.textColor = .init(hexString: "#384DAD");
                case 8:
                    typeImg = UIImage.init(named: "r_384dad")!;
                    lblType.text = "교육/훈련";
                    lblType.textColor = .init(hexString: "#384DAD");
                case 9:
                    typeImg = UIImage.init(named: "r_45a7cb")!;
                    lblType.text = "포상휴가";
                    lblType.textColor = .init(hexString: "#45A7CD");
                case 10:
                    typeImg = UIImage.init(named: "r_384dad")!;
                    lblType.text = "공민권";
                    lblType.textColor = .init(hexString: "#384DAD");
                case 11:
                    typeImg = UIImage.init(named: "r_eb5e89")!;
                    lblType.text = "생리휴가";
                    lblType.textColor = .init(hexString: "#EB5E89");
                default:
                    break;
            }
        }
        
        
        let hour = (diffmin%(8*60))/60
        let min = (diffmin%(8*60))%60
        
        var timeStr = ""
        
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
        }
        
        var ddctnStr = ""
        if ddctn == 0 {
            ddctnStr = "미차감"
        }else {
            ddctnStr = "차감"
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
        // 멀티 신청 시 2020.04.02 seob
        if data.anualaprsub.count > 0 {
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
            lblContent.text = " / " + multiStr
        }else{
            lblContent.text = " / " + timeStr + " / " + ddctnStr
        }
        
        lblBtnType.text = refflagStr
    }
    
}
