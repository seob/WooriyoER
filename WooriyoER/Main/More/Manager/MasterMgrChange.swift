//
//  MasterMgrChange.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/29.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class MasterMgrChange: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwNoEmp: UIView!
    
    var tuple : [SuperMgrInfo] = []
    var empsids = ""
    var auth = 0
    var temsid = 0
    var ttmsid = 0
    
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
        
        NetworkManager.shared().CmpSupermgrlist(cmpsid: userInfo.cmpsid) { (isSuccess, resData) in
            if (isSuccess) {
                guard let serverData = resData else {
                    return
                }
                if serverData.count > 0 {
                    self.vwNoEmp.isHidden = true
                }else {
                    self.vwNoEmp.isHidden = false
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

extension MasterMgrChange: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tuple.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterMgrListCell", for: indexPath) as! MasterMgrListCell
        
        
        //            let sid = tuple[indexPath.row].sid
        let spot = tuple[indexPath.row].spot
        let author = tuple[indexPath.row].author
        //            let notrc = tuple[indexPath.row].notrc
        //            let mbrsid = tuple[indexPath.row].mbrsid
        let name = tuple[indexPath.row].name
        let enname = tuple[indexPath.row].enname
        
//
//        DispatchQueue.main.async {
//            let profimg = self.tuple[indexPath.row].profimg
//            if profimg.urlTrim() != "img_photo_default.png" {
//                cell.imgProfile.setImage(with: profimg)
//            }else {
//                cell.imgProfile.image = UIImage(named: "logo_pre")
//            }
//        }
        
        cell.imgProfile.sd_setImage(with: URL(string: self.tuple[indexPath.row].profimg), placeholderImage: UIImage(named: "logo_pre"))
        print("author = \(author)  ,  11 : \(tuple[indexPath.row].author)")
        var authorImg = UIImage()
        switch author {
        case 0:
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
        cell.btnCell.tag = indexPath.row
        cell.btnCell.addTarget(self, action: #selector(selectCell(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func selectCell(_ sender: UIButton) {
        let selname = tuple[sender.tag].name
        let selempsid = tuple[sender.tag].sid
        DispatchQueue.main.async {
            let vc = MoreSB.instantiateViewController(withIdentifier: "MasterMgrPopUp") as! MasterMgrPopUp
            vc.selname = selname.postPositionText(type: 0)
            vc.selempsid = selempsid
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    
}
