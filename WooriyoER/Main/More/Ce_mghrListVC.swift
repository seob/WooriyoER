//
//  Ce_mghrListVC.swift
//  PinPle
//
//  Created by seob on 2020/08/12.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Ce_mghrListVC: UIViewController , NVActivityIndicatorViewable{
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var empList: [CeMgrList] = []
    var fillterData: [CeMgrList] = []
    var isEditSearch: Bool = false
    var searchText : String = ""
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        setUi()
        
        print("\n---------- [ SelCeEmpInfo : \(SelCeEmpInfo.toJSON()) ] ----------\n")
    }
    
    // MARK: - 검색
    @objc func searchTextChanged(_ sender: UITextField){
        if sender.text == nil || sender.text == "" {
            isEditSearch = false
            self.fillterData = self.empList
            return
        }
        
        isEditSearch = true
        
        self.searchText = sender.text ?? ""
        print("\n---------- [ searchText : \(searchText) ] ----------\n")
        
        self.fillterData = searchText.isEmpty ? empList : empList.filter({ (res) -> Bool in
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
            self.fillterData = self.empList
        }else{
            self.fillterData = searchText.isEmpty ? empList : empList.filter({ (res) -> Bool in
                return res.name.range(of: searchText, options: .caseInsensitive) != nil
            })
        }
        
        
        DispatchQueue.main.async {
            print("DispatchQueue = Start")
            self.tblList.reloadData()
        }
    }
    
    func setUi(){
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.separatorStyle = .none
        tblList.allowsSelection = true
        tblList.allowsSelectionDuringEditing = true
        tblList.rowHeight = UITableView.automaticDimension
        
        tblList.register(UINib.init(nibName: "CmpAprMgrListNewCell", bundle: nil), forCellReuseIdentifier: "CmpAprMgrListNewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IndicatorSetting()
        valueSetting()
        searchTextField.delegate = self
        searchTextField.returnKeyType = .done
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.cornerRadius = 0
        searchTextField.layer.borderWidth = 0.0
        searchTextField.setLeftPaddingPoints(30)
        searchTextField.placeholder = "검색"
        searchTextField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        
    }
    
    func valueSetting(){
        NetworkManager.shared().getCmp_mghrList(cmpsid: CompanyInfo.sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else {  return }
                self.empList = serverData
                self.fillterData = serverData
                self.tblList.reloadData()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }
        }
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_SettingVC") as! Ce_SettingVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    
}

// MARK: - UITableViewDelegate , UITableViewDataSource
extension Ce_mghrListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fillterData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CmpAprMgrListNewCell", for: indexPath) as! CmpAprMgrListNewCell
        cell.selectionStyle = .none
        let EmpIndexPath = fillterData[indexPath.row]
        let author = EmpIndexPath.author
        let enname = EmpIndexPath.enname
        let name = EmpIndexPath.name
        let profimg = EmpIndexPath.profimg
        let sid = EmpIndexPath.sid
        let spot = EmpIndexPath.spot
        
        
        if spot == "" {
            cell.leadingConstraints.constant = -5
        }
        
        if sid == SelCeEmpInfo.sid {
            cell.checkedBtn.setBackgroundImage(UIImage(named: "er_checkbox"), for: .normal)
            cell.checkedBtn.isSelected = true
        }else{
            cell.checkedBtn.setBackgroundImage(UIImage(named: "icon_nonecheck"), for: .normal)
            cell.checkedBtn.isSelected = false
        }
        
        cell.imgProfile.sd_setImage(with: URL(string: profimg), placeholderImage: UIImage(named: "logo_pre"))
        
        var authorImg = UIImage()
        switch author {
        case  0 :
            authorImg = UIImage.init(named: "master_puple")!
        case 1:
            authorImg = UIImage.init(named: "master_red")!
        case 2:
            authorImg = UIImage.init(named: "master_blue")!
        case 3, 4:
            authorImg = UIImage.init(named: "master_green")!
        default:
            break
        }
        
        cell.imgMgr.image = authorImg
        
        if enname == "" {
            cell.lblName.text = name
        }else {
            cell.lblName.text = name + "(" + enname + ") "
        }
        cell.lblSpot.text = spot
        cell.selBtn.tag = indexPath.row
        cell.selBtn.addTarget(self, action: #selector(selBtnDidTap(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func selBtnDidTap(_ sender: UIButton){
        SelCeEmpInfo = fillterData[sender.tag]
        let vc = CertifiSB.instantiateViewController(withIdentifier: "AddmghrPopup") as! AddmghrPopup
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    //
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        var selIndexPath = -1
    //        if prefs.value(forKey: "indexPath") != nil {
    //            selIndexPath = prefs.value(forKey: "indexPath") as! Int
    //        }
    //
    //        if selIndexPath == indexPath.row {
    //            tableView.deselectRow(at: indexPath, animated: false)
    //            prefs.removeObject(forKey: "indexPath")
    //        }else {
    //            prefs.setValue(indexPath.row, forKey: "indexPath")
    //        }
    //
    //        SelCeEmpInfo = fillterData[indexPath.row]
    //
    //    }
    
    
}

// MARK: - UITextFieldDelegate
extension Ce_mghrListVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        searchAction()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == searchTextField {
            let moddedLength = (textField.text?.count ?? 0) - (range.length - string.count)
            if moddedLength == 0 {
                isEditSearch = false
                self.fillterData = self.empList
                self.tblList.reloadData()
            }
        }
        return true
    }
}
