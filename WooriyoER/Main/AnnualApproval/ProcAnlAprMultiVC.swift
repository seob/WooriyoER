//
//  ProcAnlAprMultiVC.swift
//  PinPle
//
//  Created by seob on 2020/04/01.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class ProcAnlAprMultiVC: UIViewController {
     @IBOutlet weak var lblNavigationTitle: UILabel!
        @IBOutlet weak var imgProfile: UIImageView!
        @IBOutlet weak var lblSpot: UILabel!
        @IBOutlet weak var lblName: UILabel!
        @IBOutlet weak var lblTem: UILabel!
        @IBOutlet weak var lblDay: UILabel!
        @IBOutlet weak var lblHour: UILabel!
        @IBOutlet weak var lblMin: UILabel!
        @IBOutlet weak var lblClearDay: UILabel!
        @IBOutlet weak var lblAprDt: UILabel!
        @IBOutlet weak var lblAnlTime: UILabel!
        @IBOutlet weak var lblAnlType: UILabel!
        @IBOutlet weak var lblUseTime: UILabel!
        @IBOutlet weak var lblDdctn: UILabel!
        @IBOutlet weak var lblReason: UILabel!
        @IBOutlet weak var vwBtnApr: UIView!
        @IBOutlet weak var vwBtnRef: UIView!
        @IBOutlet weak var vwBtnHold: UIView!
        @IBOutlet weak var vwDdctn: UIView!
         
        @IBOutlet weak var lblEmp: UILabel!
        @IBOutlet weak var lblApr1: UILabel!
        @IBOutlet weak var lblApr2: UILabel!
        @IBOutlet weak var lblApr3: UILabel!
        @IBOutlet weak var lblRef1: UILabel!
        @IBOutlet weak var lblRef2: UILabel!
        @IBOutlet weak var vwApr1: CustomView!
        @IBOutlet weak var vwApr2: CustomView!
        @IBOutlet weak var vwApr3: CustomView!
        @IBOutlet weak var vwAprZero: UIView!
        @IBOutlet weak var vwAprOne: UIView!
        @IBOutlet weak var vwRefZero: UIView!
        @IBOutlet weak var vwRefOne: UIView!
        @IBOutlet weak var vwRef1: CustomView!
        @IBOutlet weak var vwRef2: CustomView!
        @IBOutlet weak var btnDdctn: UIButton!
        @IBOutlet weak var btnComfirm: UIButton!
    
        
        @IBOutlet weak var tblList: UITableView!
        @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
        @IBOutlet private weak var mainViewHeightConstraint: NSLayoutConstraint!
         
        let urlClass = UrlClass()
        let jsonClass = JsonClass()
        let httpRequest = HTTPRequest()
        
        var selTuple: [(String, Int, String, String, String, String, Int, Int, String, Int, Int, String, String, UIImage, Int, Int, String, Int)] = []
        var aprflag = 0 // 결재 0 참조 1 보류 2
        var holdflag = 0 // 보류 0. 반려 1
        var holdTuple: [(Int, Int, Int, Int, Int, String, Int)] = []
        
        var anlAprArr = AnualListArr()
        var apr1 = 0
        var apr1empsid = 0
        var apr1name = ""
        var apr1spot = ""
        var apr2 = 0
        var apr2empsid = 0
        var apr2name = ""
        var apr2spot = ""
        var apr3 = 0
        var apr3empsid = 0
        var apr3name = ""
        var apr3spot = ""
        var clearday = 0
        var ref1 = 0
        var ref1empsid = 0
        var ref1name = ""
        var ref1spot = ""
        var ref2 = 0
        var ref2empsid = 0
        var ref2name = ""
        var ref2spot = ""
        var remainmin = 0
        var sid = 0
        
        var aprdt = ""
        var aprsid = 0
        var regdt = ""
        var reason = ""
        var starttm = ""
        var endtm = ""
        var type = 0
        var diffmin = 0
        var spot = ""
        var mbrsid = 0
        var ddctn = 0
        var name = ""
        var tname = ""
        var profimg = ""
        var empsid = 0
        var refflag = 0
        var enname = ""
        
        var step = 0
        var nextEmpsid = 0
        
        var new_empsid = 0
        
        var aprLineInfo: AprInfo!
     
        override func viewDidLoad() {
            super.viewDidLoad()
            btnComfirm.layer.cornerRadius = 6
            imgProfile.makeRounded()
            if SE_flag {
                lblNavigationTitle.font = navigationFontSE
            }
            NotificationCenter.default.addObserver(self, selector: #selector(reloadViewData), name: .reloadList, object: nil)
            
            setUi()
        }
    
        func setUi(){
            tblList.delegate = self
            tblList.dataSource = self
            tblList.separatorStyle = .none 
            tblList.register(UINib.init(nibName: "AnlAprSubTypeCell", bundle: nil), forCellReuseIdentifier: "AnlAprSubTypeCell")
            
            tblList.keyboardDismissMode = .onDrag
            tblList.isScrollEnabled = true
//            tableViewHeightConstraint.constant = CGFloat(anlAprArr.anualaprsub.count) * 60.0
            if anlAprArr.anualaprsub.count < 3 {
                tableViewHeightConstraint.constant = CGFloat(anlAprArr.anualaprsub.count) * 40.0
            }
            mainViewHeightConstraint.constant = tableViewHeightConstraint.constant + 700.0
             
        }
     
    
        // MARK: reloadViewData
        @objc func reloadViewData(_ notification: Notification) {
            viewSetting()
            for (i,_) in AnlMultiArr.enumerated() {
                switch AnlMultiArr[i].ddctn {
                case 1:
                    anlAprArr.anualaprsub[i].subddctn = 1
                default:
                    anlAprArr.anualaprsub[i].subddctn = 0
                }
                self.tblList.reloadData()
                print("\n---------- [ AnlMultiArr : \(AnlMultiArr[i].ddctn) ] ----------\n")
            }
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            print("ProcAnlAprVC : 117 empsid = ", empsid)
            viewSetting()
            valueSetting()
             let empsid = userInfo.empsid
            new_empsid = empsid // FIXME: 2020.01.14 seob
            if aprflag == 0 {
                vwBtnApr.isHidden = false
                vwBtnRef.isHidden = true
                vwBtnHold.isHidden = true
            }else if aprflag == 1 {
                vwBtnApr.isHidden = true
                vwBtnRef.isHidden = false
                vwBtnHold.isHidden = true
            }else {
                vwBtnApr.isHidden = true
                vwBtnRef.isHidden = true
                vwBtnHold.isHidden = false
            }
            
            lblDay.text = timeArr(remainmin)[0]
            lblHour.text = timeArr(remainmin)[1]
            lblMin.text = timeArr(remainmin)[2]
            lblClearDay.text = String(clearday)
            
            if apr2empsid == 0 {
                vwAprZero.isHidden = true
            }else if apr3empsid == 0 {
                vwAprOne.isHidden = true
            }
            
            if ref1empsid == 0 {
                vwRefZero.isHidden = true
            }else if ref2empsid == 0 {
                vwRefOne.isHidden = true
            }
            
            lblApr1.text = apr1name + " " + apr1spot
            lblApr2.text = apr2name + " " + apr2spot
            lblApr3.text = apr3name + " " + apr3spot
            lblRef1.text = ref1name + " " + ref1spot
            lblRef2.text = ref2name + " " + ref2spot
            
            //결재자 승인상태(0.대기 1.보류 2.승인 3.반려)
            print("ProcAnlAprVC : 159 empsid = ", empsid)
            print("apr1empsid = ", apr1empsid)
            print("apr2empsid = ", apr2empsid)
            print("apr3empsid = ", apr3empsid)
            print("ref1empsid = ", ref1empsid)
            print("ref2empsid = ", ref2empsid)
            if apr1 == 2 {
                vwApr1.startColor = UIColor.init(hexString: "#EDEDF2")
                vwApr1.endColor = UIColor.init(hexString: "#EDEDF2")
                lblApr1.textColor = UIColor.init(hexString: "#CBCBD3")
            }else {
                if empsid == apr1empsid {
                    lblApr1.text = "나"
                    vwApr1.startColor = UIColor.init(hexString: "#FCCA00")
                    vwApr1.endColor = UIColor.init(hexString: "#FCCA00")
                    lblApr1.textColor = .black
                    nextEmpsid = apr2empsid
                    step = 1
                }else {
                    vwApr1.startColor = UIColor.init(hexString: "#EDEDF2")
                    vwApr1.endColor = UIColor.init(hexString: "#EDEDF2")
                    lblApr1.textColor = UIColor.init(hexString: "#161D4A")
                }
            }
            
            if apr2 == 2 {
                vwApr2.startColor = UIColor.init(hexString: "#EDEDF2")
                vwApr2.endColor = UIColor.init(hexString: "#EDEDF2")
                lblApr2.textColor = UIColor.init(hexString: "#CBCBD3")
            }else {
                if empsid == apr2empsid {
                    lblApr2.text = "나"
                    vwApr2.startColor = UIColor.init(hexString: "#FCCA00")
                    vwApr2.endColor = UIColor.init(hexString: "#FCCA00")
                    lblApr2.textColor = .black
                    nextEmpsid = apr3empsid
                    step = 2
                }else {
                    vwApr2.startColor = UIColor.init(hexString: "#EDEDF2")
                    vwApr2.endColor = UIColor.init(hexString: "#EDEDF2")
                    lblApr2.textColor = UIColor.init(hexString: "#161D4A")
                }
            }
            
            if apr3 == 2 {
                vwApr3.startColor = UIColor.init(hexString: "#EDEDF2")
                vwApr3.endColor = UIColor.init(hexString: "#EDEDF2")
                lblApr3.textColor = UIColor.init(hexString: "#CBCBD3")
            }else {
                if empsid == apr3empsid {
                    lblApr3.text = "나"
                    vwApr3.startColor = UIColor.init(hexString: "#FCCA00")
                    vwApr3.endColor = UIColor.init(hexString: "#FCCA00")
                    lblApr3.textColor = .black
                    nextEmpsid = 0
                    step = 3
                }else {
                    vwApr3.startColor = UIColor.init(hexString: "#EDEDF2")
                    vwApr3.endColor = UIColor.init(hexString: "#EDEDF2")
                    lblApr3.textColor = UIColor.init(hexString: "#161D4A")
                }
            }
            if ref1 == 1 {
                vwRef1.startColor = UIColor.init(hexString: "#EDEDF2")
                vwRef1.endColor = UIColor.init(hexString: "#EDEDF2")
                lblRef1.textColor = UIColor.init(hexString: "#CBCBD3")
            }else {
                if empsid == ref1empsid {
                    lblRef1.text = "나"
                    vwRef1.startColor = UIColor.init(hexString: "#FCCA00")
                    vwRef1.endColor = UIColor.init(hexString: "#FCCA00")
                    lblRef1.textColor = .black
//                    btnDdctn.isEnabled = false
                }else {
                    vwRef1.startColor = UIColor.init(hexString: "#EDEDF2")
                    vwRef1.endColor = UIColor.init(hexString: "#EDEDF2")
                    lblRef1.textColor = UIColor.init(hexString: "#161D4A")
                }
            }
            if ref2 == 1 {
                vwRef2.startColor = UIColor.init(hexString: "#EDEDF2")
                vwRef2.endColor = UIColor.init(hexString: "#EDEDF2")
                lblRef2.textColor = UIColor.init(hexString: "#CBCBD3")
            }else {
                if empsid == ref2empsid {
                    lblRef2.text = "나"
                    vwRef2.startColor = UIColor.init(hexString: "#FCCA00")
                    vwRef2.endColor = UIColor.init(hexString: "#FCCA00")
                    lblRef2.textColor = .black
                    btnDdctn.isEnabled = false
                }else {
                    vwRef2.startColor = UIColor.init(hexString: "#EDEDF2")
                    vwRef2.endColor = UIColor.init(hexString: "#EDEDF2")
                    lblRef2.textColor = UIColor.init(hexString: "#161D4A")
                }
            }
             
        }
        //MARK: - navigation back button
        @IBAction func barBack(_ sender: UIButton) {
            var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
            if SE_flag {
                vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
            }else{
                vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
//            self.dismiss(animated: true, completion: nil)
        }
        
        // 연차내역 보기
        @IBAction private func AnualList(_ sender: UIButton) {
            let vc = MainSB.instantiateViewController(withIdentifier: "TotalAnualaprListVC") as! TotalAnualaprListVC
            viewflag = "ProcAnlAprVC"
            vc.cmpsid = userInfo.cmpsid
            vc.empsid = anlAprArr.empsid
            vc.name = anlAprArr.name
            vc.remain = self.remainmin
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        
        
        func viewSetting() {
            print("anlAprArr = ", anlAprArr.sid)
            aprdt = anlAprArr.aprdt
            aprsid = anlAprArr.sid
            regdt = anlAprArr.regdt
            reason = anlAprArr.reason
            starttm = anlAprArr.starttm
            endtm = anlAprArr.endtm
            type = anlAprArr.type
            diffmin = anlAprArr.diffmin
            spot = anlAprArr.spot
            mbrsid = anlAprArr.mbrsid
    //        ddctn = anlAprArr.ddctn
            ddctn = SelDdcnt
            name = anlAprArr.name
            tname = anlAprArr.tname
            profimg = anlAprArr.profimg
            empsid = anlAprArr.empsid
            refflag = anlAprArr.refflag
            enname = anlAprArr.enname
             
             
            
    //        imgProfile.image = profimg
//            let defaultProfimg = UIImage(named: "logo_pre")
//            if profimg.urlTrim() != "img_photo_default.png" {
//                imgProfile.setImage(with: profimg)
//             }else{
//                imgProfile.image = defaultProfimg
//             }
            imgProfile.sd_setImage(with: URL(string: profimg), placeholderImage: UIImage(named: "no_picture"))
            lblEmp.text = name
            lblSpot.text = spot
            var nameStr = name
            if enname != "" {
                nameStr += "(" + enname + ")"
            }
            lblName.text = nameStr
            lblTem.text = tname
            lblAprDt.text = regdt.replacingOccurrences(of: "-", with: ".") + " " + setWeek(regdt)
             
            var batchdiff = 0 // h
            var remainder = 0 // m

            if anlAprArr.batchdiff > 0 {
                batchdiff = (anlAprArr.batchdiff / 8)
                remainder = (anlAprArr.batchdiff % 8)
            }
            
            if batchdiff > 0 && remainder > 0 {
                lblUseTime.text = "\(batchdiff)d \(remainder)h"
            }else if batchdiff > 0 && remainder == 0 {
                lblUseTime.text = "\(batchdiff)d"
            }else if batchdiff == 0 && remainder > 0 {
                lblUseTime.text =   "\(remainder)h"
            }
            lblReason.text = reason
        }
        func valueSetting() {
            /*
             Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(연차 결재현황 조회)
             Return  - 연차 결재현황 정보, 연차정보(남은연차, 연차갱신 남은일 수 .. 연차신청 뷰 상단 연차관련 정보)
             Parameter
             APRSID        연차신청 번호
             EMPSID        연차신청자 직원번호
             */
            let aprsid = anlAprArr.sid
            let url = urlClass.get_anualaprline_status(aprsid: aprsid, empsid: empsid)
            if let jsonTemp: Data = jsonClass.weather_request(setUrl: url) {
                if let jsonData: NSDictionary = jsonClass.json_parseData(jsonTemp) {
                    print(url)
                    print(jsonData)

                    self.apr1 = jsonData["apr1"] as? Int ?? 0
                    self.apr1empsid = jsonData["apr1empsid"] as? Int ?? 0
                    self.apr1name = jsonData["apr1name"] as? String ?? ""
                    self.apr1spot = jsonData["apr1spot"] as? String ?? ""
                    self.apr2 = jsonData["apr2"] as? Int ?? 0
                    self.apr2empsid = jsonData["apr2empsid"] as? Int ?? 0
                    if self.apr2empsid != 0 {
                        self.apr2name = jsonData["apr2name"] as? String ?? ""
                        self.apr2spot = jsonData["apr2spot"] as? String ?? ""
                    }
                    self.apr3 = jsonData["apr3"] as? Int ?? 0
                    self.apr3empsid = jsonData["apr3empsid"] as? Int ?? 0
                    if self.apr3empsid != 0 {
                        self.apr3name = jsonData["apr3name"] as? String ?? ""
                        self.apr3spot = jsonData["apr3spot"] as? String ?? ""
                    }
                    self.clearday = jsonData["clearday"] as? Int ?? 0
                    self.ref1 = jsonData["ref1"] as? Int ?? 0
                    self.ref1empsid = jsonData["ref1empsid"] as? Int ?? 0
                    if self.ref1empsid != 0 {
                        self.ref1name = jsonData["ref1name"] as? String ?? ""
                        self.ref1spot = jsonData["ref1spot"] as? String ?? ""
                    }
                    self.ref2 = jsonData["ref2"] as? Int ?? 0
                    self.ref2empsid = jsonData["ref2empsid"] as? Int ?? 0
                    if self.ref2empsid != 0 {
                        self.ref2name = jsonData["ref2name"] as? String ?? ""
                        self.ref2spot = jsonData["ref2spot"] as? String ?? ""
                    }
                    self.remainmin = jsonData["remainmin"] as? Int ?? 0
                    self.sid = jsonData["sid"] as? Int ?? 0
                }
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
        
        func timeArr(_ time: Int) -> [String] {
            let day = time/(8*60)
            let hour = (time%(8*60))/60
            let min = (time%(8*60))%60
            var arr: [String] = []
            arr.append(String(day))
            arr.append(String(hour))
            arr.append(String(min))
            return arr
        }
        
        func timeStr(_ time: Int) -> String {
            let day = time/(8*60)
            let hour = (time%(8*60))/60
            let min = (time%(8*60))%60
            var timeStr = ""
            
             if day > 0 {
                 timeStr = timeStr + String(day) + "d "
             }
            if hour > 0  {
                timeStr = timeStr + String(hour) + "h "
            }
            if min > 0 {
                timeStr = timeStr + String(min) + "m"
            }
            return timeStr
        }
        
        @IBAction func refClick(_ sender: UIButton) {
            /*
             Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(연차신청 참조 확인 처리)
             Return  - 성공:1, 실패:0, 참조가 권한없음:-1
             Parameter
             APRSID        연차신청번호
             EMPSID        참조자 직원번호(본인)
             */
            let aprsid = anlAprArr.sid
    //        let empsid = prefs.value(forKey: "empsid") as! Int
            let empsid = userInfo.empsid
            let url = urlClass.read_anualapr(aprsid: aprsid, empsid: empsid)
            httpRequest.get(urlStr: url) {(success, jsonData) in
                if success {
                    Mainanualaprcnt -= 1
                    var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
                    if SE_flag {
                        vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
                    }else{
                        vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
                    }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                }else {
                    self.customAlertView("다시 시도해 주세요.")
                }
            }
            
        }
        @IBAction func aprClick(_ sender: UIButton) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProcAnlAprPopupOk") as! ProcAnlAprPopupOk
            
            vc.name = name
            vc.spot = spot
            vc.aprsid = aprsid
            vc.empsid = userInfo.empsid
            vc.step = step
            vc.ddctn = ddctn
            vc.reason = reason
            vc.nextEmpsid = nextEmpsid
            vc.anlAprArr = anlAprArr
            print("\n---------- [ name : \(name) , spot : \(spot) ] ----------\n")
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        @IBAction func holdClick(_ sender: UIButton) {
            holdTuple.removeAll()
            holdTuple.append((aprsid, new_empsid, step, ddctn, 1, reason, nextEmpsid))
            
            let vc = AnlAprSB.instantiateViewController(withIdentifier: "HoldMsgVC") as! HoldMsgVC
            
            vc.holdTuple = holdTuple
            vc.anlAprArr = anlAprArr
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
            
        }
        @IBAction func rejectClick(_ sender: UIButton) {
            holdTuple.removeAll()
            holdTuple.append((aprsid, new_empsid, step, ddctn, 3, reason, nextEmpsid))
            let vc = AnlAprSB.instantiateViewController(withIdentifier: "HoldMsgVC") as! HoldMsgVC
            
            vc.holdTuple = holdTuple
            vc.anlAprArr = anlAprArr
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
            
        }
    
    // 차감 , 미차감 팝업
        @IBAction func ddctnClick(_ sender: UIButton) {
            let vc = AnlAprSB.instantiateViewController(withIdentifier: "ProcAnlAprMultiPopUpDdctn") as! ProcAnlAprMultiPopUpDdctn
            
            vc.ddctn = anlAprArr.anualaprsub[sender.tag].subddctn
            vc.subsid = anlAprArr.anualaprsub[sender.tag].subsid
            vc.selTuple = selTuple
            vc.anlAprArr = anlAprArr
            vc.selIndexPathRow = sender.tag
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        
        
        func setWeek(_ str: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: str)
            let cal = Calendar(identifier: .gregorian)
            let comps = cal.dateComponents([.weekday], from: date!)
            var week = ""
            
            switch comps.weekday {
            case 1:
                week = "일";
            case 2:
                week = "월";
            case 3:
                week = "화";
            case 4:
                week = "수";
            case 5:
                week = "목";
            case 6:
                week = "금";
            case 7:
                week = "토";
            default:
                break;
            }
            
            return "(" + week + ")"
        }
        
    }

extension ProcAnlAprMultiVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return anlAprArr.anualaprsub.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnlAprSubTypeCell", for: indexPath) as! AnlAprSubTypeCell
            
            cell.selectionStyle = .none
            let anlIndexPath = anlAprArr.anualaprsub[indexPath.row]
         

            //연차종류코드(0.연차 1.오전반차 2.오후반차 3.조퇴 4.외출 5.병가 6.공가 7.경조 8.교육훈련 9.포상 10.공민권 11.생리)
        let str = anlIndexPath.subaprdt.replacingOccurrences(of: "-", with: ".")

            cell.lblDate.text =  str  + "(" + anlIndexPath.subwd + ") "

            var typeStr = ""
        switch anlIndexPath.subtype{
            case 0:
                typeStr = "연차 ";
            case 1:
                typeStr = "오전반차 ";
            case 2:
                typeStr = "오후반차 ";
            case 3:
                typeStr = "조퇴 ";
            case 4:
                typeStr = "외출 ";
            case 5:
                typeStr = "병가 ";
            case 6:
                typeStr = "공가 ";
            case 7:
                typeStr = "경조 ";
            case 8:
                typeStr = "교육훈련 ";
            case 9:
                typeStr = "포상 ";
            case 10:
                typeStr = "공민권 ";
            case 11:
                typeStr = "생리 ";
            default:
                break;
            }

            var ddctnStr = ""
        switch anlIndexPath.subddctn {
        case 1:
            ddctnStr = "차감"
        default:
            ddctnStr = "미차감"
        }
         
            cell.lblType.text = typeStr
            cell.lblDdctn.text = ddctnStr
 
        cell.ddctnButton.tag = indexPath.row
        cell.ddctnButton.addTarget(self, action: #selector(self.ddctnClick(_:)), for: .touchUpInside)
            return cell
    }
     
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
