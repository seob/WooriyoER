//
//  HomecmtareaEmpListVC.swift
//  PinPle
//
//  Created by seob on 2021/02/18.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit

class HomecmtareaEmpListVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwNoData: UIView!
    
    @IBOutlet weak var lblTotalCnt: UILabel!
    var empList : [HomeCmtAreaInfo] = []
    var mgrCnt = 0 //관리자 카운트
    var temCnt = 0 //팀원 카운트
    var ntitle = ""
    
    var author = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNavigationTitle.text = ntitle
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        lblTotalCnt.text = "관리자 \(mgrCnt)명, 팀원 \(temCnt)명"
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.allowsMultipleSelectionDuringEditing = true
        tblList.rowHeight = UITableView.automaticDimension
        tblList.separatorStyle = .none
        
        tblList.register(UINib.init(nibName: "HomecmtareaCell", bundle: nil), forCellReuseIdentifier: "HomecmtareaCell")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reloadList, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUi()
    }
    
    @objc func reloadTableData(_ notification: Notification) {
        setUi()
    }
    
    private func setUi(){
        NetworkManager.shared().Home_TemEmpList(cmpsid: userInfo.cmpsid, ttmsid: SelTtmSid, temsid: SelTemSid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                if serverData.count > 0 {
                    self.empList = serverData
                    self.vwNoData.isHidden = true
                }else{
                    self.vwNoData.isHidden = false
                }
                self.tblList.reloadData()
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }

        
 
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        
        let vc = MoreSB.instantiateViewController(withIdentifier: "HomeMTTListVC") as! HomeMTTListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}

// MARK: - UITableViewDataSource , UITableViewDelegate
extension HomecmtareaEmpListVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return empList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomecmtareaCell", for: indexPath) as? HomecmtareaCell {
            let empListIndexPath = empList[indexPath.row]
            cell.bindData(data: empListIndexPath)
            print("\n---------- [ status : \(empListIndexPath.status) ] ----------\n")
            if empListIndexPath.status > 0 {
                cell.btnDel.isHidden = true
            }else{              
                cell.btnDel.isHidden = false
                cell.btnDel.tag = indexPath.row
                cell.btnDel.addTarget(self, action: #selector(accessClick(_:)), for: .touchUpInside)
            }
            
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    @objc func accessClick(_ sender: UIButton){
        var selempInfo = HomeCmtAreaInfo()
        selempInfo = empList[sender.tag]
        
        let vc = MoreSB.instantiateViewController(withIdentifier: "AccessDelPopUp") as! AccessDelPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.empInfo = selempInfo
        self.present(vc, animated: false, completion: nil)
        
        
    }
    
    
}
