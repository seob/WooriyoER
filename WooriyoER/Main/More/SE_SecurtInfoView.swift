//
//  SE_SecurtInfoView.swift
//  PinPle
//
//  Created by seob on 2021/11/15.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class SE_SecurtInfoView: UIView {
    
    @IBOutlet var ContrentView: UIView!
    @IBOutlet weak var saveBtnView: UIView!
    @IBOutlet weak var endBtnView: UIView!
    
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var endBtn: UIButton!
     
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    var selInfo : ScEmpInfo = ScEmpInfo()
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
        
        if selInfo.format == 0 {
            lblTime.text = "\(setDateToString(nowsave))"
            lblName.text = " 입사 보안서약서 임시저장"
        }else{
            lblTime.text = "\(setDateToString(nowsave))"
            lblName.text = " 퇴사 보안서약서 임시저장"
        }
        
        
        //팝업 버튼 보더 스타일
        let test1 = UIColor.init(hexString: "#707070")
        endBtnView.layer.borderWidth = 1;
        endBtnView.layer.borderColor = test1.cgColor
        endBtnView.layer.cornerRadius = 6;
        
        let test2 = UIColor.init(hexString: "#707070")
        saveBtnView.layer.borderWidth = 1;
        saveBtnView.layer.borderColor = test2.cgColor
        saveBtnView.layer.cornerRadius = 6;

    }
    
    
    
    func configure(with presentable: ScEmpInfo , _ viewflag : String) {
        self.selInfo = presentable
        self.viewpage = viewflag
    }
    
    
}
