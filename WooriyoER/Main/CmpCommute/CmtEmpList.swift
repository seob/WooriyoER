//
//  CmtEmpList.swift
//  PinPle
//
//  Created by WRY_010 on 10/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class CmtEmpList: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var tblList: UITableView!
    
    @IBOutlet weak var tabbarCustomView: UIView! //하단 탭바뷰
    @IBOutlet weak var tabButtonPinpl: UIButton! //하단 탭바 핀플
    @IBOutlet weak var tabButtonCmt: UIButton! // 하단 탭바 출퇴근
    @IBOutlet weak var tabButtonAnnual: UIButton! // 하단 탭바 연차
    @IBOutlet weak var tabButtonApply: UIButton! // 하단 탭바 신청
    @IBOutlet weak var tabButtonMore: UIButton! // 하단 탭바 더보기
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    
    var anualcnt = 0
    var applycnt = 0
    var empcnt = 0
    var joincode = ""
    var tname = ""
    
    var topteamData: NSArray?
    var teamTuple: [(Bool, String, Int)] = []
    var teamCount = 0
    
//    var cmtTuple: [(Int, Int, String, String, Int, String, String, String, String, UIImage, String, String, Int, Int)] = []
    var cmtTuple : [CmtEmplyInfo] = []
    var cmpsid = 1
    var ttmsid = -1
    var temsid = -1
    
    var cmtFlag = false
   
    var clickFlag = true
    var popFlag = false
    
    //2020.01.22 뷰 이동 변수 넘김 수정
    var selauthor = 0
    var selempsid = 0
    var selenddt = ""
    var selenname = ""
    var selmbrsid = 0
    var selmemo = ""
    var selname = ""
    var selphone = ""
    var selphonenum = ""
    var selprofimg = UIImage()
    var selspot = ""
    var selstartdt = ""
    var seltype = 0
    var selworkmin = 0
    
    var netflag: Bool = false   //네트워크매니저 호출 여부
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.rowHeight = UITableView.automaticDimension
        tblList.separatorStyle = .none
        tblList.backgroundColor = .clear
        tabbarheight(tblList)
         
    }
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: nil, type: indicatorType, fadeInAnimation: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        IndicatorSetting() //로딩
        cmtTuple.removeAll()
 
//        cmpsid = prefs.value(forKey: "cmpsid") as! Int
        cmpsid = userInfo.cmpsid
        if let cmt_popflag = prefs.value(forKey: "cmt_popflag") {
            popFlag = cmt_popflag as! Bool
        }
//        let author = prefs.value(forKey: "author") as! Int
        let author = userInfo.author
        if popFlag {
            ttmsid = prefs.value(forKey: "cmt_ttmsid") as! Int
            temsid = prefs.value(forKey: "cmt_temsid") as! Int
            if let tmptname = prefs.value(forKey: "cmt_temname") as? String {
                tname  = tmptname
            } // 2020.01.20 seob
        }else {
            switch author {
            case 1, 2:
//                tname = prefs.value(forKey: "cmpname") as! String;
                tname = CompanyInfo.name
            case 3:
                ttmsid = prefs.value(forKey: "cmt_ttmsid") as! Int;
                temsid = prefs.value(forKey: "cmt_temsid") as! Int;
//                tname = prefs.value(forKey: "ttmname") as! String;
                tname = userInfo.ttmname
            case 4:
                ttmsid = prefs.value(forKey: "cmt_ttmsid") as! Int;
                temsid = prefs.value(forKey: "cmt_temsid") as! Int;
//                tname = prefs.value(forKey: "temname") as! String;
                tname = userInfo.temname
            default:
                tname = CompanyInfo.name
                break;
            }
        }
   
        clickFlag = true
        cmtOnList()
         print("\n---------- [ cmpname  : \(userInfo.toJSON()) ] ----------\n")
    }
    //MARK: - Tabbar
    @IBAction func pinplTab(_ sender: UIButton) {
        var vc = UIViewController()
        if SE_flag {
            vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC") as! MainVC
        }else {
            vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func cmtTab(_ sender: UIButton) {
        var vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
        if SE_flag {
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_CmtEmpList") as! CmtEmpList
        }else{
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpList") as! CmtEmpList
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func anlTab(_ sender: UIButton) {
        var vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        if SE_flag {
            vc = AnlAprSB.instantiateViewController(withIdentifier: "SE_AnlMainList") as! AnlMainList
        }else{
            vc = AnlAprSB.instantiateViewController(withIdentifier: "AnlMainList") as! AnlMainList
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func aplTab(_ sender: UIButton) {
        var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
        if SE_flag {
            vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
        }else{
            vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
        }
        isTap = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func moreTab(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)
    }
    
    func cmtOnList() {
        
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(팀, 상위팀-직속 출근직원 리스트) ... 페이징 없음 ..총인원수, 연차인원수, 출장인원수, 합류코드 정보 포함
         Return  - 출근직원 리스트
         Parameter
         CMPSID        회사번호(필수)
         TTMSID        상위팀번호(상위팀 직속 조회시 팀번호는 0 또는 안넘김) .. 상위팀, 팀 번호 둘다 0인경우는 팀 미지정(팀소속 없는 직원들.. 팀이 없는경우)
         TEMSID        팀번호(팀 조회시 상위팀번호는 0 또는 안넘김)
         */
        
        print("\n---------- [ ttmsid  : \(ttmsid) , temsid : \(temsid) ] ----------\n")
        cmtTuple.removeAll()
        NetworkManager.shared().cmtOnEmpListRx(cmpsid: cmpsid, ttmsid: ttmsid, temsid: temsid)
            .subscribe(onNext: { (isSuccess, empcnt, anualcnt, applycnt, resjoincode, resData) in
                if(isSuccess){
                    guard let serverData = resData else {  return  }
                    self.anualcnt = anualcnt
                    self.applycnt = applycnt
                    self.empcnt = empcnt
                    self.joincode = resjoincode.base64Decoding()
                    self.cmtTuple = serverData
                    self.netflag = true
                }
            }, onError: { (err) in
                self.customAlertView("다시 시도해 주세요.")
            }, onCompleted: {
                self.cmtFlag = true
                self.tblList.reloadData()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }).disposed(by: disposeBag)
        
    }
    
    func cmtOffList() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(팀, 상위팀-직속 미출근직원 리스트) ... 페이징 없음
         Return  - 미출근직원 리스트
         Parameter
         CMPSID        회사번호(필수)
         TTMSID        상위팀번호(상위팀 직속 조회시 팀번호는 0 또는 안넘김) .. 상위팀, 팀 번호 둘다 0인경우는 팀 미지정(팀소속 없는 직원들.. 팀이 없는경우)
         TEMSID        팀번호(팀 조회시 상위팀번호는 0 또는 안넘김)
         */
        cmtTuple.removeAll()
        print("cmpsid = ", cmpsid, ", ttmsid = ", ttmsid, " temsid = ", temsid)
        NetworkManager.shared().cmtOffEmpListRx(cmpsid: cmpsid, ttmsid: ttmsid, temsid: temsid)
            .subscribe(onNext: { (isSuccess, resData) in
                if(isSuccess){
                    guard let serverData = resData else { return }
                    self.cmtTuple = serverData
                    
                }
            }, onError: { (error) in
                self.customAlertView("다시 시도해 주세요.")
            }, onCompleted: {
                self.cmtFlag = false
                self.tblList.reloadData()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }).disposed(by: disposeBag)
    }
    @IBAction func codeCopy(_ sender: UIButton) {
        UIPasteboard.general.string = joincode
        self.customAlertView("합류 코드를 복사 했습니다.\n 코드를 직원에게 공지하세요.")
    }
    @IBAction func selTem(_ sender: UIButton) {
        let vc = CmpCmtSB.instantiateViewController(withIdentifier: "CmtEmpListPopUp") as! CmtEmpListPopUp
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onShow(_ sender: UIButton) {
        cmtOnList()
        clickFlag = true
    }
    @IBAction func offShow(_ sender: UIButton) {
        cmtOffList()
        clickFlag = false
    }
}
extension CmtEmpList: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblList {
            print("cmtOnTuple.count = ", cmtTuple.count)
            if cmtTuple.count > 0 {
                return cmtTuple.count + 1
            }
            return 2
            
        }else {
            print("teamTuple.count = ", teamTuple.count)
            
            return teamTuple.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 0 {
            return 240
        }else {
            return 90
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblList {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CmtListHD") as! CmtListHD
                if clickFlag {
                    cell.btnWork.isSelected = true
                    cell.btnNotWork.isSelected = false
                    
                    cell.lblWork.textColor = .init(hexString: "#000000")
                    cell.lblNotWork.textColor = .init(hexString: "#CBCBD3")
                }
                print("\n---------- [ tname : \(tname) ] ----------\n")
                cell.lblTname.text = tname
                cell.lblTotalCnt.text = String(empcnt)
                cell.lblAnlCnt.text = String(anualcnt)
                cell.lblAprCnt.text = String(applycnt)
                cell.lblCode.text = String(joincode)
                
                return cell
            }else {
                if cmtTuple.count == 0 {
                    print("인원없음")
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CmtListCell") as! CmtListCell
                    cell.vwCmtEmp.isHidden = false
                    cell.vwCmtOn.isHidden = true
                    if netflag {
                        if cmtFlag {
                            cell.lblCmtEmp.text = "출근 직원이 없습니다."
                        }else {
                            cell.lblCmtEmp.text = "미출근 직원이 없습니다."
                        }
                    }
                    
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CmtListCell") as! CmtListCell
                    cell.vwCmtEmp.isHidden = true
                    cell.vwCmtOn.isHidden = false
                    let CmtIndexPath = cmtTuple[indexPath.row - 1]
                    let enddt = CmtIndexPath.enddt
                    let enname = CmtIndexPath.enname
                    let name = CmtIndexPath.name
                    let profimg = CmtIndexPath.profimg
                    let spot = CmtIndexPath.spot
                    let startdt = CmtIndexPath.startdt
                    let type = CmtIndexPath.type
                    let aprtype = CmtIndexPath.aprtype
                     
                    if type == 8 {
                        // 연차일때
                        //0.연차 1.오전 2.오후 3.조퇴 4.외출 5.병가 6.공가 7.경조 8.교육 9.포상 10.공민 11.생리
                        cell.lblType.text  = AnualTypeArray[aprtype]
                        cell.lblType.textColor  = AnualColorArray[aprtype]
                        cell.imgState.image = AnualImgArray[aprtype]
                    }else{
                        //근무타입(0.데이터 없음 1.정상출근 2.지각 3.조퇴 4.야근 5.휴일근로 6.출장 7.외출 8.연차 9.결근)
                        cell.lblType.text = CmtTypeArray[type]
                        cell.lblType.textColor = CmtColorArray[type]
                        cell.imgState.image = CmtImgArray[type]
                    }
                    
                    cell.vwCmtEmp.isHidden = true 
                    let defaultProfimg = UIImage(named: "logo_pre")
                    if profimg.urlTrim() != "img_photo_default.png" {
                        cell.imgProfile.setImage(with: profimg)
                    }else{
                        cell.imgProfile.image = defaultProfimg
                    }
                     
                    
                    if enname == "" {
                        cell.lblName.text = name
                    }else {
                        cell.lblName.text = name + " (" + enname + ") "
                    }
                    
                    var timeStr = ""
                    if startdt != "00:00" {
                        timeStr = startdt + " ~ "
                    }
                    if enddt != "00:00" {
                        timeStr += enddt
                    }
                    cell.lblStartTime.text = timeStr
                    cell.lblSpot.text = spot
                    cell.btnSetting.tag = indexPath.row
                    cell.btnSetting.addTarget(self, action: #selector(self.cmtList(_:)), for: .touchUpInside)
                    
                    return cell
                }
            }
        }else {
            print(teamTuple)
            if teamTuple[indexPath.row].0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CmtPopUpTTMCell") as!  CmtPopUpTTMCell
                let name = teamTuple[indexPath.row].1
                
                cell.lblName.text = name
                cell.btnSetting.tag = indexPath.row
                cell.btnSetting.addTarget(self, action: #selector(self.setting(_:)), for: .touchUpInside)
                
                if teamTuple[indexPath.row].1 != "상위팀 미지정" {
                    cell.btnSetting.isEnabled = true
                }else {
                    cell.btnSetting.isEnabled = false
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CmtPopUpTemCell", for: indexPath) as! CmtPopUpTemCell
                let temname = teamTuple[indexPath.row].1
                
                cell.lblName.text = temname
                cell.btnSetting.tag = indexPath.row
                cell.btnSetting.addTarget(self, action: #selector(self.setting(_:)), for: .touchUpInside)
                
                return cell
            }
        }
    }
    
    @objc func cmtList(_ sender: UIButton) {
        var vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpCmtList") as! EmpCmtList
        if SE_flag {
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_EmpCmtList") as! EmpCmtList
        }else{
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpCmtList") as! EmpCmtList
        }
        let selCmtInfo = cmtTuple[sender.tag - 1]
        vc.selauthor = selCmtInfo.author
        vc.selempsid = selCmtInfo.empsid
        vc.selenddt = selCmtInfo.enddt
        vc.selenname = selCmtInfo.enname
        vc.selmbrsid = selCmtInfo.mbrsid
        vc.selmemo = selCmtInfo.memo
        vc.selname = selCmtInfo.name
        vc.selphone = selCmtInfo.phone
        vc.selphonenum = selCmtInfo.phonenum
        vc.selprofimg = selCmtInfo.profimg
        vc.selspot = selCmtInfo.spot
        vc.selstartdt = selCmtInfo.startdt
        vc.seltype = selCmtInfo.type
        vc.selworkmin = selCmtInfo.workmin
        
        SelEmpInfo.name = selCmtInfo.name
        SelEmpInfo.enname = selCmtInfo.enname
        SelEmpInfo.author = selCmtInfo.author
        SelEmpInfo.mbrsid = selCmtInfo.mbrsid
        SelEmpInfo.sid = selCmtInfo.empsid
        
        print("\n---------- [ empsid : \(SelEmpInfo.sid) , mbrsid : \(SelEmpInfo.mbrsid)] ----------\n")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
    print("\n---------- [ userInfo.author : \(userInfo.author) ] ----------\n")
        // 2020.04.24 해당 팀 관리자만 직원 정보내역 수정 가능하도록 권한 설정 
        switch userInfo.author{
        case 3:
            // 상위팀 관리자
            if(userInfo.ttmsid == selCmtInfo.ttmsid){
                self.present(vc, animated: true, completion: nil)
            }else if(userInfo.temsid == selCmtInfo.temsid){
                self.toast("해당 팀 관리자가 아닙니다.")
            }
        case 4:
            //하위팀 관리자
            if(userInfo.temsid == selCmtInfo.temsid){
                self.present(vc, animated: true, completion: nil)
            }else{
                self.toast("해당 팀 관리자가 아닙니다.")
            }
        default:
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    @objc func setting(_ sender: UIButton) {
        clickFlag = true
        
        
        let temflag = teamTuple[sender.tag].0
        let temname = teamTuple[sender.tag].1
        let temsid = teamTuple[sender.tag].2
         
        print("cmpsid = ", cmpsid, ", ttmsid = ", ttmsid, " temsid = ", temsid)
        if temflag {
            self.ttmsid = temsid
            self.temsid = 0
        }else {
            self.ttmsid = 0
            self.temsid = temsid
        }
        prefs.setValue(self.ttmsid, forKey: "cmt_ttmsid")
        prefs.setValue(self.temsid, forKey: "cmt_temsid")
         
        tname = temname
        cmtOnList()
        
    }
    
}
