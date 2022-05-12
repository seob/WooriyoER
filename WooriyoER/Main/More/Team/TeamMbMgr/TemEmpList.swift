//
//  CmtEmpList.swift
//  PinPle
//
//  Created by WRY_010 on 10/10/2019.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class TemEmpList: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    
    
    let urlClass = UrlClass()
    let jsonClass = JsonClass()
    let httpRequest = HTTPRequest()
    
    var anualcnt = 0
    var applycnt = 0
    var empcnt = 0
    var joincode = ""
    
    var tuple: [EmplyInfo] = []
    var netflag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.delegate = self
        tblList.dataSource = self
        
        tblList.rowHeight = UITableView.automaticDimension
        tblList.separatorStyle = .none
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        valueSetting()
        tblList.contentOffset = CGPoint(x: 0, y: 0)
        viewflag = "TemEmpList"
    }
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        let vc = MoreSB.instantiateViewController(withIdentifier: "MTTListVC") as! MTTListVC
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
//        NotificationCenter.default.post(name: .reloadTem, object: nil)
//        self.dismiss(animated: true, completion: nil)
    }
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(팀원 전체 리스트 - 관리자포함)
         Return  - 팀원 전체 리스트(관리자 포함) .. 페이징 없음 .. Sorting 관리자 권한 순, 이름 가나다 순
         Parameter
         TTMSID(TEMSID)        상위팀번호(팀번호)
         */
        NetworkManager.shared().TemEmpAlllist(temflag: SelTemFlag, cmpsid: userInfo.cmpsid, ttmsid: SelTtmSid, temsid: SelTemSid) { (isSuccess, resData, anualcnt, applycnt, empcnt, joincode) in
            if (isSuccess) {
                guard let serverData = resData else { return }
                self.tuple = serverData
                self.anualcnt = anualcnt
                self.applycnt = applycnt
                self.empcnt = empcnt
                self.joincode = joincode.base64Decoding()
                self.netflag = true
                self.tblList.reloadData()
                print("\n----------------[tuple = \(self.tuple)]---------------------\n")
            }else {
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
    //author, enname, mbrsid, name, profimg, sid, spot
    @IBAction func codeCopy(_ sender: UIButton) {
        UIPasteboard.general.string = joincode
        //        let alert = UIAlertController(title: "알림", message: "합류 코드를 복사 했습니다.\n 코드를 직원에게 공지하세요.", preferredStyle: UIAlertController.Style.alert)
        //        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
        //        alert.addAction(okAction)
        //        self.present(alert, animated: false, completion: nil)
        self.customAlertView("합류 코드를 복사 했습니다.\n 코드를 직원에게 공지하세요.")
    }
    
}
extension TemEmpList: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tuple.count > 0 {
            return tuple.count + 1
        }else {
            return 2
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 246
        }else {
            return 90
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TemEmpListHD") as! TemEmpListHD
            cell.lblTname.text = SelTemInfo.name
            cell.lblTotalCnt.text = "\(empcnt)"
            cell.lblAnlCnt.text = "\(anualcnt)"
            cell.lblAprCnt.text = "\(applycnt)"
            cell.lblCode.text = "\(joincode)"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TemEmpListCell") as! TemEmpListCell
            
            if tuple.count > 0 {
                cell.vwNoEmp.isHidden = true
                
                let author = tuple[indexPath.row - 1].author
                let enname = tuple[indexPath.row - 1].enname
                let name = tuple[indexPath.row - 1].name
                let profimg = tuple[indexPath.row - 1].profimg
                let spot = tuple[indexPath.row - 1].spot
                
                if spot == "" {
                    cell.leadingConstraints.constant = -5
                }
                
                //직원권한(1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.팀관리자  5.직원).. 관리자 구분
                var authorImg = UIImage()
                switch author {
                case  0 :
                    authorImg = UIImage.init(named: "master_puple")!
                case 1:
                    authorImg = UIImage.init(named: "master_red")!;
                case 2:
                    authorImg = UIImage.init(named: "master_blue")!;
                case 3, 4:
                    authorImg = UIImage.init(named: "master_green")!;
                default:
                    break;
                }
                
                if profimg.urlTrim() != "img_photo_default.png" {
                    cell.imgProfile.setImage(with: profimg)
                }else {
                    cell.imgProfile.image = UIImage.init(named: "logo_pre")
                }
                
                cell.imgAuth.image = authorImg
                
                cell.lblName.text = name
                if enname == "" {
                    cell.lblEname.text = ""
                }else {
                    cell.lblEname.text = " (" + enname + ") "
                }
                
                cell.lblSpot.text = spot
                cell.btnSetting.tag = indexPath.row - 1
                cell.btnSetting.addTarget(self, action: #selector(self.cmtList(_:)), for: .touchUpInside)
            }else {
                if netflag {
                    cell.vwNoEmp.isHidden = false
                }
            }
            
            return cell
        }
    }
    
    @objc func cmtList(_ sender: UIButton) {
        var vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpCmtList") as! EmpCmtList
        if SE_flag {
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "SE_EmpCmtList") as! EmpCmtList
        }else{
            vc = CmpCmtSB.instantiateViewController(withIdentifier: "EmpCmtList") as! EmpCmtList
        }
        SelEmpInfo = self.tuple[sender.tag]

        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}
