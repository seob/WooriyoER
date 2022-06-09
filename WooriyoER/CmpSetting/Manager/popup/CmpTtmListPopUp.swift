//
//  CmpTtmListPopUp.swift
//  PinPle
//
//  Created by WRY_010 on 2020/01/06.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit

class CmpTtmListPopUp: UIViewController {
    
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    @IBOutlet weak var btnSave: UIButton!
    
    var tuple: [EmplyInfo] = []
    var empsids = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        if tuple.count < 5 {
            tblHeight.constant = CGFloat(tuple.count * 64)
        }else {
            tblHeight.constant = 4 * 64
        }
        
        btnSave.backgroundColor = EnterpriseColor.btnColor
        btnSave.setTitleColor(EnterpriseColor.lblColor, for: .normal)
    }
    
    @IBAction func okClick(_ sender: UIButton) {
        let start = empsids.startIndex
        let end = empsids.index(empsids.endIndex, offsetBy: -2 )
        let subStr = empsids[start...end]
        
        let auth = 2
        let temsid = 0
        let ttmsid = 0
        
        NetworkManager.shared().SetEmpAuthor(empsids: String(subStr), auth: auth, temsid: temsid, ttmsid: ttmsid) { (isSuccess, resData) in
            if(isSuccess){
                if resData > 0 {
                    let vc = CmpCrtSB.instantiateViewController(withIdentifier: "WTInfoVC") as! WTInfoVC
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true, completion: nil)
                }else{
                    self.customAlertView("실패 하였습니다.")
                }
            }else{
                self.customAlertView("네트워크 상태를 확인해 주세요.")
            }
        }
    }
    
    @IBAction func reSelClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
extension CmpTtmListPopUp: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tuple.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CmpTTMPopUp") as!  CmpTTMPopUp
        cell.selectionStyle = .none
        let data = tuple[indexPath.row]
        let enname = data.enname
        let name = data.name
        let profimg = data.profimg
        let sid = data.sid
        
        empsids = empsids + String(sid) + ","
        
        if profimg.urlTrim() != "img_photo_default.png" {
            cell.profile.setImage(with: profimg)
        }else{
            cell.profile.image = defaultImg
        }
 
        cell.txtInfo.text = name.ennameCheck(enname: enname)
        
        return cell
    }
    
    
}
