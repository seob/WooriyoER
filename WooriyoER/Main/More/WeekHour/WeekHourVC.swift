//
//  WeekHourVC.swift
//  PinPle
//
//  Created by WRY_010 on 10/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class WeekHourVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var swWeek: UISwitch!
    @IBOutlet weak var swMonth: UISwitch!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwAuthor: UIView!
    @IBOutlet weak var vwNoEmp: UIView!
    
    @IBOutlet weak var vwWeekArea: CustomView!
    @IBOutlet weak var vwMonthArea: CustomView!
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    
    var tuple: [WarningEmpInfo] = []
    
    var selempsid = 0
    var selenname = ""
    var selmaxworkmin = 0
    var selmbrsid = 0
    var selname = ""
    var selprofimg = UIImage()
    var selspot = ""
    var selworkmin = 0
    var seltname = ""
    
    var wk52h = 0
    
    let toggleWeek = ToggleSwitch(with: images)
    let toggleMonth = ToggleSwitch(with: images)
    var switchYposition:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.delegate = self
        tblList.dataSource = self
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        if view.bounds.width == 414 {
            switchYposition = 50
        }else if view.bounds.width == 375 {
            switchYposition = 50
        }else if view.bounds.width == 390 {
            // iphone 12 pro
            switchYposition = 50
        }else if view.bounds.width == 320 {
            // iphone se
            switchYposition = 40
        }else{
            switchYposition = 60
        }
        toggleWeek.frame.origin.x = switchYposition
        toggleWeek.frame.origin.y = 30
        toggleWeek.tag = 1
        
        toggleMonth.frame.origin.x = switchYposition
        toggleMonth.frame.origin.y = 30
        toggleMonth.tag = 2
        
        self.vwWeekArea.addSubview(toggleWeek)
        self.vwMonthArea.addSubview(toggleMonth)
        
        toggleWeek.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        toggleMonth.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
    }
    
    @objc func toggleValueChanged(toggle: ToggleSwitch) {
        if toggle.tag == 1 {
            if toggle.isOn {
                swMonth.isOn = false
                toggleMonth.setOn(on: false, animated: true)
                wk52h = 0
            }else {
                swMonth.isOn = true
                toggleMonth.setOn(on: true, animated: true)
                wk52h = 1
            }
        }else {
            if toggle.isOn {
                swWeek.isOn = false
                toggleWeek.setOn(on: false, animated: true)
                wk52h = 1
            }else {
                swWeek.isOn = true
                toggleWeek.setOn(on: true, animated: true)
                wk52h = 0
            }
        }
        print("\n-------------[wk52h : \(wk52h)]---------------\n")
        switchSetting()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblList.separatorStyle = .none
        viewflag = "WeekHourVC"
        wk52h = moreCmpInfo.wk52h
        print("\n-------------[wk52h : \(wk52h)]---------------\n")
        if wk52h == 0 {
            swWeek.isOn = true
            toggleWeek.setOn(on: true, animated: true)
            swMonth.isOn = false
            toggleMonth.setOn(on: false, animated: true)
            valueSetting()
        }else {
            swWeek.isOn = false
            toggleWeek.setOn(on: false, animated: true)
            swMonth.isOn = true
            toggleWeek.setOn(on: true, animated: true)
            switchSetting()
        }
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func switchWeek(_ sender: UISwitch) {
        if sender == swWeek {
            if sender.isOn {
                swMonth.isOn = false
                toggleMonth.setOn(on: false, animated: true)
                wk52h = 0
            }else {
                swMonth.isOn = true
                toggleMonth.setOn(on: true, animated: true)
                wk52h = 1
            }
        }else {
            if sender.isOn {
                swWeek.isOn = false
                toggleWeek.setOn(on: false, animated: true)
                wk52h = 1
            }else {
                swWeek.isOn = true
                toggleWeek.setOn(on: true, animated: true)
                wk52h = 0
            }
        }
        print("\n-------------[wk52h : \(wk52h)]---------------\n")
        switchSetting()
    }
    func switchSetting() {
        let cmpsid = userInfo.cmpsid
        
        NetworkManager.shared().SetCmpWk52h(cmpsid: cmpsid, wk52h: wk52h) { (isSuccess, resultCode) in
            if (isSuccess) {
                switch resultCode {
                case -1:
                    let alert = UIAlertController.init(title: "알림", message: "회사 근로시간이 설정 되어있는 경우,\n월단위 선택은 불가합니다.", preferredStyle: .alert)
                    let okAction = UIAlertAction.init(title: "설정하기", style: .default, handler: {action in
                        moreCmpInfo.wk52h = 1
                        
                        let vc = MoreSB.instantiateViewController(withIdentifier: "CmtTimeVC") as! CmtTimeVC
                       vc.modalTransitionStyle = .crossDissolve
                       vc.modalPresentationStyle = .overFullScreen
                       self.present(vc, animated: false, completion: nil)
                    })
                    let cancelAction = UIAlertAction.init(title: "확인", style: .cancel, handler: { action in
                        self.swWeek.isOn = true
                        self.swMonth.isOn = false
                        moreCmpInfo.wk52h = 0
                        self.wk52h = 0
                        self.valueSetting()
                    })
                    
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: false, completion: nil)
                    
                case 0:
                    self.customAlertView("잠시 후, 다시 시도해 주세요.")
                default:
                    moreCmpInfo.wk52h = self.wk52h
                    self.valueSetting()
                }
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    func valueSetting() {
        let cmpsid: Int = userInfo.cmpsid
        var ttmsid: Int = userInfo.ttmsid
        var temsid: Int = userInfo.temsid
        
        switch userInfo.author {
        case 1, 2:
            ttmsid = 0
            temsid = 0
        case 3:
            temsid = 0
        case 4:
            ttmsid = 0
        default:
            ttmsid = 0
            temsid = 0
            break
        }
        
        NetworkManager.shared().WarningEmplist(wk52h: wk52h, cmpsid: cmpsid, ttmsid: ttmsid, temsid: temsid) { (isSuccess, resData) in
            if (isSuccess) { 
                guard let serverData = resData else { return }
                self.tuple = serverData
                self.tblList.reloadData()
                if self.tuple.count > 0 {
                    self.vwNoEmp.isHidden = true
                }else {
                    self.vwNoEmp.isHidden = false
                }
                 
                
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    func minTemp(_ time: Int) -> [String]{
        let hour = String(time / 60)
        let min = String(time % 60)
        var arr: [String] = []
        
        arr.append(hour)
        arr.append(min)
        
        return arr
    }
}
extension WeekHourVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tuple.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaringListCell") as!  WaringListCell
         
        let enname = tuple[indexPath.row].enname
        let maxworkmin = tuple[indexPath.row].maxworkmin
        let name = tuple[indexPath.row].name
        let spot = tuple[indexPath.row].spot
        let workmin = tuple[indexPath.row].workmin
        let tname = tuple[indexPath.row].tname
        
 
        cell.imgProfile.sd_setImage(with: URL(string: self.tuple[indexPath.row].profimg), placeholderImage: UIImage(named: "logo_pre"))
        cell.lblSpot.text = spot
        
        var nameStr = name
        if enname != "" {
            nameStr += "(" + enname + ")"
        }
        
        cell.lblName.text = nameStr
        
        
        cell.lblHour.text = minTemp(workmin)[0]
        cell.lblMin.text = minTemp(workmin)[1]
        cell.lblMaxCmt.text = minTemp(maxworkmin)[0]
        cell.lblTem.text = tname
        
        cell.btnCell.tag = indexPath.row
        cell.btnCell.addTarget(self, action: #selector(self.showPop(_:)), for: .touchUpInside)
        
        return cell
    }
    @objc func showPop(_ sender: UIButton) {
        // 2020.01.16 seob
        let vc = MoreSB.instantiateViewController(withIdentifier: "WeekHourPopUp") as! WeekHourPopUp
        
        SelWarningEmpInfo = self.tuple[sender.tag]
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false, completion: nil)
        
        
    }
    
    
}
