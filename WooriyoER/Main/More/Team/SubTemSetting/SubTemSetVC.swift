//
//  SubTemSetVC.swift
//  PinPle
//
//  Created by WRY_010 on 2020/02/11.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class SubTemSetVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var lblTTName: UILabel!
    @IBOutlet weak var tblTeamList: UITableView!
    @IBOutlet weak var lblMgrCnt: UILabel!
    @IBOutlet weak var lblMbrCnt: UILabel!
    
    var tuple: [SubTemlist] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTTName.text = SelTemInfo.name
        lblMgrCnt.text = "\(SelTemInfo.mgrcnt)"
        lblMbrCnt.text = "\(SelTemInfo.empcnt)"
        
        tblTeamList.delegate = self
        tblTeamList.dataSource = self
        tblTeamList.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // 뷰가 나타나는 시점 거의 두 번째
        valueSetting()
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
//        let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: false, completion: nil)
        NotificationCenter.default.post(name: .reloadTem, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(상위팀 팀 해제 추가를 위한 - 하위팀 + 무소속팀 목록) .. 페이징 없음
         Return  - 팀정보
         Parameter
         CMPSID        회사번호
         TTMSID        상위팀번호
         */
        NetworkManager.shared().TtmTemsetlist(cmpsid: userInfo.cmpsid, ttmsid: SelTtmSid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                self.tuple = serverData
                self.tblTeamList.reloadData()
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
}



extension SubTemSetVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tuple.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubTemSetCell") as!  SubTemSetCell
        
        let name = tuple[indexPath.row].name
        let ttmsid = tuple[indexPath.row].ttmsid
        
        cell.lblTeamName.text = name
        if ttmsid == SelTtmSid {
            cell.btnCell.isSelected = true
        }else {
            cell.btnCell.isSelected = false
        }
        
        cell.btnCell.tag = indexPath.row
        cell.btnCell.addTarget(self, action: #selector(cellClick), for: .touchUpInside)
        
        return cell
    }
    
    @objc func cellClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let temsid = tuple[sender.tag].sid
        let name = tuple[sender.tag].name
        
        if sender.isSelected {
            NetworkManager.shared().AddTeam(temsids: "\(temsid)", ttmsid: SelTtmSid) { (isSuccess, error, resultCode) in
                if (isSuccess) {
                    if error == 1 {
                        if resultCode == 1 {
                            self.toast("\(name) 팀이 합류 되었습니다.")
                            self.tuple[sender.tag].ttmsid = SelTtmSid
                        }else {
                            self.toast("잠시 후, 다시 시도해 주세요.")
                        }
                    }else {
                        self.customAlertView("다시 시도해 주세요.")
                    }
                }else {
                    self.customAlertView("네트워크 상태를 확인해 주세요.")
                }
                
            }
        }else {
            NetworkManager.shared().ExceptTeam(ttmsid: SelTtmSid, temsid: temsid) { (isSuccess, resultCode) in
                if (isSuccess) {
                    if resultCode == 1 {
                        self.toast("\(name) 팀이 해지 되었습니다.")
                        self.tuple[sender.tag].ttmsid = 0
                    }else {
                        self.toast("잠시 후, 다시 시도해 주세요.")
                    }
                }else {
                    self.toast("다시 시도해 주세요")
                }
                
            }
        }
        
    }
    
}
