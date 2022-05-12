//
//  MgmtCmpMgrVC.swift
//  PinPle
//
//  Created by WRY_010 on 2019/11/11.
//  Copyright © 2019 WRY_010. All rights reserved.
//

import UIKit

class MgmtCmpMgrVC: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    
    let urlClass = UrlClass()
    let httpRequest = HTTPRequest()
    let jsonClass = JsonClass()
    
    var empTuple: [(Int, String, Int, String, UIImage, Int, String)] = []
    
    var mgrFlag = true
    
    var empsids = ""
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        tblList.rowHeight = UITableView.automaticDimension
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
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
        //IndicatorSetting()
        valueSetting()
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = UIViewController()
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_CmpMgrVC") as! CmpMgrVC
        }else {
            vc = MoreSB.instantiateViewController(withIdentifier: "CmpMgrVC") as! CmpMgrVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func valueSetting() {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(회사 최고관리자 리스트 - 본인제외)
         Return  - 회사 최고관리자 리스트
         Parameter
         CMPSID        회사번호
         EMPSID        직원번호(본인)
         */
        let url = urlClass.cmp_smgrlist(cmpsid: userInfo.cmpsid, empsid: userInfo.empsid)
        if let jsonTemp: Data = jsonClass.weather_request(setUrl: url) {
            if let jsonData: NSDictionary = jsonClass.json_parseData(jsonTemp) {
                print(url)
                print(jsonData)
                empTuple.removeAll()
                let empList = jsonData["emply"] as? NSArray
                if empList!.count > 0 {
                    for i in 0...empList!.count - 1 {
                        var profimg = UIImage(named: "logo_pre")
                        let profimgUrl = (empList![i] as AnyObject).object(forKey: "profimg") as! String
                        if profimgUrl.urlTrim() != "img_photo_default.png" {
                            profimg = self.urlImage(url: profimgUrl)
                        }
                        self.empTuple.append(((empList![i] as AnyObject).object(forKey: "author") as! Int,
                                              (empList![i] as AnyObject).object(forKey: "enname") as! String,
                                              (empList![i] as AnyObject).object(forKey: "mbrsid") as! Int,
                                              (empList![i] as AnyObject).object(forKey: "name") as! String,
                                              profimg!,
                                              (empList![i] as AnyObject).object(forKey: "sid") as! Int,
                                              (empList![i] as AnyObject).object(forKey: "spot") as! String))
                    }
                }
                self.tblList.reloadData()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }
        }else {
            self.customAlertView("다시 시도해 주세요.")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
        }
        tblList.contentSize.height = CGFloat(218 + (90 * (empTuple.count + 1)))
        print("\n---------- [ empTuple = \(empTuple.count) ] ----------\n")
    }
    
    
    
    // FIXME: savePopUp
    @IBAction func savePopUp(_ sender: UIButton) {
        /*
         Pinpl iPhone SmartPhone APP으로부터 요청받은 데이터 처리(직원 권한설정)
         Return  - 성공:설정완료 카운트, 실패:0
         Parameter
         EMPSIDS        직원번호들(구분자',')
         AUTH        권한(0.혼자쓰기 1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.팀관리자  5.직원) .. 해지시 5 넘김
         TEMSID        팀번호(팀관리자의 경우에만 필요.. 그외 0)
         TTMSID        상위팀번호(상위팀관리자의 경우에만 필요.. 그외 0)
         */
        
        NetworkManager.shared().SetEmpAuthor(empsids: empsids, auth: 5, temsid: 0, ttmsid: 0) { (isSuccess, resCode) in
            if (isSuccess){
                if resCode > 0 {
                    self.empTuple.removeAll()
                    DispatchQueue.main.async {
                        self.valueSetting()
                        self.tblList.reloadData()
                    }
                    
                }else{
                    self.customAlertView("다시 시도해 주세요.")
                }
            }else{
                self.customAlertView("다시 시도해 주세요.")
            }
        }
    }
}

// MARK:  - UITableViewDelegate
extension MgmtCmpMgrVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if empTuple.count < 1 {
            return 2
        }
        return empTuple.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 218
        }else {
            return 90
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CmpMgrCell", for: indexPath) as! CmpMgrCell
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CmpMgrListCell", for: indexPath) as! CmpMgrListCell
            
            if empTuple.count < 1 {
                cell.vwNoMgr.isHidden = false
            }else {
                cell.vwNoMgr.isHidden = true
                let author = empTuple[indexPath.row - 1].0 //1.최고관리자(대표) 2.총괄관리자(최고관리자와 동급) 3.상위팀관리자 4.상위팀관찰자 5.팀관리자 6.팀관찰자 7.직원
                let enname = empTuple[indexPath.row - 1].1
                //        let mbrsid = empTuple[indexPath.row - 1].2
                let name = empTuple[indexPath.row - 1].3
                let profimg = empTuple[indexPath.row - 1].4
                //        let sid = empTuple[indexPath.row - 1].5
                let spot = empTuple[indexPath.row - 1].6
                

                if spot == "" {
                    cell.leadingConstraints.constant = -5
                }
                
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
                
                cell.imgProfile.image = profimg
                
                if enname == "" {
                    cell.lblName.text = name
                }else {
                    cell.lblName.text = name + "(" + enname + ") "
                }
                cell.lblSpot.text = spot
                cell.imgMgr.image = authorImg
                
                cell.btnCell.tag = indexPath.row - 1
                cell.btnCell.addTarget(self, action: #selector(selectCell(_:)), for: .touchUpInside)
            }
            return cell
        }
    }
    // FIXME: 팝업 수정
    @objc func selectCell(_ sender: UIButton) {
        let name = empTuple[sender.tag].3
        let empsids = String(empTuple[sender.tag].5)
        DispatchQueue.main.async {
            let vc = MoreSB.instantiateViewController(withIdentifier: "MgmtCmpMgrPopUp") as! MgmtCmpMgrPopUp
            vc.name = name
            vc.empsids = empsids
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
}
