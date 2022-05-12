//
//  Sc_empListVC.swift
//  PinPle
//
//  Created by seob on 2021/11/10.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class Sc_empListVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwNoApr: UIView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var btnWork: UIButton!
    @IBOutlet weak var lblWork: UILabel!
    @IBOutlet weak var btnNotWork: UIButton!
    @IBOutlet weak var lblNotWork: UILabel!
    @IBOutlet weak var offShow: UIView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblName: TextFieldEffects!
    @IBOutlet weak var lblPhone: TextFieldEffects!
    @IBOutlet weak var lblEmail: TextFieldEffects!
    
    @IBOutlet weak var chkimgName: UIImageView!
    @IBOutlet weak var chkimgphone: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    var empTuple : [ScEmpList] = []
    var fillterData : [ScEmpList] = []
    var searchText : String = ""
    var clickFlag = true
    var cmpsid = 0
    var selInfo : ScEmpInfo = ScEmpInfo()
    var standInfo : ScEmpInfo = ScEmpInfo()
    var format = 0
    var textFields : [UITextField] = []
    var isEditSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.delegate = self
        tblList.dataSource = self
      
        textFields = [lblName , lblPhone , lblEmail]
        for textfield in textFields {
            textfield.delegate = self
        }
        addToolBar(textFields: textFields)
        
        
        tblList.rowHeight = UITableView.automaticDimension
        tblList.separatorStyle = .none
        tblList.backgroundColor = .clear
        tabbarheight(tblList)
        tblList.register(UINib.init(nibName: "ScEmpListCell", bundle: nil), forCellReuseIdentifier: "ScEmpListCell")
        
        
        
        offShow.isHidden = true
//
//        btnWork.setImage(UIImage(named: "er_btn_square"), for: .selected)
//        btnWork.setImage(UIImage(named: "btn_tab_normal"), for: .normal)
//        btnNotWork.setImage(UIImage(named: "er_btn_square"), for: .selected)
//        btnNotWork.setImage(UIImage(named: "btn_tab_normal"), for: .normal)
        
        btnWork.isSelected = true
        btnNotWork.isSelected = false
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        lblEmail.delegate = self
        lblPhone.delegate = self
        lblName.delegate = self
        
        lblPhone.keyboardType = .phonePad
        lblEmail.keyboardType = .emailAddress
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cmpsid = CompanyInfo.sid
        getTotalList()
        searchTextField.delegate = self
        searchTextField.returnKeyType = .done
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.cornerRadius = 0
        searchTextField.layer.borderWidth = 0.0
        searchTextField.setLeftPaddingPoints(30)
        searchTextField.placeholder = "직원이름을 검색 하세요"
        searchTextField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
    }
    
    // MARK: - 검색
    @objc func searchTextChanged(_ sender: UITextField){
        if sender.text == nil || sender.text == "" {
            isEditSearch = false
            self.fillterData = self.empTuple
            return
        }
        
        isEditSearch = true
        
        self.searchText = sender.text ?? ""
        print("\n---------- [ searchText : \(searchText) ] ----------\n")
        
        self.fillterData = searchText.isEmpty ? empTuple : empTuple.filter({ (res) -> Bool in
            return res.name.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        
        DispatchQueue.main.async {
            print("DispatchQueue = Start")
            self.tblList.reloadData()
        }
    }
    
    @IBAction func SearchDidTap(_ sender: UIButton) {
        searchAction()
    }
    
    fileprivate func searchAction(){
        isEditSearch = true
        
        self.searchText = searchTextField.text ?? ""
        
        if searchText == "" {
            self.fillterData = self.empTuple
        }else{
            self.fillterData = searchText.isEmpty ? empTuple : empTuple.filter({ (res) -> Bool in
                return res.name.range(of: searchText, options: .caseInsensitive) != nil
            })
        }
        
        
        DispatchQueue.main.async {
            print("DispatchQueue = Start")
            self.tblList.reloadData()
        }
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
        if SE_flag {
            vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    //핀플 직원중 선택 시
    @IBAction func PinpleSelButton(_ sender: UIButton) {
        clickFlag = true
        btnWork.isSelected = true
        btnNotWork.isSelected = false
        
        offShow.isHidden = true
        
        tblList.isHidden = false
        lblWork.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
        lblNotWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        btnWork.backgroundColor = UIColor.rgb(r: 252, g: 202, b: 0)
        btnNotWork.backgroundColor = UIColor.rgb(r: 247, g: 247, b: 250)
    }
    
    //핀플 미합류 직원
    @IBAction func PinpleNoneButton(_ sender: UIButton) {
        clickFlag = false
        btnWork.isSelected = false
        btnNotWork.isSelected = true
        
        //        vwNoApr.isHidden = true
        tblList.isHidden = true
        
        offShow.isHidden = false
        lblWork.textColor = UIColor.rgb(r: 203, g: 203, b: 211)
        lblNotWork.textColor = UIColor.rgb(r: 0, g: 0, b: 0)
        btnNotWork.backgroundColor = UIColor.rgb(r: 252, g: 202, b: 0)
        btnWork.backgroundColor = UIColor.rgb(r: 247, g: 247, b: 250)
    }
    
    
    //다음버튼 클릭시
    @IBAction func NextDidTap(_ sender: UIButton) {
        if let name = lblName.text , name == "" {
            toast("이름을 입력하세요.")
            lblName.becomeFirstResponder()
            return
        }else if let phone = lblPhone.text , phone == "" {
            toast("핸드폰번호를 입력하세요.")
            lblPhone.becomeFirstResponder()
        }else{
            
            let nm = lblName.text ?? ""
            let pn = lblPhone.text ?? ""
            let email = lblEmail.text ?? ""
            
            updatePopup(nm, pn, email)
        }
    }
    
    fileprivate func updatePopup(_ nm: String , _ pn: String , _ email: String){
        let vc = SecurtSB.instantiateViewController(withIdentifier: "StartSecurtContractPopup") as! StartSecurtContractPopup
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.format = self.format
        vc.type = "nomember"
        vc.nm = nm
        vc.pn = pn
        vc.email = email
        ContractEmpinfo.name   = nm
        ContractEmpinfo.phonenum = pn
        ContractEmpinfo.email = email
        ContractEmpinfo.empsid = 0
        ContractEmpinfo.profimg = ""
        self.present(vc, animated: false, completion: nil)
    }
    
    
    func getTotalList() {
        NetworkManager.shared().getSc_empList(cmpsid: cmpsid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return self.tblList.reloadData() }
                if serverData.count > 0 {
                    for i in 0...serverData.count-1 {
                        self.empTuple.append(serverData[i])
                    }
                    
                    self.tblList.reloadData()
                }
                
            }else{
                self.customAlertView("다시 시도해 주세요.")
                
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension Sc_empListVC: UITableViewDelegate , UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchText != "" {
            return fillterData.count
        }else{
            return empTuple.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ScEmpListCell", for: indexPath) as? ScEmpListCell {
            var empListIndexPath: ScEmpList = ScEmpList()
            if self.searchText != "" {
                empListIndexPath = fillterData[indexPath.row]
            }else{
                empListIndexPath = empTuple[indexPath.row]
            }
            
            
            cell.imgProfile.sd_setImage(with: URL(string: empListIndexPath.profimg), placeholderImage: UIImage(named: "no_picture"))
            if empListIndexPath.enname != "" {
                cell.lblName.text = empListIndexPath.name + "(\(empListIndexPath.enname))"
            }else{
                cell.lblName.text = empListIndexPath.name
            }
            
            if empListIndexPath.spot != "" {
                cell.lblSpot.text = empListIndexPath.spot
            }else{
                cell.lblSpot.text = "직책없음"
            }
            
            if empListIndexPath.regdt == "1900-01-01 00:00:00.0" {
                cell.lblRegdt.text =  "없음"
            }else{
                cell.lblRegdt.text = setJoinDate2(timeStamp: empListIndexPath.regdt)
            }
            
            if (empListIndexPath.temname != "" || empListIndexPath.ttmname != "" ){
                cell.lblTemName.text = "\(empListIndexPath.ttmname) \(empListIndexPath.temname)"
            }else{
                cell.lblTemName.text = "무소속"
            }
            
            
            cell.btnApr.tag = indexPath.row
            cell.btnApr.addTarget(self, action: #selector(selectCell(_:)), for: .touchUpInside)
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func selectCell(_ sender: UIButton){
        var empListIndexPath: ScEmpList = ScEmpList()
        if self.searchText != "" {
            empListIndexPath = fillterData[sender.tag]
        }else{
            empListIndexPath = empTuple[sender.tag]
        }
        
        
        print("\n---------- [ form : \(format) ] ----------\n")
        let vc = SecurtSB.instantiateViewController(withIdentifier: "StartSecurtContractPopup") as! StartSecurtContractPopup
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo.empsid = empListIndexPath.sid
        vc.standInfo.empsid = empListIndexPath.sid
        vc.status = empListIndexPath.status
        vc.format = self.format
        ContractEmpinfo.empsid = empListIndexPath.sid
        ContractEmpinfo.name   = empListIndexPath.name
        ContractEmpinfo.spot = empListIndexPath.spot
        ContractEmpinfo.profimg = empListIndexPath.profimg
        self.present(vc, animated: false, completion: nil)
    }
    
}

// MARK: - UITextFieldDelegate
extension Sc_empListVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        searchAction()
        if textField == lblName {
            lblPhone.becomeFirstResponder()
        }else if textField == lblPhone {
            lblPhone.becomeFirstResponder()
        }else if textField == lblEmail {
            lblEmail.becomeFirstResponder()
        }
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let str = textField.text ?? ""
        print("\n---------- [ str : \(str) ] ----------\n")
        if textField == lblEmail {
            if str != "" {
                if !str.validate("email") {
                    self.customAlertView("이메일 형식에 맞게 입력하세요.", lblEmail)
                }
            }
        }else if textField == lblName {
            if str != "" {
                chkimgName.image = chkstatusAlertpass
            }else{
                chkimgName.image = chkstatusAlert
            }
        }else  if textField == lblPhone {
            if str != "" {
                chkimgphone.image = chkstatusAlertpass
            }else{
                chkimgphone.image = chkstatusAlert
            }
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let str = textField.text ?? ""
        if textField == lblName {
            if str != "" {
                chkimgName.image = chkstatusAlertpass
            }else{
                chkimgName.image = chkstatusAlert
            }
        }
        
        if textField == lblPhone {
            if str != "" {
                chkimgphone.image = chkstatusAlertpass
            }else{
                chkimgphone.image = chkstatusAlert
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == searchTextField {
            let moddedLength = (textField.text?.count ?? 0) - (range.length - string.count)
            if moddedLength == 0 {
                isEditSearch = false
                self.fillterData = self.empTuple
                self.tblList.reloadData()
            }
        }
        return true
    }
    
}


