//
//  HomeMTTListVC.swift
//  PinPle
//
//  Created by seob on 2021/02/18.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit
import CoreLocation

class HomeMTTListVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwAdd: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    
    //    let customAlertVC = TemSetPopUp.instantiate()
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var CmpInfo: CmpInfo!
    
    var tuple: [Ttmlist] = []
    var teamTuple: [(temflag: Bool, selflag: Bool, empcnt: Int, mgrcnt: Int, name: String, ttmsid: Int, temsid: Int)] = []
    
    var ttmsid = 0
    var temsid = 0
    var disposeBag: DisposeBag = DisposeBag()
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.allowsMultipleSelectionDuringEditing = true
        tblList.rowHeight = UITableView.automaticDimension
        tblList.separatorStyle = .none
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViewData), name: .reloadTem, object: nil)
 
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
  
    // MARK: reloadViewData
    @objc func reloadViewData(_ notification: Notification) {
        valueSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        
        let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
        
        
    }
    func valueSetting() {
        teamTuple.removeAll()
        NetworkManager.shared().Home_cmtTtmlist(cmpsid: userInfo.cmpsid) { (isSuccess, error, resData) in
            if (isSuccess) {
                if error == 1 {
                    guard let serverData = resData else { return }
                    self.tuple = serverData
                    if self.tuple.count > 0 {
                        for i in 0...self.tuple.count-1 {
                            self.teamTuple.append((true, true,
                                                   self.tuple[i].empcnt,
                                                   self.tuple[i].mgrcnt,
                                                   self.tuple[i].name,
                                                   self.tuple[i].sid,
                                                   0))
                            
                            if self.tuple[i].temlist.count > 0 {
                                for j in 0...self.tuple[i].temlist.count - 1 {
                                    self.teamTuple.append((false, true,
                                                           self.tuple[i].temlist[j].temempcnt,
                                                           self.tuple[i].temlist[j].temmgrcnt,
                                                           self.tuple[i].temlist[j].temname,
                                                           self.tuple[i].sid,
                                                           self.tuple[i].temlist[j].temsid))
                                }
                            }
                        }
                    }
                    self.tblList.reloadData()
                }else {
                    self.customAlertView("다시 시도해 주세요.")
                }
            }else {
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
        }
    }
}
extension HomeMTTListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamTuple.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !teamTuple[indexPath.row].selflag {
            return 0
        }
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if teamTuple.count > 0 {
            vwAdd.isHidden = true
        }else {
            vwAdd.isHidden = false
        }
       
         
        
        if teamTuple[indexPath.row].temflag {
    
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMTTeamCell") as!  HomeMTTeamCell
                
                
                let empcnt = teamTuple[indexPath.row].empcnt
                let mgrcnt = teamTuple[indexPath.row].mgrcnt
                let name = teamTuple[indexPath.row].name
                let ttmsid = teamTuple[indexPath.row].ttmsid
                
                print(empcnt, mgrcnt, name)
                cell.lblName.text = name
                if name == "상위팀 미지정" {
                    cell.nonVW.isHidden = true
                }else{
                    cell.nonVW.isHidden = false
                    cell.lblManager.text = String(mgrcnt)
                    cell.lblMember.text = String(empcnt)
                    cell.btnhomeSel.tag = indexPath.row
                    cell.btnhomeSel.addTarget(self, action: #selector(self.setting(_:)), for: .touchUpInside)
                }
                
             

                if cell.btnTemshow.isSelected {
                    cell.imgBG.image = UIImage.init(named: "box_team_grey")
                }else {
                    cell.imgBG.image = UIImage.init(named: "box_team_white")
                }
                cell.btnTemshow.tag = indexPath.row
                cell.btnTemshow.addTarget(self, action: #selector(self.temShow(_:)), for: .touchUpInside)
                
                return cell
             
 
        } else if teamTuple[indexPath.row].selflag {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMTeamCell", for: indexPath) as! HomeMTeamCell
            let temempcnt = teamTuple[indexPath.row].empcnt
            let temmgrcnt = teamTuple[indexPath.row].mgrcnt
            let temname = teamTuple[indexPath.row].name
            let temsid = teamTuple[indexPath.row].temsid
            
            print("\t", temempcnt, temmgrcnt, temname)
            cell.lblName.text = temname
            cell.lblManager.text = String(temmgrcnt)
            cell.lblMember.text = String(temempcnt)
             
 
            cell.btnSetting.tag = indexPath.row
            cell.btnSetting.addTarget(self, action: #selector(self.setting(_:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
   
    
    
    // MARK: - 재택 출퇴근 설정 직원
    @objc func setting(_ sender: UIButton) {
        SelTtmSid = teamTuple[sender.tag].ttmsid
        SelTemSid = teamTuple[sender.tag].temsid
        
        let vc = MoreSB.instantiateViewController(withIdentifier: "HomecmtareaEmpListVC") as! HomecmtareaEmpListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.mgrCnt = teamTuple[sender.tag].mgrcnt
        vc.temCnt = teamTuple[sender.tag].empcnt
        vc.ntitle = teamTuple[sender.tag].name
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func temShow(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let ttmsid = teamTuple[sender.tag].ttmsid
        for i in 0...teamTuple.count - 1 {
            if teamTuple[i].ttmsid == ttmsid && teamTuple[i].temsid != 0 {
                teamTuple[i].selflag = sender.isSelected
            }
        }
        tblList.reloadData()
        
    }
}
