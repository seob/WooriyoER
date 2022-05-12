//
//  MTTListVC.swift
//  PinPle
//
//  Created by WRY_010 on 27/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit
import CoreLocation

class MTTListVC: UIViewController {
    
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
    
    
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btn_plus"), for: .normal)
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        return button
    }()
    
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
        if teamTuple.count > 0 {
            let vc = MoreSB.instantiateViewController(withIdentifier: "AddTemPopUp") as! AddTemPopUp
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }else {
            if SE_flag  {
                performSegue(withIdentifier: "SE_AddTemVC", sender: self)
            }else{
                performSegue(withIdentifier: "AddTemVC", sender: self)
            }
            
        }
    }
    
    // MARK: reloadViewData
    @objc func reloadViewData(_ notification: Notification) {
        valueSetting()
        // 2021.01.08 seob 수정
        view.addSubview(faButton)
        setupButton()
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
        /*
         Pinpl Android SmartPhone APP으로부터 요청받은 데이터 처리(상위팀 리스트 - 소속팀 포함).. 페이징 없음
         Return  - 상위팀 리스트(소속팀 포함)
         Parameter
         CMPSID        회사번호
         */
        teamTuple.removeAll()
        NetworkManager.shared().CmpTtmlist(cmpsid: userInfo.cmpsid) { (isSuccess, error, resData) in
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
    
    @IBAction func addTem(_ sender: UIButton) {
        if teamTuple.count > 0 {
            let vc = MoreSB.instantiateViewController(withIdentifier: "AddTemPopUp") as! AddTemPopUp
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }else {
            if SE_flag  {
                performSegue(withIdentifier: "SE_AddTemVC", sender: self)
            }else{
                performSegue(withIdentifier: "AddTemVC", sender: self)
            }
            
        }
    }
    
}
extension MTTListVC: UITableViewDelegate, UITableViewDataSource {
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "MTTeamCell") as!  MTTeamCell
            let empcnt = teamTuple[indexPath.row].empcnt
            let mgrcnt = teamTuple[indexPath.row].mgrcnt
            let name = teamTuple[indexPath.row].name
            let ttmsid = teamTuple[indexPath.row].ttmsid
            
            print(empcnt, mgrcnt, name)
            cell.lblName.text = name
            cell.lblManager.text = String(mgrcnt)
            cell.lblMember.text = String(empcnt)
            cell.btnSetting.tag = indexPath.row
            if ttmsid == 0 {
                cell.btnSetting.isEnabled = false
            }else {
                cell.btnSetting.isEnabled = true
            }
            cell.btnSetting.addTarget(self, action: #selector(self.setting(_:)), for: .touchUpInside)
            if cell.btnTemshow.isSelected {
                cell.imgBG.image = UIImage.init(named: "box_team_grey")
            }else {
                cell.imgBG.image = UIImage.init(named: "box_team_white")
            }
            cell.btnTemshow.tag = indexPath.row
            cell.btnTemshow.addTarget(self, action: #selector(self.temShow(_:)), for: .touchUpInside)
            
            return cell
        } else if teamTuple[indexPath.row].selflag {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MTeamCell", for: indexPath) as! MTeamCell
            let temempcnt = teamTuple[indexPath.row].empcnt
            let temmgrcnt = teamTuple[indexPath.row].mgrcnt
            let temname = teamTuple[indexPath.row].name
            let temsid = teamTuple[indexPath.row].temsid
            
            print("\t", temempcnt, temmgrcnt, temname)
            cell.lblName.text = temname
            cell.lblManager.text = String(temmgrcnt)
            cell.lblMember.text = String(temempcnt)
            if temsid == 0 {
                cell.btnSetting.isEnabled = false
            }else {
                cell.btnSetting.isEnabled = true
            }
            cell.btnSetting.tag = indexPath.row
            cell.btnSetting.addTarget(self, action: #selector(self.setting(_:)), for: .touchUpInside)
            
            return cell
        }
        return UITableViewCell()
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
    @objc func setting(_ sender: UIButton) {
        faButton.removeFromSuperview()
        SelTemFlag = teamTuple[sender.tag].temflag
        SelTtmSid = teamTuple[sender.tag].ttmsid
        SelTemSid = teamTuple[sender.tag].temsid
        
        let vc = MoreSB.instantiateViewController(withIdentifier: "TemSetPopUp") as! TemSetPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: true, completion: nil)        
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
