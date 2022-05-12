//
//  PersonMgrListVC.swift
//  PinPle
//
//  Created by seob on 2020/06/02.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class PersonMgrListVC: UIViewController { 
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
     
    var empTuple: [PersonInfo] = []
    
    var mgrFlag = true
    
    var empsids = ""
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        tblList.rowHeight = UITableView.automaticDimension
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = UIViewController()
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_CmpMgrVC") as! CmpMgrVC
        }else {
            vc = MoreSB.instantiateViewController(withIdentifier: "CmpMgrVC") as! CmpMgrVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func valueSetting() {
        NetworkManager.shared().PersonMgrList(cmpsid: userInfo.cmpsid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else {
                    return
                }
                
                self.empTuple = serverData
                self.tblList.reloadData()
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
        if empTuple.count > 0 {
            tblList.contentSize.height = CGFloat(218 + (90 * (empTuple.count + 1)))
            print("\n---------- [ empTuple = \(empTuple.count) ] ----------\n")
        }
    }
    
    
    
    // FIXME: savePopUp
    @IBAction func savePopUp(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(직원 권한설정)
         Return  - 성공:설정완료 카운트, 실패:0
         Parameter
         EMPSIDS        직원번호들(구분자',')
         AUTH        권한(0.혼자쓰기 1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.팀관리자  5.직원) .. 해지시 5 넘김
         TEMSID        팀번호(팀관리자의 경우에만 필요.. 그외 0)
         TTMSID        상위팀번호(상위팀관리자의 경우에만 필요.. 그외 0)
         */
        
        NetworkManager.shared().SetEmpAuthor(empsids: empsids, auth: 5, temsid: 0, ttmsid: 0) { (isSuccess, resCode) in
            if (isSuccess){
                if resCode > 0 {
                    self.empTuple.removeAll()
                    DispatchQueue.main.async {
                        self.valueSetting()
                        self.tblList.reloadData()
                    }
                    
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
}

// MARK:  - UITableViewDelegate
extension PersonMgrListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if empTuple.count < 1 {
            return 2
        }
        return empTuple.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 218
        }else {
            return 90
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CmpMgrCell", for: indexPath) as! CmpMgrCell
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CmpMgrListCell", for: indexPath) as! CmpMgrListCell

            if empTuple.count < 1 {
                cell.vwNoMgr.isHidden = false
            }else {
                cell.vwNoMgr.isHidden = true
                let author = empTuple[indexPath.row - 1].author
                let enname = empTuple[indexPath.row - 1].enname
                //        let mbrsid = empTuple[indexPath.row - 1].2
                let name = empTuple[indexPath.row - 1].name
                let profimg = empTuple[indexPath.row - 1].profimg
                //        let sid = empTuple[indexPath.row - 1].5
                let spot = empTuple[indexPath.row - 1].spot


                if spot == "" {
                    cell.leadingConstraints.constant = -5
                }

                var authorImg = UIImage()
                switch author {
                case  0 :
                    authorImg = UIImage.init(named: "master_puple")!
                case 1:
                    authorImg = UIImage.init(named: "master_red")!;
                case 2:
                    authorImg = UIImage.init(named: "master_blue")!;
                case 3, 4:
                    authorImg = UIImage.init(named: "master_green")!;
                default:
                    break;
                }
 

//                if empTuple[indexPath.row - 1].profimg.urlTrim() != "img_photo_default.png" {
//                    cell.imgProfile.setImage(with: empTuple[indexPath.row - 1].profimg)
//                }else {
//                    cell.imgProfile.image = UIImage(named: "logo_pre")
//                }
                cell.imgProfile.sd_setImage(with: URL(string: empTuple[indexPath.row - 1].profimg), placeholderImage: UIImage(named: "logo_pre"))
                if enname == "" {
                    cell.lblName.text = name
                }else {
                    cell.lblName.text = name + "(" + enname + ") "
                }
                cell.lblSpot.text = spot
                cell.imgMgr.image = authorImg

                cell.btnCell.tag = indexPath.row - 1
                cell.btnCell.addTarget(self, action: #selector(selectCell(_:)), for: .touchUpInside)
            }
            return cell
        }
    }
    // FIXME: 팝업 수정
    @objc func selectCell(_ sender: UIButton) {
        let name = empTuple[sender.tag].name
        let empsids = String(empTuple[sender.tag].sid)
        DispatchQueue.main.async {
            let vc = MoreSB.instantiateViewController(withIdentifier: "PersonMgrPopUp") as! PersonMgrPopUp
            vc.name = name
            vc.empsids = empsids

            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }

}
