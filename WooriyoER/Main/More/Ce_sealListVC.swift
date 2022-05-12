//
//  Ce_sealListVC.swift
//  PinPle
//
//  Created by seob on 2020/08/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Ce_sealListVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    var cmpList : [cmpSignInfo] = []
    var fillterData : [cmpSignInfo] = []
    var type = 0
    
    var selectedRows = 0
    
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btn_plus"), for: .normal)
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let view = UIApplication.shared.keyWindow {
            view.addSubview(faButton)
            setupButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let view = UIApplication.shared.keyWindow, faButton.isDescendant(of: view) {
            faButton.removeFromSuperview()
        }
    }
    
    
    func setupButton() {
        NSLayoutConstraint.activate([
            faButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            faButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            faButton.heightAnchor.constraint(equalToConstant: 60),
            faButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        faButton.layer.cornerRadius = 30
        faButton.layer.masksToBounds = true
    }
    
    @objc func fabTapped(_ sender: UIButton){
        faButton.removeFromSuperview()
        var vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_AddCmpsealVC") as! Ce_AddCmpsealVC
        if SE_flag {
            vc = CertifiSB.instantiateViewController(withIdentifier: "SE_Ce_AddCmpsealVC") as! Ce_AddCmpsealVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.separatorStyle = .none
        tblList.allowsSelection = true
        tblList.allowsSelectionDuringEditing = true
        tblList.rowHeight = UITableView.automaticDimension
        tblList.register(UINib.init(nibName: "SignTableViewCell", bundle: nil), forCellReuseIdentifier: "SignTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cmpList.removeAll()
        valueSetting()
        tblList.reloadData()
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = CertifiSB.instantiateViewController(withIdentifier: "CertifiCateMainVC") as! CertifiCateMainVC
        if SE_flag {
            vc = CertifiSB.instantiateViewController(withIdentifier: "SE_CertifiCateMainVC") as! CertifiCateMainVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    func valueSetting(){
        NetworkManager.shared().getcmp_sealList(cmpsid: userInfo.cmpsid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                
                if serverData.count > 0 {
                    self.cmpList = serverData
                    self.fillterData = self.cmpList
                    for info in self.cmpList {
                        if info.certflag == 1 {
                            self.selectedRows = info.sid
                        }
                    }
                    self.tblList.reloadData()
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    @IBAction func addSign(_ sender: UIButton) {
        var vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_AddCmpsealVC") as! Ce_AddCmpsealVC
        if SE_flag {
            vc = CertifiSB.instantiateViewController(withIdentifier: "SE_Ce_AddCmpsealVC") as! Ce_AddCmpsealVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
}

extension Ce_sealListVC: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cmpList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SignTableViewCell", for: indexPath) as? SignTableViewCell {
            cell.selectionStyle = .none
            let cmpListIndexPath = cmpList[indexPath.row]
            let profimg = cmpListIndexPath.sealimg
            let name = cmpListIndexPath.name
            
            if selectedRows == cmpListIndexPath.sid
            {
                cmpListIndexPath.certflag = 1
                cell.checkedBtn.setImage(CheckimgOn, for: .normal)
            }
            else
            {
                cmpListIndexPath.certflag = 0
                cell.checkedBtn.setImage(CheckimgOff, for: .normal)
            }
            
            cell.signImageView.sd_setImage(with: URL(string: profimg), placeholderImage: UIImage(named: "logo_pre"))
            
            cell.selBtn.tag = indexPath.row
            cell.selBtn.addTarget(self, action: #selector(selInfo(_:)), for: .touchUpInside)
            
            cell.lblTitle.text = name
            cell.checkedBtn.tag = cmpListIndexPath.sid
            cell.checkedBtn.addTarget(self, action: #selector(checkBoxSelection(_:)), for: .touchUpInside)
            return cell
        }
        
        return UITableViewCell()
    }
    
    @objc func checkBoxSelection(_ sender:UIButton)
    {
        print("\n---------- [ checkBoxSelection ] ----------\n")
        let selectedIndexPath = sender.tag
        if self.selectedRows == selectedIndexPath
        {
            self.selectedRows = -1
        }
        else
        {
            self.selectedRows = selectedIndexPath
            
        }
        
        NetworkManager.shared().Ce_useCmpseal(cmpsid: CompanyInfo.sid, cslsid: selectedIndexPath) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode == 1 {
                    print("\n---------- [ 성공 ] ----------\n")
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
        self.tblList.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    @objc func selInfo(_ sender: UIButton){
        let selInfo = cmpList[sender.tag]
        
        if selInfo.type == 0 { //직인일때
            var vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_udtsealVC") as! Ce_udtsealVC
            if SE_flag {
                vc = CertifiSB.instantiateViewController(withIdentifier: "SE_Ce_udtsealVC") as! Ce_udtsealVC
            }
            vc.cmpSealInfo = selInfo
            vc.type = selInfo.useflag
            var img = UIImage(named: "btn_logo")
            if selInfo.sealimg.urlTrim() != "img_photo_default.png" {
                img = self.urlImage(url: selInfo.sealimg)
                
            }
            vc.cmpsealImg = img
            vc.cmpsealImage = selInfo.sealimg
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else{ //서명일때
            let vc = CertifiSB.instantiateViewController(withIdentifier: "Ce_udtSignVC") as! Ce_udtSignVC
            vc.cmpSealInfo = selInfo
            vc.type = selInfo.useflag
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableHeight = tblList.frame.height
        
        if offsetY + tableHeight == contentHeight  {
            faButton.removeFromSuperview()
        }else{
            view.addSubview(faButton)
            setupButton()
        }
    }
}

