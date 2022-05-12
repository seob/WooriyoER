//
//  SetCmtVC.swift
//  PinPle
//
//  Created by WRY_010 on 25/09/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork

class SetCmtVC: UIViewController , CLLocationManagerDelegate{
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var swWifi: UISwitch!
    @IBOutlet weak var swGPS: UISwitch!
    @IBOutlet weak var swBcon: UISwitch!
    @IBOutlet weak var swNoti: UISwitch!
    @IBOutlet weak var imgCheck1: UIImageView!
    @IBOutlet weak var imgCheck2: UIImageView!
    @IBOutlet weak var imgCheck3: UIImageView!
    @IBOutlet weak var lblName1: UILabel!
    @IBOutlet weak var lblName2: UILabel!
    @IBOutlet weak var lblName3: UILabel!
    @IBOutlet weak var imgState1: UIImageView!
    @IBOutlet weak var imgState2: UIImageView!
    @IBOutlet weak var imgState3: UIImageView!
    @IBOutlet weak var vwWifi: UIView!
    @IBOutlet weak var vwGPS: UIView!
    @IBOutlet weak var vwBcon: UIView!
    @IBOutlet weak var heightWifi: NSLayoutConstraint!
    @IBOutlet weak var heightGPS: NSLayoutConstraint!
    @IBOutlet weak var heightBcon: NSLayoutConstraint!
    @IBOutlet weak var vwAuthor: UIView!
    @IBOutlet weak var multicmtareaText: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var tblListHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var multiHeaderView: UIView!
    @IBOutlet weak var multiHeaderOnView: UIView!
    @IBOutlet weak var lblMultiendDate: UILabel!
    @IBOutlet weak var btnMultiextension: UIButton! //연장 버튼
    
    @IBOutlet weak var vwGpsArea: UIView!
    @IBOutlet weak var vwWifiArea: UIView!
    @IBOutlet weak var vwBeaconArea: UIView!
    
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    var locationManager = CLLocationManager()
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    let onIcon = UIImage.init(named: "icon_on_wifi")
    let offIcon = UIImage.init(named: "icon_off_wifi")
    let noneIcon = UIImage.init(named: "icon_none_wifi")
    
    let onWifiImg = UIImage.init(named: "icon_wifi_on")
    let offWifiImg = UIImage.init(named: "icon_wifi_off")
    let noneWifiImg = UIImage.init(named: "icon_wifi_none")
    
    let onGPSImg = UIImage.init(named: "icon_gps_on")
    let offGPSImg = UIImage.init(named: "icon_gps_off")
    let noneGPSImg = UIImage.init(named: "icon_gps_none")
    
    let onBconImg = UIImage.init(named: "icon_beacon_on")
    let offBconImg = UIImage.init(named: "icon_beacon_off")
    let noneBconImg = UIImage.init(named: "icon_beacon_none")
    
    var cmpsid: Int = 0          //화사번호... 0인경우 해당회사 없음
    var cmpnm: String = ""          //화사명
    
    var cmtarea: Int = 0         //출퇴근영역(0.설정안함 1.WiFi 2.Gps 3.Beacon)
    var cmtnoti: Int = 0         //출퇴근 전 알림설정(0.사용하지않음 1.사용함)
    
    var wifinm: String = ""         //무선랜 이름
    var wifimac: String = ""        //무선랜 맥주소
    var wifiip: String = ""         //무선랜 IP
    var loclat: String = ""         //위도
    var loclong: String = ""        //경도
    var locaddr: String = ""        //좌표 주소
    var beacon: String = ""         //비콘 UDID
    var nowmac: String = ""         //접속 무선랜 이름
    var nownm: String = ""          //접속 무선랜 맥주소
    var nowip: String = ""          //접속 무선랜 IP
    
    // 2020.04.07 seob
    var tmpcmtarea: Int = 0         //출퇴근영역(0.설정안함 1.WiFi 2.Gps 3.Beacon)
    var tmpcmtnoti: Int = 0         //출퇴근 전 알림설정(0.사용하지않음 1.사용함)
    
    var tmpwifinm: String = ""         //무선랜 이름
    var tmpwifimac: String = ""         //무선랜 mac이름
    var tmpwifiip: String = ""         //무선랜 IP
    var tmpbeacon: String = ""         //비콘 UDID
    var tmpnowip: String = ""          //접속 무선랜 IP
    
    let appDelegate : AppDelegate = AppDelegate().shardInstance() // seob
    var gpsStatus:Int = 0
    var cmtareaList : [Addcmtarea] = []
    
    var nSeq: Int = 0
    var height: CGFloat = 800
    
    let btnAdd: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icon_plus2"), for: .normal)
        return button
    }()
    
    let lblAddText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hexString: "#606060")
        label.backgroundColor = .clear
        label.font = UIFont(name: "NotoSansCJKkr-DemiLight", size: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "출퇴근 영역 추가"
        return label
    }()
    
    let toggleWifi = ToggleSwitch(with: images)
    let toggleGPS = ToggleSwitch(with: images)
    let toggleBeacon = ToggleSwitch(with: images)
    let toggleMulti = ToggleSwitch(with: images)
    var locscope: String = ""
    var switchXposition:CGFloat = 0
    var switchYposition:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.layer.cornerRadius = 6
        if !authorCk(msg: "권한이 없습니다.\n마스터관리자와 최고관리자만 \n변경이 가능합니다.") {
            vwAuthor.isHidden = false
        }
        setUi()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name: .reloadList, object: nil)
        print("\n---------- [ aaa : \(view.bounds.width ) ] ----------\n")
        if view.bounds.width == 414 {
            switchYposition = 340
        }else if view.bounds.width == 375 {
            switchYposition = 300
        }else if view.bounds.width == 390 {
            // iphone 12 pro
            switchYposition = 310
        }else if view.bounds.width == 320 {
            // iphone 12 pro
            switchYposition = 240
        }else{
            switchYposition = 340
        }
        
        toggleWifi.frame.origin.x = switchYposition
        toggleWifi.frame.origin.y = 0
        
        toggleGPS.frame.origin.x = switchYposition
        toggleGPS.frame.origin.y = 0
        
        toggleBeacon.frame.origin.x = switchYposition
        toggleBeacon.frame.origin.y = 0
        
        toggleMulti.frame.origin.x = switchYposition
        toggleMulti.frame.origin.y = 0
        
        self.vwWifiArea.addSubview(toggleWifi)
        self.vwGpsArea.addSubview(toggleGPS)
        self.vwBeaconArea.addSubview(toggleBeacon)
        self.multiHeaderView.addSubview(toggleMulti)
        
        toggleWifi.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
        toggleGPS.addTarget(self, action: #selector(toggleGpsChange), for: .valueChanged)
        toggleBeacon.addTarget(self, action: #selector(toggleBeaconChange), for: .valueChanged)
        toggleMulti.addTarget(self, action: #selector(toggleMultiChange), for: .valueChanged)
        
    }
    
    
    
    // MARK: reloadTableData
    @objc func reloadTableData(_ notification: Notification) {
        CmpinfoUpdate()
    }
    
    fileprivate func setUi(){
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        tblList.backgroundColor = .clear
        tblList.register(UINib.init(nibName: "MulticmtTableViewCell", bundle: nil), forCellReuseIdentifier: "MulticmtTableViewCell")
        
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        tblList.tableFooterView = footerView
        footerView.addSubview(btnAdd)
        footerView.addSubview(lblAddText)
        
        btnAdd.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        btnAdd.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 20.0).isActive = true
        btnAdd.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        lblAddText.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        lblAddText.topAnchor.constraint(equalTo: btnAdd.bottomAnchor, constant: 15.0).isActive = true
        
        btnMultiextension.addTarget(self, action: #selector(checkEextension(_:)), for: .touchUpInside)
        
        addToolBar(textFields: [distanceTextField])
        print("\n---------- [ moreCmpInfo.locscope : \(moreCmpInfo.locscope) ] ----------\n")
        switch moreCmpInfo.locscope {
            case 50:
                nSeq = 0
            case 100:
                nSeq = 1
            case 300:
                nSeq = 2
            case 500:
                nSeq = 3
            default:
                nSeq = 1
        }
        createPickerView(item: nSeq, inComponent: 0)
        distanceTextField.textAlignment = .center
        distanceTextField.text = "\(distanceList[nSeq])m"
        
    }
    
    
    func createPickerView(item: Int, inComponent: Int) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        distanceTextField.inputView = pickerView
        pickerView.selectRow(item, inComponent: 0, animated: true)
    }
    
    
    @objc func distanceAction(){
        self.view.endEditing(true)
    }
    
    @objc func checkEextension(_ sender: UIButton) {
        switch moreCmpInfo.freetype {
            case 2,3:
                if moreCmpInfo.freedt >= muticmttodayDate() {
                    print("\n---------- [올프리 , 펀프리 ] ----------\n")
                }else{
                    if ismulticmtarea {
                        let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        viewflag = "multicmtarea"
                        vc.checkEextension = 1
                        self.present(vc, animated: false, completion: nil)
                    }
                }
            default:
                if ismulticmtarea {
                    let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    viewflag = "multicmtarea"
                    vc.checkEextension = 1
                    self.present(vc, animated: false, completion: nil)
                }
        }
        
    }
    
    func updateLayout(){
        if self.cmtareaList.count == 0 {
            self.tblListHeightConstraint.constant = CGFloat(self.height + 60 + 10)
        }else {
            self.tblListHeightConstraint.constant = CGFloat(self.height) + CGFloat((self.cmtareaList.count) * 60) + 10
        }
        
        self.view.layoutIfNeeded()
    }
    
    fileprivate func tableLayout() {
        valueSetting()
        addcmtareaList()
        if (moreCmpInfo.tmpcmtarea == 99) {
            moreCmpInfo.tmpcmtarea = moreCmpInfo.cmtarea
            tmpcmtarea = moreCmpInfo.tmpcmtarea
            tmpcmtnoti = moreCmpInfo.cmtnoti
            tmpbeacon = moreCmpInfo.beacon
            tmpwifinm = moreCmpInfo.wifinm
            tmpwifiip = moreCmpInfo.wifiip
            tmpwifimac = moreCmpInfo.wifimac
        }
        
        height = multiHeaderView.frame.maxY + 50
        if self.cmtareaList.count == 0 {
            self.tblListHeightConstraint.constant = CGFloat(self.height + 60 + 10)
        }else {
            self.tblListHeightConstraint.constant = CGFloat(self.height) + CGFloat((self.cmtareaList.count) * 60) + 10
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableLayout()
        
    }
    
    func CmpinfoUpdate() {
        NetworkManager.shared().getCmpInfo(cmpsid: userInfo.cmpsid) { (isSuccess, errCode, resData) in
            if(isSuccess){
                if errCode == 99 {
                    self.toast("다시 시도해 주세요.")
                }else{
                    guard let serverData = resData else { return }
                    moreCmpInfo = serverData
                    CompanyInfo = moreCmpInfo
                    self.setUi()
                    self.tableLayout()
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "MainVC" {
            var vc = UIViewController()
            if SE_flag {
                vc = MainSB.instantiateViewController(withIdentifier: "SE_MainVC") as! MainVC
            }else {
                vc = MainSB.instantiateViewController(withIdentifier: "MainVC") as! MainVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    func valueSetting() {
        cmpsid = userInfo.cmpsid
        cmpnm = moreCmpInfo.name.urlEncoding()
        cmtarea = moreCmpInfo.cmtarea
        cmtnoti = moreCmpInfo.cmtnoti
        beacon = moreCmpInfo.beacon
        loclat = moreCmpInfo.loclat
        loclong = moreCmpInfo.loclong
        locaddr = moreCmpInfo.locaddr
        wifimac = moreCmpInfo.wifimac
        wifinm = moreCmpInfo.wifinm
        wifiip = moreCmpInfo.wifiip
        
        print("\n---------- [ cmtarea : \(cmtarea) ] ----------\n")
        switch cmtarea {
            case 0:
                vwWifi.isHidden = true;
                vwGPS.isHidden = true;
                vwBcon.isHidden = true;
                
                swWifi.isOn = false;
                swGPS.isOn = false;
                swBcon.isOn = false;
                
                toggleWifi.setOn(on: false, animated: true)
                toggleGPS.setOn(on: false, animated: true)
                toggleBeacon.setOn(on: false, animated: true)
                heightWifi.constant = 0
                heightGPS.constant = 0
                heightBcon.constant = 0
                
                tblList.isHidden = true
                multiHeaderOnView.isHidden = true
            case 1:
                appDelegate.checkWifi() // 2020.01.15 seob
                wifiSetting();
            case 2:
                GpsSetting()
            case 3:
                beconSetting()
            default:
                break;
        }
        
        if cmtarea > 0 {
            //출퇴근 영역 복수 설정 추가 - 2021.02.16 seob
            if checkmultiarea() {
                print("\n---------- [ 1 ] ----------\n")
                ismulticmtarea = false
                multicmtareaText.isHidden = false
                tblList.isHidden = true
                multiHeaderOnView.isHidden = true
                multiHeaderView.isHidden = false
            }else{
                ismulticmtarea = true
                print("\n---------- [ 2 ] ----------\n")
                //프리요금제(0.사용안함, 1.핀프리 2.펀프리 3.올프리)(2021-01-29 추가)
                switch moreCmpInfo.freetype {
                    case 2,3 :
                        // 펀프리 , 올프리
                        if moreCmpInfo.freedt >= muticmttodayDate() {
                            multicmtareaText.isHidden = true
                            tblList.isHidden = false
                            multiHeaderOnView.isHidden = false
                            multiHeaderView.isHidden = true
                            btnMultiextension.setTitle("FREE", for: .normal)
                            lblMultiendDate.text = ""
                        }else{
                            multicmtareaText.isHidden = true
                            tblList.isHidden = false
                            multiHeaderOnView.isHidden = false
                            multiHeaderView.isHidden = true
                            let orimulti = setJoinDate2(timeStamp: CompanyInfo.multicmtarea)
                            let str = orimulti.replacingOccurrences(of: "-", with: ".")
                            let start = str.index(str.startIndex, offsetBy: 2)
                            let end = str.index(before: str.endIndex)
                            let multiDate = str[start...end]
                            lblMultiendDate.text = "종료일 \(multiDate)"
                        }
                        
                    default:
                        multicmtareaText.isHidden = true
                        tblList.isHidden = false
                        multiHeaderOnView.isHidden = false
                        multiHeaderView.isHidden = true
                        let orimulti = setJoinDate2(timeStamp: CompanyInfo.multicmtarea)
                        let str = orimulti.replacingOccurrences(of: "-", with: ".")
                        let start = str.index(str.startIndex, offsetBy: 2)
                        let end = str.index(before: str.endIndex)
                        let multiDate = str[start...end]
                        lblMultiendDate.text = "종료일 \(multiDate)"
                }
                
            }
        }else{
            print("\n---------- [ 3 ] ----------\n")
            multicmtareaText.isHidden = true
            tblList.isHidden = true
            multiHeaderOnView.isHidden = true
            multiHeaderView.isHidden = true
        }
        
        
        statusMulticmtarea()
    }
    
    func checkmultiarea() -> Bool {
        switch moreCmpInfo.freetype {
            case 2,3:
                // 올프리 , 펀프리
                if moreCmpInfo.freedt >= muticmttodayDate() {
                    return false
                }else{
                    if moreCmpInfo.multicmtarea >= muticmttodayDate() {
                        return false
                    }else{
                        return true
                    }
                }
            default:
                //핀프리 , 사용안함
                if moreCmpInfo.multicmtarea >= muticmttodayDate() {
                    return false
                }else{
                    return true
                }
        }
    }
    
    func statusMulticmtarea(){
        if ismulticmtarea {
            swNoti.isOn = true
        }else{
            swNoti.isOn = false
        }
    }
    
    func addcmtareaList(){
        NetworkManager.shared().addcmtareaList(cmpsid: CompanyInfo.sid, ttmsid: 0, temsid: 0) { (isSuccess, resData) in
            if(isSuccess){
                guard let serverData = resData else { return }
                if serverData.count > 0 {
                    self.cmtareaList = serverData
                    self.tblList.reloadData()
                    self.updateLayout()
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    //MARK: @IBActon
    @IBAction func setMultiarea(_ sender: UISwitch) {
        statusMulticmtarea()
        if ismulticmtarea {
            if sender.isOn {
                toast("유효일자(\(moreCmpInfo.multicmtarea))이후 자동으로 비활성화 됩니다.")
                return
            }
        }else{
            let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            viewflag = "multicmtarea"
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    
    
    
    
    func updateSetting() {
        var area = 0
        let wnm = wifinm.urlEncoding()
        let wmac = wifimac.base64Encoding()
        let wip = wifiip.base64Encoding()
        let bcon = beacon.base64Encoding()
        let lat = loclat.base64Encoding()
        let long = loclong.base64Encoding()
        let addr = locaddr.urlBase64Encoding()
        let scope = distanceTextField.text ?? "\(distanceList[1])"
        if toggleWifi.isOn {
            area = 1
        }else if toggleGPS.isOn {
            area = 2
        }else if toggleBeacon.isOn {
            area = 3
        }else {
            area = 0
        }
        
        switch scope {
            case "50m":
                nSeq = 0
            case "100m":
                nSeq = 1
            case "300m":
                nSeq = 2
            case "500m":
                nSeq = 3
            default:
                nSeq = 1
        }
        
        NetworkManager.shared().SetCmpCmtarea(cmpsid: cmpsid, cmpnm: cmpnm, area: area, wnm: wnm, wmac: wmac, wip: wip, bcon: bcon, lat: lat, long: long, addr: addr , scope: distanceList[nSeq]) { (isSuccess, resCode) in
            if (isSuccess){
                if resCode == 1 {
                    print("\n---------- [ setnoti :\(self.cmtnoti) ] ----------\n")
                    //                        self.setCmtNoti()
                    let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false, completion: nil)
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    // 출퇴근 전 알림설정 저장
    func setCmtNoti(){
        NetworkManager.shared().SetCmpNoti(cmpsid: cmpsid, cmtnoti: cmtnoti) { (isSuccess, resCode) in
            if(isSuccess){
                switch resCode {
                    case -1:
                        self.toast("회사 근로시간을 활성화 해주세요.")
                    case 0 :
                        self.toast("다시 시도해 주세요.")
                    default:
                        break
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    
    func switchCheck() {
        if toggleWifi.isOn {
            moreCmpInfo.cmtarea = 1
            cmtarea = 1
        }else if toggleGPS.isOn {
            moreCmpInfo.cmtarea = 2
            cmtarea = 2
        }else if toggleBeacon.isOn {
            moreCmpInfo.cmtarea = 3
            cmtarea = 3
        }else {
            moreCmpInfo.cmtarea = 0
            cmtarea = 0
        }
        
        if cmtarea > 0 {
            //출퇴근 영역 복수 설정 추가 - 2021.02.16 seob
            if checkmultiarea() {
                ismulticmtarea = false
                multicmtareaText.isHidden = false
                tblList.isHidden = true
                multiHeaderOnView.isHidden = true
                multiHeaderView.isHidden = false
            }else{
                ismulticmtarea = true
                
                if cmtarea  > 0 {
                    tblList.isHidden = false
                }else{
                    multicmtareaText.isHidden = true
                }
                
                switch moreCmpInfo.freetype {
                    case 2,3 :
                        // 펀프리 , 올프리
                        if moreCmpInfo.freedt >= muticmttodayDate() {
                            multicmtareaText.isHidden = true
                            tblList.isHidden = false
                            multiHeaderOnView.isHidden = false
                            multiHeaderView.isHidden = true
                            btnMultiextension.setTitle("FREE", for: .normal)
                            lblMultiendDate.text = ""
                        }else{
                            multicmtareaText.isHidden = true
                            tblList.isHidden = false
                            multiHeaderOnView.isHidden = false
                            multiHeaderView.isHidden = true
                            let orimulti = setJoinDate2(timeStamp: CompanyInfo.multicmtarea)
                            let str = orimulti.replacingOccurrences(of: "-", with: ".")
                            let start = str.index(str.startIndex, offsetBy: 2)
                            let end = str.index(before: str.endIndex)
                            let multiDate = str[start...end]
                            lblMultiendDate.text = "종료일 \(multiDate)"
                        }
                        
                    default:
                        multicmtareaText.isHidden = true
                        tblList.isHidden = false
                        multiHeaderOnView.isHidden = false
                        multiHeaderView.isHidden = true
                        let orimulti = setJoinDate2(timeStamp: CompanyInfo.multicmtarea)
                        let str = orimulti.replacingOccurrences(of: "-", with: ".")
                        let start = str.index(str.startIndex, offsetBy: 2)
                        let end = str.index(before: str.endIndex)
                        let multiDate = str[start...end]
                        lblMultiendDate.text = "종료일 \(multiDate)"
                }
            }
        }else{
            multicmtareaText.isHidden = true
            tblList.isHidden = true
            multiHeaderOnView.isHidden = true
            multiHeaderView.isHidden = true
        }
        
    }
    
    @IBAction func udtWifi(_ sender: UIButton) {
        if locationCheck() {
            let wifiConnet = WifiNetwork().connecteToNetwork()
            let _ = checkWifi()
            
            if let nowWifiName = GlobalShareManager.shared().getLocalData("appNowWifiNm") as? String , let nowWifiMac = GlobalShareManager.shared().getLocalData("appBSSID") as? String , let nowWifiIP = GlobalShareManager.shared().getLocalData("appIp") as? String {
                if nowWifiName != "" { nownm = nowWifiName }
                if nowWifiMac != "" { nowmac = nowWifiMac }
                if nowWifiIP != "" { nowip = nowWifiIP }
                
                if  nowip == wifiip && wifimac == nowmac {
                    if let locationStatus = GlobalShareManager.shared().getLocalData("LocationStatus") as? String {
                        switch locationStatus {
                            case "denied":
                                statusDeniedAlert()
                            case "restricted" :
                                statusDeniedAlert()
                            default:
                                if let url = URL(string: "App-Prefs:root") {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                        }
                    }
                    
                }else {
                    let alert = UIAlertController(title: "현재 기기에 설정된\n '\(nownm)'로\n 변경 하시겠습니까?", message: "(아닐 시, Wi-Fi재설정 후 시도해 주세요.)", preferredStyle: UIAlertController.Style.alert)
                    let cancleAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
                    let okAction = UIAlertAction(title: "변경", style: .default, handler: {action in self.wifiUpdateSetting() })
                    
                    alert.addAction(cancleAction)
                    alert.addAction(okAction)
                    self.present(alert, animated: false, completion: nil)
                }
                
            }else {
                if let url = URL(string: "App-Prefs:root") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        
    }
    @IBAction func udtGPS(_ sender: UIButton) {
        if locationCheck() {
            let vc = MoreSB.instantiateViewController(withIdentifier: "GoogleMapVC") as! GoogleMapVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
            
        }
        
    }
    
    @IBAction func udtBcon(_ sender: UIButton) {
        customAlertView("비콘 등록은 안드로이드에서만 가능합니다.\n 아이폰에서는 개인보안상 비콘을 등록할 수 없습니다.")
    }
    

    
    func valueCheck() -> Bool {
        if toggleWifi.isOn && wifinm == "" && wifimac == ""{
            self.customAlertView("Wi-Fi를 등록해주세요.")
            return false
        }else if toggleGPS.isOn && locaddr == "" {
            self.customAlertView("GPS를 등록해주세요.")
            return false
        }
        return true
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        if valueCheck() {
            if gpsCheck() {
                print("\n---------- [ 변경 있음 ] ----------\n")
                updateSetting()
            }else{
                print("\n---------- [ 변경 없음 ] ----------\n")
                let vc = MoreSB.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)
            }
            
        }
        
    }
    
    func gpsCheck() -> Bool{
        if (cmtarea == tmpcmtarea &&  wifiip == tmpwifiip && wifinm == tmpwifinm && wifimac == tmpwifimac && beacon == tmpbeacon &&  cmtnoti == tmpcmtnoti && gpsStatus == 0 && distanceList[nSeq] == moreCmpInfo.locscope){
            return false
        }else{
            return true
        }
        
    }
    
    func checkWifi() -> Bool {
        let wifiConnet = WifiNetwork().connecteToNetwork()
        if wifiConnet {
            let wifiInfo = WifiNetwork().getWifiInfo()
            Ipify.getPublicIPAddress { result in
                switch result {
                    case .success(let ip):
                        self.nowip = ip
                        print("nowip = ", self.nowip)
                    case .failure(let error):
                        print(error)
                }
            }
            
            if let tmpnowmac = wifiInfo["BSSID"] as? String{
                nowmac = tmpnowmac
            }
            
            if let tmpnownm = wifiInfo["SSID"] as? String{
                nownm = tmpnownm
            }
            print("\n---------- [ wifiip : \(wifiip) ,nowip : \(nowip)  ] ----------\n")
            if nowmac != "" {
                if (wifimac == nowmac) {
                    print("\n---------- [ wifi 연결 ] ----------\n")
                    return true
                }else if (wifimac != nowmac){
                    if nowip != "" {
                        if (nowip.ipTrim() == wifiip.ipTrim()) {
                            print("\n---------- [ wifi 연결 ] ----------\n")
                            return true
                        }else{
                            print("\n---------- [ wifi 연결 실패] ----------\n")
                            return false
                        }
                    }
                }else{
                    print("\n---------- [ wifi 연결 실패] ----------\n")
                    return false
                }
                return false
            }else if self.nowip != "" {
                if (nowip.ipTrim() == wifiip.ipTrim()) { 
                    print("\n---------- [ wifi 연결 ] ----------\n")
                    return true
                }else{
                    print("\n---------- [ wifi 연결 실패] ----------\n")
                    return false
                }
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func locationCheck()  -> Bool{
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            case .denied:
                print("I'm sorry - I can't show location. User has not authorized it")
                statusDeniedAlert()
            case .restricted:
                statusDeniedAlert()
            default:
                break
        }
        return true
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            case .denied:
                print("I'm sorry - I can't show location. User has not authorized it")
                statusDeniedAlert()
            case .restricted:
                statusDeniedAlert()
            default:
                break
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "네", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func statusDeniedAlert() {
        let alertController = UIAlertController(title: "위치권한 설정이 '안함'으로 되어있습니다.", message: "앱 설정 화면으로 가시겠습니까?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "네", style: .`default`, handler: { action in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
            } else {
                UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
            
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            print("My coordinates are: \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(title: "Location Access Failure", message: "App could not access locations. Loation services may be unavailable or are turned off. Error code: \(error)")
    }
    
} 

// MARK: - UITableViewDelegate ,UITableViewDataSource

extension SetCmtVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cmtareaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MulticmtTableViewCell", for: indexPath) as? MulticmtTableViewCell {
            let cmtareaIndexPath = cmtareaList[indexPath.row]
            cell.selectionStyle = .none
            cell.lblName.text = cmtareaIndexPath.name
            cell.btnSelected.tag = indexPath.row
            cell.btnSelected.addTarget(self, action: #selector(moveTosettingCmtarea(_:)), for: .touchUpInside)
            cell.lblName.textColor = UIColor.init(hexString: "#272727")
            //            cell.cmtSwitch.isOn = cmtareaIndexPath.status == 1 ? true : false
            if cmtareaIndexPath.status == 1 {
                cell.selectedImageView.image = swyOnimg
                cell.cmtSwitch.isSelected = true
            }else{
                cell.selectedImageView.image = swOffimg
                cell.cmtSwitch.isSelected = false
            }
            
            switch cmtareaIndexPath.cmtarea {
                case 1:
                    if cmtareaIndexPath.status == 1 {
                        cell.wifiImageView.image = self.onWifiImg
                    }else{
                        cell.wifiImageView.image = self.noneWifiImg
                    }
                case 2:
                    if cmtareaIndexPath.status == 1 {
                        cell.wifiImageView.image = self.onGPSImg
                    }else{
                        cell.wifiImageView.image = self.noneGPSImg
                    }
                case 3:
                    if cmtareaIndexPath.status == 1 {
                        cell.wifiImageView.image = self.onBconImg
                    }else{
                        cell.wifiImageView.image = self.noneBconImg
                    }
                    
                default:
                    cell.wifiImageView.isHidden = true
                    cell.cmtSwitch.isSelected = false
                    cell.selectedImageView.image = swOffimg
            }
            cell.cmtSwitch.tag = indexPath.row
            cell.cmtSwitch.addTarget(self, action: #selector(actionExerciseSwitch(_:)), for: .touchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
    }
    // MARK: - 복수 출퇴근 영역 switch문 클릭시 상태 변경
    @objc func actionExerciseSwitch(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        var cmtarea = Addcmtarea()
        cmtarea = cmtareaList[sender.tag]
        let status = cmtarea.status == 1 ? 0 : 1
        var nMultiSeq = 0
        if cmtarea.cmtarea > 0 {
            switch cmtarea.locscope {
                case 50:
                    nMultiSeq = 0
                case 100:
                    nMultiSeq = 1
                case 300:
                    nMultiSeq = 2
                case 500:
                    nMultiSeq = 3
                default:
                    nMultiSeq = 1
            }
            
            
            NetworkManager.shared().udt_Cmtarea(acasid: cmtarea.sid, nm: cmtarea.name.urlEncoding(), st: status, area: cmtarea.cmtarea, wnm: cmtarea.wifinm.urlEncoding(), wmac: cmtarea.wifimac.base64Encoding(), wip: cmtarea.wifiip.base64Encoding(), bcon: cmtarea.beacon.base64Encoding(), lat: cmtarea.loclat.base64Encoding(), long: cmtarea.loclong.base64Encoding(), addr: cmtarea.locaddr.urlBase64Encoding(), scope: distanceList[nMultiSeq]) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode > 0 {
                        cmtarea.status = status
                        if let cellObj =  self.tblList.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? MulticmtTableViewCell {
                            switch cmtarea.cmtarea {
                                case 1:
                                    if cmtarea.status == 1 {
                                        cellObj.wifiImageView.image = self.onWifiImg
                                        cellObj.selectedImageView.image = swyOnimg
                                        cellObj.cmtSwitch.isSelected = true
                                    }else{
                                        cellObj.wifiImageView.image = self.noneWifiImg
                                        cellObj.selectedImageView.image = swOffimg
                                        cellObj.cmtSwitch.isSelected = true
                                    }
                                case 2:
                                    if cmtarea.status == 1 {
                                        cellObj.wifiImageView.image = self.onGPSImg
                                        cellObj.selectedImageView.image = swyOnimg
                                        cellObj.cmtSwitch.isSelected = true
                                    }else{
                                        cellObj.wifiImageView.image = self.noneGPSImg
                                        cellObj.selectedImageView.image = swOffimg
                                        cellObj.cmtSwitch.isSelected = false
                                    }
                                case 3:
                                    if cmtarea.status == 1 {
                                        cellObj.wifiImageView.image = self.onBconImg
                                        cellObj.selectedImageView.image = swyOnimg
                                        cellObj.cmtSwitch.isSelected = true
                                    }else{
                                        cellObj.wifiImageView.image = self.noneBconImg
                                        cellObj.selectedImageView.image = swOffimg
                                        cellObj.cmtSwitch.isSelected = false
                                    }
                                default:
                                    cellObj.wifiImageView.isHidden = true
                                    cellObj.cmtSwitch.isSelected = false
                                    cellObj.selectedImageView.image = swOffimg
                            }
                        }
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        }else{
            self.toast("출퇴근 영역 상세정보를 설정해주세요")
        } 
    }
    
    
    // MARK: - 복수 출퇴근 영역 셀 클릭시 이동
    @objc func moveTosettingCmtarea(_ sender: UIButton){
        var cmtarea = Addcmtarea()
        cmtarea = cmtareaList[sender.tag]
        var vc = MoreSB.instantiateViewController(withIdentifier: "SetAddCmtVC") as! SetAddCmtVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_SetAddCmtVC") as! SetAddCmtVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "SetAddCmtVC") as! SetAddCmtVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.cmtareainfo = cmtarea
        
        self.present(vc, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


// MARK: - method
extension SetCmtVC {
    // MARK:  출퇴근 영역 복수 추가
    @objc func fabTapped(_ sender: UIButton){
        var vc = MoreSB.instantiateViewController(withIdentifier: "SetAddCmtVC") as! SetAddCmtVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_SetAddCmtVC") as! SetAddCmtVC
        }else{
            vc = MoreSB.instantiateViewController(withIdentifier: "SetAddCmtVC") as! SetAddCmtVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func toggleMultiChange(toggle: ToggleSwitch){
        statusMulticmtarea()
        if ismulticmtarea {
            if toggle.isOn {
                toast("유효일자(\(moreCmpInfo.multicmtarea))이후 자동으로 비활성화 됩니다.")
                return
            }
        }else{
            toggle.isOn = false
            let vc = MoreSB.instantiateViewController(withIdentifier: "MulticmtPopVC") as! MulticmtPopVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            viewflag = "multicmtarea"
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    // MARK: wifi 출퇴근 영역 체크
    @objc func toggleValueChanged(toggle: ToggleSwitch) {
        if toggle.isOn {
            wifiSetting()
        }else {
            vwWifi.isHidden = true
            heightWifi.constant = 0
        }
        switchCheck()
    }
    
    // MARK: gps 출퇴근 영역 체크
    @objc func toggleGpsChange(toggle: ToggleSwitch){
        if toggle.isOn {
            GpsSetting()
        }else {
            vwGPS.isHidden = true
            heightGPS.constant = 0
        }
        switchCheck()
    }
    
    // MARK: beacon 출퇴근 영역 체크
    @objc func toggleBeaconChange(toggle: ToggleSwitch){
        if toggle.isOn {
            if beacon == "" {
                self.customAlertView("비콘이 등록되어있지 않습니다.\n아이폰은 보안상 비콘을 등록할수 없습니다.\n안드로이드에서 등록해 주세요.")
                toggle.isOn = false
            }else {
                beconSetting()
            }
        }else {
            vwBcon.isHidden = true
            heightBcon.constant = 0
        }
        switchCheck()
    }
    
    
    @IBAction func setWifi(_ sender: UISwitch) {
        if sender.isOn {
            wifiSetting()
        }else {
            vwWifi.isHidden = true
            heightWifi.constant = 0
        }
        switchCheck()
    }
    
    func wifiSetting() {
        vwWifi.isHidden = false
        vwGPS.isHidden = true
        vwBcon.isHidden = true
        
        heightWifi.constant = 40
        heightGPS.constant = 0
        heightBcon.constant = 0
        
        swWifi.isOn = true
        toggleWifi.setOn(on: true, animated: true)
        swGPS.isOn = false
        toggleGPS.setOn(on: false, animated: true)
        swBcon.isOn = false
        toggleBeacon.setOn(on: false, animated: true)
        
        if wifinm == "" {
            lblName1.text = "Wi-Fi를 등록해주세요."
            lblName1.textColor = UIColor.init(hexString: "#606060")
            imgCheck1.image = noneIcon
            imgState1.image = noneWifiImg
        }else {
            lblName1.text = wifinm
            lblName1.textColor = UIColor.init(hexString: "#272727")
            
            if checkWifi() {
                imgCheck1.image = onIcon
                imgState1.image = onWifiImg
            }else {
                imgCheck1.image = offIcon
                imgState1.image = offWifiImg
                lblName1.textColor = UIColor.init(hexString: "#606060")
            }
        }
    }
    @IBAction func setGPS(_ sender: UISwitch) {
        
        if sender.isOn {
            GpsSetting()
        }else {
            vwGPS.isHidden = true
            heightGPS.constant = 0
        }
        switchCheck()
    }
    func GpsSetting() {
        vwWifi.isHidden = true
        vwGPS.isHidden = false
        vwBcon.isHidden = true
        
        swWifi.isOn = false
        toggleWifi.setOn(on: false, animated: true)
        swGPS.isOn = true
        toggleGPS.setOn(on: true, animated: true)
        swBcon.isOn = false
        toggleBeacon.setOn(on: false, animated: true)
        
        heightWifi.constant = 0
        heightGPS.constant = 80
        heightBcon.constant = 0
        
        if locaddr == "" {
            lblName2.text = "GPS를 등록해주세요."
            lblName2.textColor = UIColor.init(hexString: "#606060")
            imgCheck2.image = noneIcon
            imgState2.image = noneGPSImg
        }else {
            lblName2.text = locaddr
            lblName2.textColor = UIColor.init(hexString: "#272727")
            imgCheck2.image = onIcon
            imgState2.image = onGPSImg
        }
    }
    @IBAction func setBecon(_ sender: UISwitch) {
        
        if sender.isOn {
            if beacon == "" {
                self.customAlertView("비콘이 등록되어있지 않습니다.\n아이폰은 보안상 비콘을 등록할수 없습니다.\n안드로이드에서 등록해 주세요.")
                sender.isOn = false
            }else {
                beconSetting()
            }
        }else {
            vwBcon.isHidden = true
            heightBcon.constant = 0
        }
        switchCheck()
    }
    func beconSetting() {
        vwWifi.isHidden = true
        vwGPS.isHidden = true
        vwBcon.isHidden = false
        
        swWifi.isOn = false
        toggleWifi.setOn(on: false, animated: true)
        swGPS.isOn = false
        toggleGPS.setOn(on: false, animated: true)
        swBcon.isOn = true
        toggleBeacon.setOn(on: true, animated: true)
        
        heightWifi.constant = 0
        heightGPS.constant = 0
        heightBcon.constant = 40
        
        if beacon == "" {
            lblName3.text = "비콘을 등록해주세요."
            lblName3.textColor = UIColor.init(hexString: "#606060")
            imgCheck3.image = noneIcon
            imgState3.image = noneBconImg
        }else {
            lblName3.text = beacon
            lblName3.textColor = UIColor.init(hexString: "#272727")
            imgCheck3.image = onIcon
            imgState3.image = onBconImg
        }
    }
    
    func wifiUpdateSetting(){
        wifimac = nowmac
        wifinm = nownm
        wifiip = nowip
        wifiSetting()
    }
}

// MARK: - UIPickerViewDelegate , UIPickerViewDataSource
extension SetCmtVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return distanceList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(distanceList[row])m"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("select=\(row)")
        switch row {
            case 0:
                nSeq = 0
            case 1:
                nSeq = 1
            case 2:
                nSeq = 2
            case 3:
                nSeq = 3
            default:
                nSeq = 1
        }
        distanceTextField.text = "\(distanceList[row])m"
    }
    
}
