//
//  SE_ContractInfoView.swift
//  PinPle
//
//  Created by seob on 2020/07/05.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class SE_ContractInfoView: UIView {
    
    @IBOutlet var ContrentView: UIView!
    @IBOutlet weak var uiPopUpView: UIView!
    @IBOutlet weak var saveBtnView: UIView!
    @IBOutlet weak var endBtnView: UIView!
    
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
    
    @IBOutlet weak var profimageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSpot: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    var selInfo : LcEmpInfo = LcEmpInfo()
    var standInfo : LcEmpInfo = LcEmpInfo()
    var viewpage = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func commonInit(){
        guard let xibName = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last else { return }
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    
    func setDateToString(_ dateStr: Date) -> String {
        let date:Date = dateStr
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        let dateString:String =  dateFormatter.string(from: date)
        
        return dateString
    }
    
    private func setupView(){
        commonInit()
        
        let nowsave = Date()
        
        
        ContrentView.layer.cornerRadius = 50;
        ContrentView.layer.masksToBounds = true
        ContrentView.clipsToBounds = true
        ContrentView.layer.maskedCorners = [.layerMinXMinYCorner]
        
        lblTime.text = "\(setDateToString(nowsave)) 임시저장"
        
        //팝업 버튼 보더 스타일
        let test1 = UIColor.init(hexString: "#707070")
        endBtnView.layer.borderWidth = 1;
        endBtnView.layer.borderColor = test1.cgColor
        endBtnView.layer.cornerRadius = 6;
        
        let test2 = UIColor.init(hexString: "#707070")
        saveBtnView.layer.borderWidth = 1;
        saveBtnView.layer.borderColor = test2.cgColor
        saveBtnView.layer.cornerRadius = 6;
        
        profimageView.makeRounded()
        let defaultProfimg = UIImage(named: "no_picture")
        if ContractEmpinfo.profimg == "" {
            profimageView.image = defaultProfimg
        }else{
            if ContractEmpinfo.profimg.urlTrim() != "img_photo_default.png" {
                profimageView.setImage(with: ContractEmpinfo.profimg)
            }else{
                profimageView.image = defaultProfimg
            }
        }
        print("\n---------- [ ContractEmpinfo : \(ContractEmpinfo.toJSON()) ] ----------\n")
        var infoText = ""
        if ContractEmpinfo.empsid > 0 {
            // 핀플 직원
            if ContractEmpinfo.phonenum != "" {
                infoText += "\(ContractEmpinfo.phonenum)"
            }
            
            if ContractEmpinfo.spot != "" {
                infoText += "\(ContractEmpinfo.spot)"
            }
        }else{
            //미합류 직원
            if ContractEmpinfo.phonenum != "" {
                infoText += "\(ContractEmpinfo.phonenum)"
            }
        }
        
        lblName.text = "\(ContractEmpinfo.name)님의 근로계약서"
        lblSpot.text = infoText
    }
    
    
    
    func configure(with presentable: LcEmpInfo , _ viewflag : String) {
        self.selInfo = presentable
        self.viewpage = viewflag
    }
    
    
}
