//
//  SetHolidayVC.swift
//  PinPle
//
//  Created by WRY_010 on 02/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class HolidayListVC: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var swHoliday: UISwitch!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var vwAuthor: UIView!
    
    @IBOutlet weak var vwTitleArea: UIView!
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var CmpInfo:CmpInfo!
    

    var holiTuple : [HolidayInfo] = []
    
    var selTitle = ""
    var selDate = ""
    var selRpt = 0
    var selSid = 0
    var holiday = 0
    var disposeBag: DisposeBag = DisposeBag()
    
    let toggleHoliday = ToggleSwitch(with: images)
    var switchYposition:CGFloat = 0
    var switchXposition:CGFloat = 0
    lazy var faButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "btn_plus"), for: .normal)
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         if let view = UIApplication.shared.keyWindow {
            if moreCmpInfo.holiday == 1 {
             view.addSubview(faButton)
             setupButton()
            }
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
         var vc = MoreSB.instantiateViewController(withIdentifier: "SetHolidayVC") as! SetHolidayVC
         if SE_flag {
             vc = MoreSB.instantiateViewController(withIdentifier: "SE_SetHolidayVC") as! SetHolidayVC
         }else{
             vc = MoreSB.instantiateViewController(withIdentifier: "SetHolidayVC") as! SetHolidayVC
         }
         vc.addflag = true
         vc.holiTuple = self.holiTuple
         vc.holiday = self.holiday
         vc.modalTransitionStyle = .crossDissolve
         vc.modalPresentationStyle = .overFullScreen
         self.present(vc, animated: false, completion: nil)
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.isHidden = true
        
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.separatorStyle = .none 
        
        if moreCmpInfo.holiday == 1 {
            swHoliday.isOn = true
            toggleHoliday.setOn(on: true, animated: true)
            faButton.removeFromSuperview()
            tblList.isHidden = false
        }else {
            swHoliday.isOn = false
            toggleHoliday.setOn(on: false, animated: true)
            view.addSubview(faButton)
            setupButton()
            tblList.isHidden = true
        }
        
        if !authorCk(msg: "권한이 없습니다.\n마스터관리자와 최고관리자만 \n변경이 가능합니다.") {
            vwAuthor.isHidden = false
        }
        
        if view.bounds.width == 414 {
            switchYposition = 340
            switchXposition = 45
        }else if view.bounds.width == 375 {
            switchYposition = 300
            switchXposition = 45
        }else if view.bounds.width == 390 {
            // iphone 12 pro
            switchYposition = 310
            switchXposition = 45
        }else if view.bounds.width == 320 {
            // iphone se
            switchYposition = 240
            switchXposition = 45
        }else{
            switchYposition = 340
            switchXposition = 45
        }
        
        toggleHoliday.frame.origin.x = switchYposition
        toggleHoliday.frame.origin.y = switchXposition
         
        
        self.vwTitleArea.addSubview(toggleHoliday)
        
        toggleHoliday.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        
    }
    
    @objc func toggleValueChanged(toggle: ToggleSwitch) {
        /*
         Pinpl Android SmartPhone APP으로부터 요청받은 데이터 처리(회사 특별휴무일 유무 설정)
         Return  - 성공:1, 실패:0
         Parameter
         CMPSID        회사번호
         HOLIDAY        특별휴무일 유무 설정(0.없음 1.있음)
         */
        if toggle.isOn {
            tblList.isHidden = false
            view.addSubview(faButton)
            setupButton()
            holiday = 1
            valueSetting()
        }else {
            tblList.isHidden = true
            faButton.removeFromSuperview()
            holiday = 0
        }
        moreCmpInfo.holiday = holiday
        let url = urlClass.set_cmp_holidayset(cmpsid: userInfo.cmpsid, holiday: holiday)
        httpRequest.get(urlStr: url) {(success,jsonData) in
            if success {
                print("\n---------- [ success ] ----------\n")
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        holiTuple.removeAll()
        valueSetting()
        tblList.reloadData()
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
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(회사 특별휴무일 리스트)
         Return  - 특별휴무일 리스트 .. 페이징 없음 .. Sorting 최근등록순
         Parameter
         CMPSID        회사번호
         */
        NetworkManager.shared().getCmpHolidayList(cmpsid: userInfo.cmpsid) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                if serverData.count > 0 {
                    self.holiTuple = serverData
                    self.tblList.reloadData()
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
         
    }
    
    
    @IBAction func setHoliday(_ sender: UISwitch) {
        /*
         Pinpl Android SmartPhone APP으로부터 요청받은 데이터 처리(회사 특별휴무일 유무 설정)
         Return  - 성공:1, 실패:0
         Parameter
         CMPSID        회사번호
         HOLIDAY        특별휴무일 유무 설정(0.없음 1.있음)
         */
        if sender.isOn {
            tblList.isHidden = false
            view.addSubview(faButton)
            setupButton()
            holiday = 1
            valueSetting()
        }else { 
            tblList.isHidden = true
            faButton.removeFromSuperview()
            holiday = 0
        }
//        prefs.setValue(holiday, forKey: "holiday")
        moreCmpInfo.holiday = holiday
        let url = urlClass.set_cmp_holidayset(cmpsid: userInfo.cmpsid, holiday: holiday)
        httpRequest.get(urlStr: url) {(success,jsonData) in
            if success {
                print(url)
                print(jsonData)
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    @IBAction func addHoliday(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "SetHolidayVC") as! SetHolidayVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_SetHolidayVC") as! SetHolidayVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "SetHolidayVC") as! SetHolidayVC
        }
        vc.addflag = true
        vc.holiTuple = self.holiTuple
        vc.holiday = self.holiday
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}

extension HolidayListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holiTuple.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HolidayListCell", for: indexPath) as! HolidayListCell
        cell.selectionStyle = .none
        let holiDay = holiTuple[indexPath.row].holidt
        let holiName = holiTuple[indexPath.row].holinm
        let rptsetting = holiTuple[indexPath.row].rptsetting
        var rpt = ""
        
        switch rptsetting {
        case 0:
            rpt = "반복안함";
        case 1:
            rpt = "매년";
        default:
            rpt = "매년";
        }
        
        cell.lblHoliDay.text = holiDay.replacingOccurrences(of: "-", with: ".")
        cell.lblType.text = rpt
        cell.lblHoliName.text = holiName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selTitle = holiTuple[indexPath.row].holinm
        selDate = holiTuple[indexPath.row].holidt.replacingOccurrences(of: "-", with: ".")
        selRpt = holiTuple[indexPath.row].rptsetting
        selSid = holiTuple[indexPath.row].sid
        
        var vc = MoreSB.instantiateViewController(withIdentifier: "SetHolidayVC") as! SetHolidayVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_SetHolidayVC") as! SetHolidayVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "SetHolidayVC") as! SetHolidayVC
        }
        vc.addflag = false
        vc.selTitle = self.selTitle
        vc.selDate = self.selDate
        vc.selRpt = self.selRpt
        vc.selSid = self.selSid
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
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
