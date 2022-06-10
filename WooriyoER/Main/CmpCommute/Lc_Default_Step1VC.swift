//
//  Lc_Default_Step1VC.swift
//  PinPle
//
//  Created by seob on 2020/06/11.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Lc_Default_Step1VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var stepDot1: UIImageView!
    @IBOutlet weak var stepDot2: UIImageView!
    @IBOutlet weak var stepDot3: UIImageView!
    @IBOutlet weak var stepDot4: UIImageView!
    @IBOutlet weak var stepDot5: UIImageView!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tblList: UITableView!
    var standInfo : LcEmpInfo = LcEmpInfo()
    var form = 0
    let ContractType : [(Int, String)] = [(0 , "월급 (정규직, 무기계약직)") , (1 ,"월급 (계약직)") , (2 , "시급 (소정시간,아르바이트)") , (3 , "시급 (근로일별,아르바이트)") , (4 , "일급 (소정시간)") , (5, "일급 (근로일별)")]
    var selectedRows = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnNext)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        form = standInfo.form
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        tblList.register(UINib.init(nibName: "ContractTypeCell", bundle: nil), forCellReuseIdentifier: "ContractTypeCell")
        
        
        self.selectedRows = form
        
    }
    
    override func setNeedsFocusUpdate() {
        super.setNeedsFocusUpdate()
        standInfo.form = selectedRows
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLCinfo()
    }
    
    fileprivate func getLCinfo(){
        NetworkManager.shared().get_LCInfo(LCTSID: standInfo.sid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                self.standInfo = serverData
                SelLcEmpInfo = self.standInfo
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = ContractSB.instantiateViewController(withIdentifier: "Lc_empListVC") as! Lc_empListVC
        if SE_flag {
            vc = ContractSB.instantiateViewController(withIdentifier: "SE_Lc_empListVC") as! Lc_empListVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = standInfo
        vc.format = self.standInfo.format
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        if selectedRows < 0 {
            self.toast("근로 형태를 선택하세요.")
            return
        }else{
            standInfo.form = selectedRows
            print("\n---------- [ format : \(self.standInfo.format) ,  form :\(standInfo.form) ] ----------\n")
            NetworkManager.shared().lc_std_step1(lctsid: standInfo.sid, form: standInfo.form) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        if(self.standInfo.format == 1 && (self.selectedRows == 3 || self.selectedRows == 5)) {
                            let  vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step2VC") as! Lc_Default_Step2VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.standInfo = self.standInfo
                            vc.form = self.standInfo.form
                            self.present(vc, animated: false, completion: nil)
                        }else{
                            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Default_Step2_1VC") as! Lc_Default_Step2_1VC
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .overFullScreen
                            vc.standInfo = self.standInfo
                            vc.form = self.standInfo.form
                            self.present(vc, animated: false, completion: nil)
                        }
                        
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
        SelLcEmpInfo = standInfo
        SelLcEmpInfo.viewpage = "std_step1"
        if SE_flag {
            presentPanModal(RowType.sebasic.presentable.rowVC)
        }else{
            presentPanModal(RowType.basic.presentable.rowVC)
        }
    }
}

private extension Lc_Default_Step1VC {
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
            var viewpage: String = "std_step1"
            let rowVC: PanModalPresentable.LayoutType = ContractInfoPopup()
        }
        struct SEBsic: RowPresentable {
            var viewpage: String = "step1"
            let rowVC: PanModalPresentable.LayoutType = SE_ContractInfoPopup()
            
        }
    }
}

//MARK:- UITableViewMethods
extension Lc_Default_Step1VC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContractType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContractTypeCell", for: indexPath) as? ContractTypeCell {
            cell.selectionStyle = .none
            cell.lblTitle.text = ContractType[indexPath.row].1
            
            if selectedRows == ContractType[indexPath.row].0
            {
                //                cell.checkedBtn.setImage(CheckimgOn, for: .normal)
                cell.chkImg.image = CheckimgOn
            }
            else
            {
                //                cell.checkedBtn.setImage(CheckimgOff, for: .normal)
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
