//
//  Sc_Step1VC.swift
//  PinPle
//
//  Created by seob on 2021/11/11.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class Sc_Step1VC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var stepDot1: UIImageView!
    @IBOutlet weak var stepDot2: UIImageView!
    @IBOutlet weak var stepDot3: UIImageView!
    @IBOutlet weak var stepDot4: UIImageView!
    @IBOutlet weak var stepDot5: UIImageView!
    @IBOutlet weak var stepDot6: UIImageView!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var btnNext: UIButton!
    let ContractType : [(Int, String)] = [(0 , "핀플 입사 보안서약서") , (1 , "핀플 퇴사 보안서약서")]
    var selInfo : ScEmpInfo = ScEmpInfo()
    var selectedRows = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        EnterpriseColor.nonLblBtn(btnNext)
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        var test = "\(selInfo.sid)"
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        tblList.register(UINib.init(nibName: "ContractTypeCell", bundle: nil), forCellReuseIdentifier: "ContractTypeCell")
        self.selectedRows = selInfo.format
    }
    
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_empListVC") as! Sc_empListVC
 
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.selInfo = selInfo
        self.present(vc, animated: false, completion: nil)
        
    }
    
    override func setNeedsFocusUpdate() {
        super.setNeedsFocusUpdate()
        selInfo.format = selectedRows
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLCinfo()
    }
    
    fileprivate func getLCinfo(){
        print("\n---------- [ selInfo.sid : \(selInfo.sid) ] ----------\n")
        NetworkManager.shared().get_SCInfo(LCTSID: selInfo.sid) { (isSuccess, resData) in
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
            self.toast("보안서약서 종류를 선택하세요.")
            return
        }else{
            selInfo.format = selectedRows
            NetworkManager.shared().set_Scstep1(lctsid: selInfo.sid, form: selInfo.format) { (isSuccess, resCode) in
                if(isSuccess){
                    if(resCode == 1){
                        let vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_Step2VC") as! Sc_Step2VC
                       
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
     
    
}


//MARK:- UITableViewMethods
extension Sc_Step1VC: UITableViewDataSource, UITableViewDelegate {
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
