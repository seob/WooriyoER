//
//  MgrCmtSetting.swift
//  PinPle
//
//  Created by WRY_010 on 2020/02/07.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class MgrCmtSetting: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    
    var tuple : [Msmgrlist] = []
    
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
       // IndicatorSetting()
        valueSetting()
        
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        var vc = MoreSB.instantiateViewController(withIdentifier: "CmpMgrVC") as! CmpMgrVC
        if SE_flag {
            vc = MoreSB.instantiateViewController(withIdentifier: "SE_CmpMgrVC") as! CmpMgrVC
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func valueSetting() {
        NetworkManager.shared().CmpMsmgrlist(cmpsid: userInfo.cmpsid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else {
                    return
                }
                self.tuple = serverData
                self.tblList.reloadData()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }else {
                self.customAlertView("다시 시도해 주세요.")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension MgrCmtSetting: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tuple.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MgrCmtCell", for: indexPath) as! MgrCmtCell
        
        //            let sid = tuple[indexPath.row].sid
        let spot = tuple[indexPath.row].spot
        let author = tuple[indexPath.row].author
        let notrc = tuple[indexPath.row].notrc
        //            let mbrsid = tuple[indexPath.row].mbrsid
        let name = tuple[indexPath.row].name
        let enname = tuple[indexPath.row].enname
        
        if notrc == 0 {
            cell.btnInclude.isSelected = true
            cell.btnException.isSelected = false
        }else {
            cell.btnInclude.isSelected = false
            cell.btnException.isSelected = true
        }
        
        let profimg = self.tuple[indexPath.row].profimg
        if profimg.urlTrim() != "img_photo_default.png" {
            cell.imgProfile.setImage(with: profimg)
        }else {
            cell.imgProfile.image = UIImage(named: "logo_pre")
        }
        if spot == "" {
            cell.leadingConstraints.constant = -5
        }
        print("author = \(author)")
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
        cell.imgMgr.image = authorImg
        
        if enname == "" {
            cell.lblName.text = name
        }else {
            cell.lblName.text = name + "(" + enname + ") "
        }
        cell.lblSpot.text = spot
        
        cell.btnInclude.tag = indexPath.row
        cell.btnInclude.addTarget(self, action: #selector(btnInclude(_:)), for: .touchUpInside)
        cell.btnException.tag = indexPath.row
        cell.btnException.addTarget(self, action: #selector(btnException(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func btnInclude(_ sender: UIButton) {
        let selempsid = tuple[sender.tag].sid
        NetworkManager.shared().SetEmpNotrc(empsid: selempsid, notrc: 0) { (isSuccess, error, resultCode) in
            if (isSuccess) {
                if error == 1 {
                    if resultCode == 1 {
                        if userInfo.empsid == self.tuple[sender.tag].sid {
                            userInfo.notrc = 0
                        }
                        self.tuple[sender.tag].notrc = 0
                        self.tblList.reloadData()
                    }else {
                        self.toast("잠시 후, 다시 시도해 주세요.")
                    }
                }else {
                    self.toast("다시 시도해 주세요.")
                }
            }else {
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
        }
    }
    
    @objc func btnException(_ sender: UIButton) {
        let selempsid = tuple[sender.tag].sid
        NetworkManager.shared().SetEmpNotrc(empsid: selempsid, notrc: 1) { (isSuccess, error, resultCode) in
            if (isSuccess) {
                if error == 1 {
                    if resultCode == 1 {
                        if userInfo.empsid == self.tuple[sender.tag].sid {
                            userInfo.notrc = 1
                        }
                        self.tuple[sender.tag].notrc = 1
                        self.tblList.reloadData()
                    }else {
                        self.toast("잠시 후, 다시 시도해 주세요.")
                    }
                }else {
                    self.toast("다시 시도해 주세요.")
                }
            }else {
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
        }
    }
    
}
