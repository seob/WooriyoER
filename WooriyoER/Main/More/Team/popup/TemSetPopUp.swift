//
//  TemSetPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/08.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class TemSetPopUp: UIViewController {
    
    @IBOutlet weak var lblTmName: UILabel!
    @IBOutlet weak var lblEmpCnt: UILabel!
    @IBOutlet weak var lblMgrCnt: UILabel!
    @IBOutlet weak var lblCmtTime: UILabel!
    @IBOutlet weak var lblAnlCnt: UILabel!
    @IBOutlet weak var lblCmtType: UILabel!
    @IBOutlet weak var boxHeight: NSLayoutConstraint!
    @IBOutlet weak var vwBox: CustomView!
    @IBOutlet weak var vwSubTemSet: CustomView!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxHeight.constant = vwBox.frame.size.width * 80/105
        
        if SelTemFlag {
            vwSubTemSet.isHidden = false
        }else {
            vwSubTemSet.isHidden = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViewData), name: .reloadTem, object: nil)
    }
    // MARK: reloadViewData
    @objc func reloadViewData(_ notification: Notification) {
        valueSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
    }
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(상위팀 정보)
         Return  - 상위팀 정보
         Parameter
         TTMSID(TEMSID)        상위팀번호(팀번호)
         */
        print("\n---------- [ 1 SelTtmSid : \(SelTtmSid) , SelTemSid:\(SelTemSid) , SelTemSid :\(SelTemSid)] ----------\n")
        
        NetworkManager.shared().GetTemInfo(temflag: SelTemFlag, ttmsid: SelTtmSid, temsid: SelTemSid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                SelTemInfo = serverData 
                SelTemInfo.starttm = SelTemInfo.starttm.timeTrim()
                SelTemInfo.endtm = SelTemInfo.endtm.timeTrim()
                SelTemInfo.name = serverData.name
                SelTemInfo.anualapr = serverData.anualapr
                SelTemInfo.applyapr = serverData.applyapr
                SelTemInfo.cmtlt = serverData.cmtlt
                self.lblTmName.text = SelTemInfo.name
                self.lblEmpCnt.text = "\(SelTemInfo.empcnt)"
                self.lblMgrCnt.text = "\(SelTemInfo.mgrcnt)"
                self.lblAnlCnt.text = "\(SelTemInfo.anuallimit)"
                
                //근무일정 사용 여부(0.사용안함 1.회사일정 2.팀일정)
                switch SelTemInfo.schdl {
                case 0:
                    self.lblCmtTime.text = "설정안함";
                case 1:
                    self.lblCmtTime.text = "회사일정";
                case 2:
                    self.lblCmtTime.text = "팀 일정";
                default:
                    break;
                }
                
                //출퇴근영역 설정(0.설정안함 1.WiFi 2.Gps 3.Beacon  4.회사출퇴근영역이용)
                switch SelTemInfo.cmtarea {
                case 0:
                    self.lblCmtType.text = "설정안함";
                case 1:
                    self.lblCmtType.text = "WiFi";
                case 2:
                    self.lblCmtType.text = "Gps";
                case 3:
                    self.lblCmtType.text = "Beacon";
                case 4:
                    self.lblCmtType.text = "회사 출퇴근"
                default:
                    break;
                }
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    func authorCk() -> Bool {
        //        let author = prefs.value(forKey: "author") as! Int
        print("\n---------- [ author : \(userInfo.author) , SelTtmSid : \(userInfo.ttmsid) , SelTemSid : \(userInfo.temsid) ] ----------\n")
        let author = userInfo.author
        //최고관리자 , 마스터 , 인사담당자 추가 (2번이 들어가면 인사담당자도 들어갈수있게 ) 2020.06.08
//        if author == 1 || author == 2 {
        if author <= 2 {
            return true
        }else {
            if SelTtmSid == userInfo.ttmsid  {
                return true
            }else {
                return false
            }
        }
    }
    //닫기
    @IBAction func settingClose(_ sender: UIButton) {
        // 2021.01.08 seob 수정
        dismiss(animated: true) {
            NotificationCenter.default.post(name: .reloadTem, object: nil)
        }
    }
    //팀 설정
    @IBAction func temSetting(_ sender: UIButton) {
        if authorCk() {
            var vc = MoreSB.instantiateViewController(withIdentifier: "TemSettingVC") as! TemSettingVC
            if SE_flag {
                vc = MoreSB.instantiateViewController(withIdentifier: "SE_TemSettingVC") as! TemSettingVC
            }else{
                vc = MoreSB.instantiateViewController(withIdentifier: "TemSettingVC") as! TemSettingVC
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }else {
//            SelTtmSid = userInfo.ttmsid
//            SelTemSid = userInfo.temsid
            self.toast("수정 권한이 없습니다.")
        }
        
    }
    //팀원추가
    @IBAction func addMmb(_ sender: UIButton) {
        if authorCk() {
            let vc = MoreSB.instantiateViewController(withIdentifier: "AddMemberVC") as! AddMemberVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }else {
//            SelTtmSid = userInfo.ttmsid
//            SelTemSid = userInfo.temsid
            self.toast("수정 권한이 없습니다.")
        }
        
    }
    //팀원관리
    @IBAction func mgrMenber(_ sender: UIButton) {
        if authorCk() {
            let vc = MoreSB.instantiateViewController(withIdentifier: "TemEmpList") as! TemEmpList
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }else {
//            SelTtmSid = userInfo.ttmsid
//            SelTemSid = userInfo.temsid
            self.toast("수정 권한이 없습니다.")
        }
        
    }
    //관리자설정
    @IBAction func setMgr(_ sender: UIButton) {
        if authorCk() {
            let vc = MoreSB.instantiateViewController(withIdentifier: "SetMgrVC") as! SetMgrVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }else {
//            SelTtmSid = userInfo.ttmsid
//            SelTemSid = userInfo.temsid
            self.toast("수정 권한이 없습니다.")
        }
        
    }
    //출퇴근설정
    @IBAction func setCmtArea(_ sender: UIButton) {
        if authorCk() {
            var vc = MoreSB.instantiateViewController(withIdentifier: "TemSetCmtVC") as! TemSetCmtVC
            if SE_flag {
                vc = MoreSB.instantiateViewController(withIdentifier: "SE_TemSetCmtVC") as! TemSetCmtVC
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }else {
//            SelTtmSid = userInfo.ttmsid
//            SelTemSid = userInfo.temsid
            self.toast("수정 권한이 없습니다.")
        }
        
    }
    //근로시간 설정
    @IBAction func setCmtTime(_ sender: UIButton) {
        if authorCk() {
            let vc = MoreSB.instantiateViewController(withIdentifier: "TemCmtTimeVC") as! TemCmtTimeVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }else {
//            SelTtmSid = userInfo.ttmsid
//            SelTemSid = userInfo.temsid
            self.toast("수정 권한이 없습니다.")
        }
        
    }
    //연차설정
    @IBAction func setAnl(_ sender: UIButton) {
        if authorCk() {
            var vc = MoreSB.instantiateViewController(withIdentifier: "SetTemAnlVC") as! SetTemAnlVC
            if SE_flag {
                vc = MoreSB.instantiateViewController(withIdentifier: "SE_SetTemAnlVC") as! SetTemAnlVC
            }else{
                vc = MoreSB.instantiateViewController(withIdentifier: "SetTemAnlVC") as! SetTemAnlVC
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }else {
//            SelTtmSid = userInfo.ttmsid
//            SelTemSid = userInfo.temsid
            self.toast("수정 권한이 없습니다.")
        }
        
        
    }
    //결재설정
    @IBAction func setApr(_ sender: UIButton) {
        if authorCk() {
            let vc = MoreSB.instantiateViewController(withIdentifier: "AprSelVC") as! AprSelVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }else {
//            SelTtmSid = userInfo.ttmsid
//            SelTemSid = userInfo.temsid
            
            self.toast("수정 권한이 없습니다.")
        }
        
        
    }
    //하위팀 설정
    @IBAction func subTemSet(_ sender: UIButton) {
        if authorCk() {
            var vc = MoreSB.instantiateViewController(withIdentifier: "SubTemSetVC") as! SubTemSetVC
            if SE_flag {
                vc = MoreSB.instantiateViewController(withIdentifier: "SE_SubTemSetVC") as! SubTemSetVC
            }else{
                vc = MoreSB.instantiateViewController(withIdentifier: "SubTemSetVC") as! SubTemSetVC
            }
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }else {
//            SelTtmSid = userInfo.ttmsid
//            SelTemSid = userInfo.temsid
            self.toast("수정 권한이 없습니다.")
        }
        
    }
    
    // 팀공지
    @IBAction private func TeamNotice(_ sender: Any) {
        self.toast("준비중입니다.")
    }
}
