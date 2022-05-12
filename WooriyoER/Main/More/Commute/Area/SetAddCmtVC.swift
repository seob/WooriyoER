//
//  SetAddCmtVC.swift
//  PinPle
//
//  Created by seob on 2021/02/17.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork

class SetAddCmtVC: UIViewController {
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var swWifi: UISwitch!
    @IBOutlet weak var swGPS: UISwitch!
    @IBOutlet weak var swBcon: UISwitch!
    
    
    @IBOutlet weak var btnWifi: UIButton!
    @IBOutlet weak var switchImageView1: UIImageView!
    
    @IBOutlet weak var btnGPS: UIButton!
    @IBOutlet weak var switchImageView2: UIImageView!
    
    @IBOutlet weak var btnBeacon: UIButton!
    @IBOutlet weak var switchImageView3: UIImageView!
    
    
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
    
    @IBOutlet weak var TextFieldName: UITextField!
    @IBOutlet weak var checkImage: UIImageView!
    
    @IBOutlet weak var btnSaveView: UIView!
    @IBOutlet weak var btnModifView: UIView!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var btnSmallSave: UIButton!
    @IBOutlet weak var btnLargeSave: UIButton!
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
    var acasid :Int = 0 // 출퇴근영역 번호
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
    var textFields : [UITextField] = []
    var cmtareainfo = Addcmtarea()
    var nSeq: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSmallSave.layer.cornerRadius = 6
        btnLargeSave.layer.cornerRadius = 6
        textFields = [TextFieldName]
        for textfield in textFields {
            textfield.delegate = self
        }
        addToolBar(textFields: textFields)
        
        print("\n---------- [ info  : \(cmtareainfo.toJSON()) ] ----------\n")
        btnWifi.addTarget(self, action: #selector(setWifi(_:)), for: .touchUpInside)
        btnGPS.addTarget(self, action: #selector(setGPS(_:)), for: .touchUpInside)
        btnBeacon.addTarget(self, action: #selector(setBecon(_:)), for: .touchUpInside)
        
        
        addToolBar(textFields: [distanceTextField])
        switch cmtareainfo.locscope {
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

    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.distanceAction))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        distanceTextField.inputAccessoryView = toolBar
    }
    
    @objc func distanceAction(){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        valueSetting()
        TextFieldName.returnKeyType = .done
        TextFieldName.layer.masksToBounds = true
        TextFieldName.layer.cornerRadius = 0
        TextFieldName.layer.borderWidth = 0.0
        TextFieldName.setLeftPaddingPoints(0)
        TextFieldName.placeholder = "출퇴근 영역 명칭을 입력하세요"
        if acasid > 0 {
            btnSaveView.isHidden = true
            btnModifView.isHidden = false
            lblNavigationTitle.text = "복수 출퇴근 영역 상세"
        }else{
            btnSaveView.isHidden = false
            btnModifView.isHidden = true
        }
        
        
    }
    
    @IBAction func barBack(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "SetCmtVC") as! SetCmtVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_SetCmtVC") as! SetCmtVC
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: false, completion: nil)        
    }
    
    
    func valueSetting() {
        
        wifiip = cmtareainfo.wifiip
        wifinm = cmtareainfo.wifinm
        wifimac = cmtareainfo.wifimac
        acasid = cmtareainfo.sid
        cmtnoti = cmtareainfo.status
        cmtarea = cmtareainfo.cmtarea
        loclat = cmtareainfo.loclat
        loclong = cmtareainfo.loclong
        locaddr = cmtareainfo.locaddr
        beacon = cmtareainfo.beacon
        cmpnm = cmtareainfo.name
        
        TextFieldName.text = "\(cmpnm)"
        if cmpnm != "" {
            checkImage.image = chkstatusAlertpass
        }else{
            checkImage.image = chkstatusAlert
        }
         
        switch cmtareainfo.cmtarea {
            case 1:
                btnWifi.isSelected = true
                switchImageView1.image = swyOnimg
            case 2:
                btnGPS.isSelected = true
                switchImageView2.image = swyOnimg
            case 3:
                btnBeacon.isSelected = true
                switchImageView3.image = swyOnimg
            default:
                btnWifi.isSelected = false
                btnGPS.isSelected = false
                btnBeacon.isSelected = false
                switchImageView1.image = swOffimg
                switchImageView2.image = swOffimg
                switchImageView3.image = swOffimg
        }
        
        switch cmtarea {
            case 0:
                vwWifi.isHidden = true
                vwGPS.isHidden = true
                vwBcon.isHidden = true
                
                btnWifi.isSelected = false
                btnGPS.isSelected = false
                btnBeacon.isSelected = false
                
                heightWifi.constant = 0
                heightGPS.constant = 0
                heightBcon.constant = 0
            case 1:
                appDelegate.checkWifi() // 2020.01.15 seob
                wifiSetting();
            case 2:
                GpsSetting()
            case 3:
                beconSetting()
            default:
                
                break
        } 
    }
    
    func wifiSetting() {
        vwWifi.isHidden = false
        vwGPS.isHidden = true
        vwBcon.isHidden = true
        
        
        heightGPS.constant = 0
        heightBcon.constant = 0
        heightWifi.constant = 40
        
        btnGPS.isSelected = false
        btnBeacon.isSelected = false
        btnWifi.isSelected = true
        
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
                imgState1.image = noneWifiImg
                lblName1.textColor = UIColor.init(hexString: "#606060")
            }
        }
    }
    
    func GpsSetting() {
        vwWifi.isHidden = true
        vwGPS.isHidden = false
        vwBcon.isHidden = true
        
        btnWifi.isSelected = false
        btnBeacon.isSelected = false
        btnGPS.isSelected = true
        
        heightWifi.constant = 0
        heightBcon.constant = 0
        heightGPS.constant = 80
        
        print("-------------------[locaddr = \(locaddr) , cmpnm : \(cmpnm)]--------------------")
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
    
    func beconSetting() {
        vwWifi.isHidden = true
        vwGPS.isHidden = true
        vwBcon.isHidden = false
        
        btnWifi.isSelected = false
        btnGPS.isSelected = false
        btnBeacon.isSelected = true
        
        heightBcon.constant = 40
        heightWifi.constant = 0
        heightGPS.constant = 0
 
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
    
    func switchCheck() {
        if btnWifi.isSelected {
            cmtareainfo.cmtarea = 1
            switchImageView1.image = swyOnimg
            cmtarea = 1
        }else if btnGPS.isSelected {
            cmtareainfo.cmtarea = 2
            switchImageView2.image = swyOnimg
            cmtarea = 2
        }else if btnBeacon.isSelected {
            cmtareainfo.cmtarea = 3
            switchImageView3.image = swyOnimg
            cmtarea = 3
        }else {
            cmtareainfo.cmtarea = 0
            cmtarea = 0
            switchImageView1.image = swOffimg
            switchImageView2.image = swOffimg
            switchImageView3.image = swOffimg
        }
    }
    

    @objc func setWifi(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            cmtnoti = 1
            btnWifi.isSelected = true
            switchImageView1.image = swyOnimg
            switchImageView2.image = swOffimg
            switchImageView3.image = swOffimg
            wifiSetting()
        }else {
            cmtnoti = 0
            btnWifi.isSelected = false
            switchImageView1.image = swOffimg
            switchImageView2.image = swOffimg
            switchImageView3.image = swOffimg
            vwWifi.isHidden = true
            heightWifi.constant = 0
        }
        switchCheck()
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
    

    @objc func setGPS(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            cmtnoti = 1
            btnGPS.isSelected = true
            switchImageView2.image = swyOnimg
            switchImageView1.image = swOffimg
            switchImageView3.image = swOffimg
            GpsSetting()
        }else {
            cmtnoti = 0
            btnGPS.isSelected = false
            switchImageView2.image = swOffimg
            switchImageView1.image = swOffimg
            switchImageView3.image = swOffimg
            vwGPS.isHidden = true
            heightGPS.constant = 0
        }
        switchCheck()
    }
    
    
    @IBAction func udtGPS(_ sender: UIButton) {
        if locationCheck() {
            let vc = MoreSB.instantiateViewController(withIdentifier: "GoogleMapVC") as! GoogleMapVC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.viewflag = "setaddcmtvc"
            vc.cmtareainfo = self.cmtareainfo
           
            vc.wifiip = self.wifiip
            vc.wifinm = self.wifinm
            vc.wifimac = self.wifimac
            vc.acasid = self.acasid
            vc.cmtnoti = self.cmtnoti
            vc.cmtarea = self.cmtarea
            vc.loclat = self.loclat
            vc.loclong = self.loclong
            vc.locaddr = self.locaddr
            vc.beacon = self.beacon
            vc.cmpnm = TextFieldName.text ?? ""
            
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
   
    @objc func setBecon(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if beacon == "" {
                self.customAlertView("비콘이 등록되어있지 않습니다.\n아이폰은 보안상 비콘을 등록할수 없습니다.\n안드로이드에서 등록해 주세요.")
                sender.isSelected = false
                cmtnoti = 0
            }else {
                cmtnoti = 1
                beconSetting()
                switchImageView3.image = swyOnimg
                switchImageView1.image = swOffimg
                switchImageView2.image = swOffimg
                btnBeacon.isSelected = true
            }
        }else {
            cmtnoti = 0
            vwBcon.isHidden = true
            switchImageView3.image = swOffimg
            switchImageView1.image = swOffimg
            switchImageView2.image = swOffimg
            btnBeacon.isSelected = false
            heightBcon.constant = 0
        }
        switchCheck()
    }
    
    @IBAction func udtBcon(_ sender: UIButton) {
        customAlertView("비콘 등록은 안드로이드에서만 가능합니다.\n 아이폰에서는 개인보안상 비콘을 등록할 수 없습니다.")
    }
    
    func valueCheck() -> Bool {
        if swWifi.isOn && wifinm == "" && wifimac == ""{
            self.customAlertView("Wi-Fi를 등록해주세요.")
            return false
        }else if swGPS.isOn && locaddr == "" {
            self.customAlertView("GPS를 등록해주세요.")
            return false
        }
        return true
    }
    
    // MARK: - 저장
    @IBAction func saveClick(_ sender: UIButton) {
        let str = TextFieldName.text ?? ""
        var cmtstr = ""
        switch cmtarea {
            case 1:
                if wifinm == "" {
                    cmtstr = ""
                }else{
                    cmtstr = wifinm
                }
            case 2:
                if loclat == "" {
                    cmtstr = ""
                }else{
                    cmtstr = loclat
                }
            case 3:
                if beacon == "" {
                    cmtstr = ""
                }else{
                    cmtstr = beacon
                }
            default:
               print("\n---------- [ default ] ----------\n")
        }
        
         if str == "" {
            toast("출퇴근 영역 명칭을 입력하세요.")
            return
        }else if cmtstr == "" {
            toast("출퇴근 영역 상세정보를 설정해주세요.")
            return
        }else{
            let scope = distanceTextField.text ?? "\(distanceList[1])"
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
            
            NetworkManager.shared().add_Cmtarea(cmpsid: CompanyInfo.sid, ttmsid: 0, temsid: 0, nm: str.urlEncoding(), st:cmtnoti , area: cmtarea, wnm: wifinm.urlEncoding(), wmac: wifimac.base64Encoding(), wip: wifiip.base64Encoding(), bcon: beacon.base64Encoding(), lat: loclat.base64Encoding(), long: loclong.base64Encoding(), addr: cmtareainfo.locaddr.urlBase64Encoding(), scope: distanceList[nSeq]) { (isSuccess, resCode) in
                if(isSuccess){
                    if(resCode > 0){
                        let vc = MoreSB.instantiateViewController(withIdentifier: "SetCmtVC") as! SetCmtVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: false, completion: nil)
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }
        }
        
    }
    
    // MARK: - 삭제
    @IBAction func delClick(_ sender: UIButton) {
        NetworkManager.shared().del_Cmtarea(acasid: acasid) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode > 0 {
                    let vc = MoreSB.instantiateViewController(withIdentifier: "SetCmtVC") as! SetCmtVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    // MARK: - 수정
    @IBAction func modifyClick(_ sender: UIButton){
        let str = TextFieldName.text ?? ""
        var cmtstr = ""
        switch cmtarea {
            case 1:
                if wifinm == "" {
                    cmtstr = ""
                }else{
                    cmtstr = wifinm
                }
            case 2:
                if loclat == "" {
                    cmtstr = ""
                }else{
                    cmtstr = loclat
                }
            case 3:
                if beacon == "" {
                    cmtstr = ""
                }else{
                    cmtstr = beacon
                }
            default:
               print("\n---------- [ default ] ----------\n")
        }
        
        if str == "" {
            toast("출퇴근 영역 명칭을 입력하세요.")
            return
        }else if cmtstr == "" {
            toast("출퇴근 영역 상세정보를 설정해주세요.")
            return
        }else{
            let scope = distanceTextField.text ?? "\(distanceList[1])"
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
            
            NetworkManager.shared().udt_Cmtarea(acasid: acasid, nm: str.urlEncoding(), st:cmtnoti , area: cmtarea, wnm: wifinm.urlEncoding(), wmac: wifimac.base64Encoding(), wip: wifiip.base64Encoding(), bcon: beacon.base64Encoding(), lat: loclat.base64Encoding(), long: loclong.base64Encoding(), addr: locaddr.urlBase64Encoding(), scope: distanceList[nSeq]) { (isSuccess, resCode) in
                if(isSuccess){
                    if resCode > 0 {
                        let vc = MoreSB.instantiateViewController(withIdentifier: "SetCmtVC") as! SetCmtVC
                        vc.modalTransitionStyle = .crossDissolve
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true) {
                            self.toast("수정 되었습니다.")
                        }
                    }else{
                        self.toast("다시 시도해 주세요.")
                    }
                }else{
                    self.toast("다시 시도해 주세요.")
                }
            } 
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
        
        if swWifi.isOn {
            area = 1
        }else if swGPS.isOn {
            area = 2
        }else if swBcon.isOn {
            area = 3
        }else {
            area = 0
        }
        
        let scope = distanceTextField.text ?? "\(distanceList[1])"
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
                    let vc = MoreSB.instantiateViewController(withIdentifier: "SetCmtVC") as! SetCmtVC
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
    
    func gpsCheck() -> Bool{
        if (cmtarea == tmpcmtarea &&  wifiip == tmpwifiip && wifinm == tmpwifinm && wifimac == tmpwifimac && beacon == tmpbeacon &&  cmtnoti == tmpcmtnoti && gpsStatus == 0 && distanceList[nSeq] == cmtareainfo.locscope){
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
            
            if nowmac != "" {
                if (wifimac == nowmac) {
                    return true
                }else if (wifimac != nowmac){
                    if nowip != "" {
                        if (nowip.ipTrim() == wifiip.ipTrim()) {
                            return true
                        }else{
                            return false
                        }
                    }
                }else{
                    return false
                }
                return false
            }else if self.nowip != "" {
                if (nowip.ipTrim() == wifiip.ipTrim()) {
                    return true
                }else{
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

// MARK: - UITextFieldDelegate
extension SetAddCmtVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let str = textField.text ?? ""
        print("\n---------- [ str : \(str) ] ----------\n")
        if textField == TextFieldName {
            if str != "" {
                checkImage.image = chkstatusAlertpass
            }else{
                checkImage.image = chkstatusAlert
            }
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let str = textField.text ?? ""
        if textField == TextFieldName {
            if str != "" {
                checkImage.image = chkstatusAlertpass
            }else{
                checkImage.image = chkstatusAlert
            }
        }
    }
}


// MARK: - UIPickerViewDelegate , UIPickerViewDataSource
extension SetAddCmtVC: UIPickerViewDelegate, UIPickerViewDataSource{
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
