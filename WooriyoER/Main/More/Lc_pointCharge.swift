//
//  Lc_pointCharge.swift
//  PinPle
//
//  Created by seob on 2020/06/05.
//  Copyright © 2020 WRY_010. All rights reserved.
//

import UIKit
import StoreKit

 
class Lc_pointCharge: UIViewController {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblMyPoint: UILabel!
    @IBOutlet weak var ExpectedPoint: UILabel! //예정 포인트
    @IBOutlet weak var AfterPoint: UILabel! //충전후 포인트
    
    var productsRequest = SKProductsRequest()
    var validProducts = [SKProduct]()
    var productIndex = 0
    fileprivate var productIdTuple = [(p_product: "com.wooriyo.wooriyo.5pin", p_id: "5"),(p_product: "com.wooriyo.wooriyo.10pin", p_id: "10"),(p_product: "com.wooriyo.wooriyo.20pin", p_id: "20"),(p_product: "com.wooriyo.wooriyo.30pin", p_id: "30")]
    var productIdArr = ["com.wooriyo.wooriyo.5pin","com.wooriyo.wooriyo.10pin","com.wooriyo.wooriyo.20pin","com.wooriyo.wooriyo.30pin"]
    //MARK:- Public
    var selInfo : LcEmpInfo = LcEmpInfo() //핀플 근로계약서
    var standInfo : LcEmpInfo = LcEmpInfo() // 표준계약서
    var inappList : [InappInfo] = []
    var point:Int = 0
    var price:Int = 0
    var beforepoint = 0
    var afterpoint = 0
    var viewflagType = ""
    var isLogEnabled: Bool = true
    
//    var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    var paymentTransactionArr:[SKPaymentTransaction] = [SKPaymentTransaction]()
     var bundleId = ""
    var originalTransactionIdentifier:String = String()
     var currentTransactionIdentifier:String = String()
    let dateFormatter = DateFormatter()
    //MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    // RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func removeAllTransactioninPamentArr(){
        paymentTransactionArr.removeAll()
    }
    
    func transactionCompleteAction(_ esntlId: String, onCompletion: @escaping (Bool) -> Void) {
        timeSetting()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
         
        
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        tblList.register(UINib.init(nibName: "InappTableViewCell", bundle: nil), forCellReuseIdentifier: "InappTableViewCell")
        fetchAvailableProducts()
    }
    
    func fetchAvailableProducts()  {
        let productIdentifiers = NSSet(objects:
            "com.wooriyo.pinpl.5pin",
           "com.wooriyo.pinpl.11pin",
           "com.wooriyo.pinpl.23pin",
           "com.wooriyo.pinpl.36pin"
        )
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInappList()
        beforepoint = 23
        point = CompanyInfo.point
        afterpoint = point + beforepoint
        lblMyPoint.text = "\(point)"
        ExpectedPoint.text = "\(beforepoint)pin"
        AfterPoint.text = "\(afterpoint)pin"
         
    }
    fileprivate func CalPoint(){
        point = CompanyInfo.point
        afterpoint = point + beforepoint
        lblMyPoint.text = "\(point)"
        ExpectedPoint.text = "\(beforepoint)pin"
        AfterPoint.text = "\(afterpoint)pin"
    }
    
    fileprivate func getInappList(){
        NetworkManager.shared().InappInfo { (isSuccess, resData , resimg) in
            if(isSuccess){
                guard let serverData = resData else {
                    return
                }
                self.inappList = serverData
                self.beforepoint = self.inappList[0].pin
                self.CalPoint()
                self.tblList.reloadData()
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
    }
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        if viewflag == "step7" {
            let vc = ContractSB.instantiateViewController(withIdentifier: "Lc_Step7VC") as! Lc_Step7VC
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            if viewflagType == "stand_step5" {
                vc.standInfo = self.standInfo
                vc.viewflagType = "stand_step5"
            }else{
                vc.selInfo = self.selInfo
            }
            
            self.present(vc, animated: false, completion: nil)
        }else {
            var vc = ContractSB.instantiateViewController(withIdentifier: "ContractMainVC") as! ContractMainVC
            if SE_flag {
                vc = ContractSB.instantiateViewController(withIdentifier: "SE_ContractMainVC") as! ContractMainVC
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func NextDidTap(_ sender: Any) {
        if tblList.indexPathForSelectedRow?.row != nil {
            let selRow = tblList.indexPathForSelectedRow?.row
            let _ = inappList[selRow ?? 0].name
            let Price = inappList[selRow ?? 0].price
            
            productIndex = selRow ?? 0
            purchaseMyProduct(validProducts[productIndex])
            
            toast("\(beforepoint) 핀  , 결제금액 : \(Price)")
            
        }
        
    }
    
    func selectTotalSA(_ selectorItem: String) -> String {
        var retrunStr = ""
        for i in 0..<productIdTuple.count-1{
            if(productIdTuple[i].p_product == selectorItem){
                retrunStr = productIdTuple[i].p_id
            }
        }
        return retrunStr
    }
    
}



//MARK:- UITableViewMethods
extension Lc_pointCharge: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inappList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InappTableViewCell", for: indexPath) as? InappTableViewCell {
            cell.selectionStyle = .none
            cell.lblName.text = inappList[indexPath.row].name
            cell.lblPrice.text = inappList[indexPath.row].price
            let pin = 2
            if pin == indexPath.row {
                tblList.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                prefs.setValue(indexPath.row, forKey: "InappindexPath")
            }
            cell.tag = inappList[indexPath.row].pin
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selIndexPath = -1
        if prefs.value(forKey: "InappindexPath") != nil {
            selIndexPath = prefs.value(forKey: "InappindexPath") as! Int
        }
        
        if selIndexPath == indexPath.row {
            tableView.deselectRow(at: indexPath, animated: false)
            prefs.removeObject(forKey: "InappindexPath")
        }else {
            prefs.setValue(indexPath.row, forKey: "InappindexPath")
        }
        beforepoint = tableView.cellForRow(at: indexPath)?.tag as! Int
        
        CalPoint()
    }
}

// MARK: - SKProductsRequestDelegate , SKPaymentTransactionObserver
extension Lc_pointCharge: SKProductsRequestDelegate , SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (response.products.count > 0) {
            validProducts = response.products
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        timeSetting()
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                 let tdate = setDateToString(trans.transactionDate ?? Date())
                 let tid = trans.transactionIdentifier ?? ""
                 let pid = trans.payment.productIdentifier
                let sk = "\(userInfo.mbrsid)+\(tid)".sha1()
                
                switch trans.transactionState {
                case .purchased:
                   //성공
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    NetworkManager.shared().payment_iap(MBRSID: userInfo.mbrsid, CMPSID: CompanyInfo.sid, TYPE: productIndex, PID: pid, STATUS: 1, TID: tid, TDATE: tdate, SK: sk) { (isSuccess, resCode) in
//                        if(isSuccess){
//                            switch resCode {
//                            case -1:
//                                self.toast("인증 실패 하였습니다.")
//                            case 0:
//                                self.toast("포인트 충전에 실패 하였습니다.")
//                            default:
//                                CompanyInfo.point = resCode
//                            }
//                        }else{
//                            self.toast("다시 시도해 주세요.")
//                        }
//                    }
                    break
                    
                case .failed:
                    //실패
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    self.toast("결재 실패 하였습니다.")
                    break
                case .deferred :
                    print("\n---------- [ deferred ] ----------\n")
                    break
                case .purchasing :
                    print("\n---------- [ purchasing ] ----------\n")
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    print("Purchase has been successfully restored!")
                    break
                    
                default: break
                }}}
    }
    
    
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("The Payment was successfull!")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    func purchaseMyProduct(_ product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else { print("Purchases are disabled in your device!") }
    }
    
     func timeSetting(){
         dateFormatter.dateStyle = .full
         dateFormatter.timeStyle = .full
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
         dateFormatter.timeZone = TimeZone.autoupdatingCurrent
     }
}

