//
//  Lc_Step1VC.swift
//  PinPle
//
//  Created by seob on 2020/06/03.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Lc_Step1VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var stepDot1: UIImageView!
    @IBOutlet weak var stepDot2: UIImageView!
    @IBOutlet weak var stepDot3: UIImageView!
    @IBOutlet weak var stepDot4: UIImageView!
    @IBOutlet weak var stepDot5: UIImageView!
    @IBOutlet weak var stepDot6: UIImageView!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var btnNext: UIButton!
    
    let ContractType : [(Int, String)] = [(0 , "정규직 근로계약서 작성") , (1 , "계약직 근로계약서 작성") , (2, "수습 근로계약서 작성")]
    var selInfo : LcEmpInfo = LcEmpInfo()
    var selectedRows = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        tblList.register(UINib.init(nibName: "ContractTypeCell", bundle: nil), forCellReuseIdentifier: "ContractTypeCell")
        self.selectedRows = selInfo.form
    }
    
    func setDot(){
        
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_empListVC") as! Lc_empListVC
        if SE_flag {
            vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_empListVC") as! Lc_empListVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = selInfo
        self.present(vc, animated: false, completion: nil)
        
    }
    
    override func setNeedsFocusUpdate() {
        super.setNeedsFocusUpdate()
        selInfo.form = selectedRows
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLCinfo()
    }
    
    fileprivate func getLCinfo(){
        NetworkManager.shared().get_LCInfo(LCTSID: selInfo.sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                self.selInfo = serverData
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        if selectedRows < 0 {
            self.toast("핀플 근로계약서 종류를 선택하세요.")
            return
        }else{
            selInfo.form = selectedRows
            NetworkManager.shared().set_step1(lctsid: selInfo.sid, form: selInfo.form) { (isSuccess, resCode) in
                if(isSuccess){
                    if(resCode == 1){
                        var vc = ContractSB.instantiateViewController(withIdentifier: "LC_Step2VC") as! LC_Step2VC
                        if SE_flag {
                            vc = ContractSB.instantiateViewController(withIdentifier: "SE_LC_Step2VC") as! LC_Step2VC
                        }
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        vc.selInfo = self.selInfo
                        self.present(vc, animated: false, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        }

    }
    
    //MARK: - pop버튼
    @IBAction func moreBtn(_ sender: UIButton) {
        SelPinplLcEmpInfo = selInfo
        SelPinplLcEmpInfo.viewpage = "step1"
        if SE_flag {
            presentPanModal(RowType.sebasic.presentable.rowVC)
        }else{
            presentPanModal(RowType.basic.presentable.rowVC)
        }
    }
    
}
 

private extension Lc_Step1VC {
    enum RowType: Int, CaseIterable {
        case basic
        case sebasic

        var presentable: RowPresentable {
            switch self {
            case .basic: return Basic()
            case .sebasic: return SEBsic()
            }
        }

        struct Basic: RowPresentable {
            var viewpage: String = "step1"
            let rowVC: PanModalPresentable.LayoutType = ContractInfoPinplPopup()
        }
        
        struct SEBsic: RowPresentable {
            var viewpage: String = "step1"
            let rowVC: PanModalPresentable.LayoutType = SE_ContractInfoPinplPopup()
             
        }

    }
}


//MARK:- UITableViewMethods
extension Lc_Step1VC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContractType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContractTypeCell", for: indexPath) as? ContractTypeCell {
            cell.selectionStyle = .none
            cell.lblTitle.text = ContractType[indexPath.row].1
            if selectedRows == ContractType[indexPath.row].0
            {
                cell.chkImg.image = CheckimgOn
            }
            else
            {
                cell.chkImg.image = CheckimgOff
            }
            
            cell.checkedBtn.tag = ContractType[indexPath.row].0
            cell.checkedBtn.addTarget(self, action: #selector(checkBoxSelection(_:)), for: .touchUpInside)
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    @objc func checkBoxSelection(_ sender:UIButton)
    {
        print("\n---------- [ checkBoxSelection : \(sender.tag)] ----------\n")
        let selectedIndexPath = sender.tag
        if self.selectedRows == selectedIndexPath
        {
            self.selectedRows = -1
        }
        else
        {
            self.selectedRows = selectedIndexPath
            
        }
        self.tblList.reloadData()
    }
}
