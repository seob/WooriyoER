//
//  Lc_Step3VC.swift
//  PinPle
//
//  Created by seob on 2020/06/04.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class Lc_Step3VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var stepDot1: UIImageView!
    @IBOutlet weak var stepDot2: UIImageView!
    @IBOutlet weak var stepDot3: UIImageView!
    @IBOutlet weak var stepDot4: UIImageView!
    @IBOutlet weak var stepDot5: UIImageView!
    @IBOutlet weak var stepDot6: UIImageView!
    @IBOutlet weak var btnNext: UIButton!
    let ContractType : [(Int, String)]  = [(0, "월급") ,(1,"연봉")]
    
    var selInfo : LcEmpInfo = LcEmpInfo()
    var slytype = 0
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
        
        self.selectedRows = selInfo.slytype
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           if selInfo.form == 0 {
               lblNavigationTitle.text = "정규직 급여방식"
        
           }else if selInfo.form == 1 {
               lblNavigationTitle.text = "계약직 급여방식"
           }else {
               lblNavigationTitle.text = "수습 급여방식"
           }
        
        getLCinfo()
    }
    
    override func setNeedsFocusUpdate() {
        super.setNeedsFocusUpdate()
        selInfo.slytype = selectedRows
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
    
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = ContractSB.instantiateViewController(withIdentifier: "LC_Step2VC") as! LC_Step2VC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = selInfo
        self.present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        if selectedRows < 0 {
            self.toast("급여방식을 선택해 주세요.")
            return
        }else{
            selInfo.slytype = selectedRows
            NetworkManager.shared().set_step3(LCTSID: selInfo.sid, SLYTYPE: selInfo.slytype) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode == 1 {
                        let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step4VC") as! Lc_Step4VC
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
        SelPinplLcEmpInfo.viewpage = "step3"
        if SE_flag {
            presentPanModal(RowType.sebasic.presentable.rowVC)
        }else{
            presentPanModal(RowType.basic.presentable.rowVC)
        }
    }
    
}

private extension Lc_Step3VC {
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
            var viewpage: String = "step3"
            
            let rowVC: PanModalPresentable.LayoutType = ContractInfoPinplPopup()
        }
        
        struct SEBsic: RowPresentable {
            var viewpage: String = "step1"
            let rowVC: PanModalPresentable.LayoutType = SE_ContractInfoPinplPopup()
            
        }
    }
}

//MARK:- UITableViewMethods
extension Lc_Step3VC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContractType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContractTypeCell", for: indexPath) as? ContractTypeCell {
            cell.selectionStyle = .none
            cell.lblTitle.text = ContractType[indexPath.row].1
            print("\n---------- [ selectedRows : \(selectedRows) ] ----------\n")
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

