//
//  SecurtFooterView.swift
//  PinPle
//
//  Created by seob on 2021/11/16.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class SecurtFooterView: UIView, UITextFieldDelegate {
    @IBOutlet weak var RegdtImageView: UIImageView!
    @IBOutlet weak var RegdtView: UIView!
    @IBOutlet weak var lblRegdt: UILabel!
    @IBOutlet weak var addContentBtn: UIButton!
 
    @IBOutlet weak var nameTextField: HoshiTextField!
    var regdt = ""
    var cmpname = ""
    var dateFormatter = DateFormatter()
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit() 
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    //방법 1. loadNibNamed
    func customInit() {
        if let view = Bundle.main.loadNibNamed("SecurtFooterView", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            addSubview(view)
        }
        
        let startyGestuure = UITapGestureRecognizer(target: self, action: #selector(startdatePicker))
        self.RegdtView.isUserInteractionEnabled = true
        self.RegdtView.addGestureRecognizer(startyGestuure)
        nameTextField.delegate = self
        addToolBar(textFields: [nameTextField])
    }
    
    func addToolBar(textFields: [UITextField]) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            
            let previousButton = UIBarButtonItem(image: UIImage(named: "toolbar_icon_previous"), style: .plain, target: nil, action: nil)
            previousButton.width = 50
            
            if textField == textFields.first {
                previousButton.isEnabled = false
            } else {
                previousButton.target = textFields[index - 1]
                previousButton.action = #selector(UITextField.becomeFirstResponder)
            }
            
            let nextButton = UIBarButtonItem(image: UIImage(named: "toolbar_icon_next"), style: .plain, target: nil, action: nil)
            nextButton.width = 50
            if textField == textFields.last {
                nextButton.isEnabled = false
            } else {
                nextButton.target = textFields[index + 1]
                nextButton.action = #selector(UITextField.becomeFirstResponder)
            }
            items.append(contentsOf: [previousButton, nextButton])
            
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
        
    }
    
    func dataBind(_ data: ScEmpInfo){
        
        regdt = data.lcdt
        cmpname = (data.cmpname != ""  ? data.cmpname : CompanyInfo.name)
        
        nameTextField.text = "\(cmpname)"
        
        if regdt == "1900-01-01" || regdt == "" {
            self.lblRegdt.text =  todayDateKo().replacingOccurrences(of: "-", with: ".")
        }else {
            self.lblRegdt.text = regdt.replacingOccurrences(of: "-", with: ".")
        }
        
        if self.lblRegdt.text != "" {
            self.RegdtImageView.image = chkstatusAlertpass
        }
    }
    
    @objc func startdatePicker(_ sender: UIGestureRecognizer){
        regdt = lblRegdt.text ?? ""
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let inputData = dateFormatter.date(from: regdt) ?? Date()
        DatePickerDialog(locale: Locale(identifier: "ko_KR")).show("날짜 선택", doneButtonTitle: "확인", cancelButtonTitle: "취소", defaultDate: inputData, minimumDate: nil, maximumDate: Date(), datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy.MM.dd"
                
                self.lblRegdt.text = formatter.string(from: dt)
                
            }
        }
    }
    
    
    func todayDateKo() -> String {
        let date = Date() // 현재 시간 가져오기
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko") // 로케일 변경
        formatter.timeZone = NSTimeZone(name: "KST") as TimeZone?
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        return dateString
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let str = textField.text ?? ""
        
        nameTextField.text = "\(str)"
    }
    
}
