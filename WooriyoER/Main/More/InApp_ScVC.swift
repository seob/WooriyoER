//
//  InApp_ScVC.swift
//  PinPle
//
//  Created by seob on 2021/11/15.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit
import StoreKit

class InApp_ScVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var lblNavigationTitle: UILabel!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblMyPoint: UILabel!
    @IBOutlet weak var ExpectedPoint: UILabel! //예정 포인트
    @IBOutlet weak var AfterPoint: UILabel! //충전후 포인트
    
    @IBOutlet weak var eventView: UIView! // 이벤트뷰
    @IBOutlet weak var eventImageView: UIImageView! // 이벤트뷰
    
    @IBOutlet weak var btnCharge: UIImageView! // 충전하기 버튼
    
    @IBOutlet weak var tblHeightConstraint: NSLayoutConstraint! //이벤트가 있으면 68 없으면 0
    @IBOutlet weak var btnPoint: UIButton!
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    // MARK: IndicatorSetting
    fileprivate func IndicatorSetting() {
        let size = CGSize(width: 30, height: 30)
        let selectedIndicatorIndex = 17
        let indicatorType = presentingIndicatorTypes[selectedIndicatorIndex]
        startAnimating(size, message: "결재중입니다..", type: indicatorType, fadeInAnimation: nil)
    }
    var selInfo : ScEmpInfo = ScEmpInfo()
    var inappList : [InappInfo] = []
    var point:Int = 0
    var price:Int = 0
    var beforepoint = 0
    var afterpoint = 0
    var viewflagType = ""
    var isLogEnabled: Bool = true
    var eventImage = "" //이벤트 이미지
    var productIdentifiers = Set(["com.wooriyo.pinpl.5pin", "com.wooriyo.pinpl.11pin", "com.wooriyo.pinpl.23pin"]) //아이튠즈 커넥트에서 셋팅할 각 상품의 ID
    var product: SKProduct = SKProduct() //상품의 이름,설명,가격 등의 정보를 담는 객체
    var productsArray = [SKProduct]()
    var validProducts = Array<SKProduct>()
    var productIndex = 0
    let dateFormatter = DateFormatter()
    var productsRequest: SKProductsRequest?
    var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    var paymentTransactionArr:[SKPaymentTransaction] = [SKPaymentTransaction]()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPoint.layer.cornerRadius = 6
        if SE_flag {
            lblNavigationTitle.font = navigationFontSE
        }
        
        SKPaymentQueue.default().add(self)
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
        tblList.register(UINib.init(nibName: "InappTableViewCell", bundle: nil), forCellReuseIdentifier: "InappTableViewCell")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleRestoreNotification(_:)),
                                               name: .IAPHelperRestoreNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleFailNotification(_:)),
                                               name: .IAPHelperFailNotification,
                                               object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .IAPHelperPurchaseNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .IAPHelperRestoreNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self, name: .IAPHelperFailNotification,
                                                  object: nil)
    }
    
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard let transaction = notification.object as? SKPaymentTransaction else{
            return
        }
        var buttonSelector: String = ""
        
        if transaction.payment.productIdentifier == "com.wooriyo.pinpl.5pin" {
            buttonSelector = "5pin"
        }else if transaction.payment.productIdentifier == "com.wooriyo.pinpl.11pin" {
            buttonSelector = "11pin"
        }else if transaction.payment.productIdentifier == "com.wooriyo.pinpl.23pin" {
            buttonSelector = "23pin"
        }else if transaction.payment.productIdentifier == "com.wooriyo.pinpl.36pin" {
            buttonSelector = "36pin"
        }else{
            return;
        }
        
        //새로 추가 20190319
        let storeCount: [String] = buttonSelector.components(separatedBy: "_")//Store = 1, Alba = 3
        if storeCount.count == 0 {
            return
        }
        
        if(transaction.original?.transactionIdentifier != nil){
            prefs.setValue(transaction.original?.transactionIdentifier, forKey: "originalTransaction")
        }else{
            prefs.setValue(transaction.transactionIdentifier , forKey: "originalTransaction")
        }
        IndicatorSetting() //로딩
        //미리 이 작업을 실행하지 않으면 시간 변환이 안되어 오류가 발생
        timeSetting()
        switch transaction.transactionState {
        case .purchased:
            //성공
            let tdate = setDateToString(transaction.transactionDate ?? Date())
            let tid = transaction.transactionIdentifier ?? ""
            let pid = transaction.payment.productIdentifier
            let clearString = "\(userInfo.mbrsid)" + "" + tid
            let hash = SHA1Hash()
            guard let sk = hash.hash(string: clearString) else { return }
             
            SKPaymentQueue.default().finishTransaction(transaction)
        case .failed:
            //실패
            SKPaymentQueue.default().finishTransaction(transaction)
            fail(transaction: transaction)
            self.toast("결재 실패 하였습니다.")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
            break
        case .deferred :
            print("\n---------- [ deferred ] ----------\n")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
            break
        case .purchasing :
            print("\n---------- [ purchasing ] ----------\n")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
            break
        case .restored:
            restore(transaction: transaction)
            SKPaymentQueue.default().finishTransaction(transaction)
            print("Purchase has been successfully restored!")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
            break
            
        default:
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.stopAnimating(nil)
            }
            break
        }
    }
    
    override func setNeedsFocusUpdate() {
        print("\n---------- [ setNeedsFocusUpdate ] ----------\n")
        point = CompanyInfo.point
        lblMyPoint.text = "\(point)"
    }
    
    @objc func handleRestoreNotification(_ notification: Notification) {
        guard let transaction = notification.object as? SKPaymentTransaction else{  return }
        print("\n---------- [ handleRestoreNotification ] ----------\n")
    }
    
    // MARK: - handleFailNotification 결제 실패시
    @objc func handleFailNotification(_ notification: Notification) {
        guard let transaction = notification.object as? SKPaymentTransaction else{
            return
        }
        
        timeSetting()
        IndicatorSetting() //로딩
        let tdate = setDateToString(transaction.transactionDate ?? Date())
        let tid = transaction.transactionIdentifier ?? ""
        let pid = transaction.payment.productIdentifier
        let clearString = "\(userInfo.mbrsid)" + "" + tid
        let hash = SHA1Hash()
        guard let sk = hash.hash(string: clearString) else { return }
        NetworkManager.shared().payment_iap(MBRSID: userInfo.mbrsid, CMPSID: CompanyInfo.sid, TYPE: productIndex, PID: pid, STATUS: 0, TID: tid, TDATE: tdate.urlEncoding(), SK: sk) { (isSuccess, resCode) in
            if(isSuccess){
                if resCode > 0 {
                    CompanyInfo.point = resCode
                    self.setNeedsFocusUpdate()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                }else{
                    self.toast("결제 정보가 정상적으로 적용 되지 않았습니다.")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.stopAnimating(nil)
                    }
                }
            }else{
                self.toast("다시 시도해 주세요.")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.stopAnimating(nil)
                }
            }
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestProductData()
        beforepoint = 23
        prefs.setValue(beforepoint, forKey: "InappindexPath")
        point = CompanyInfo.point
        afterpoint = point + beforepoint
        lblMyPoint.text = "\(point)"
        ExpectedPoint.text = "+\(beforepoint)pin"
        AfterPoint.text = "\(afterpoint)pin"
        paymentTransactionArr.removeAll()
        print("\n---------- [ beforepoint : \(beforepoint) , afterpoint:\(afterpoint) ] ----------\n")
        getInappList()
        
    }
    
    fileprivate func getInappList(){
        
        NetworkManager.shared().InappInfo { (isSuccess, resData , resimg) in
            if(isSuccess){
                guard let serverData = resData else {
                    return
                }
                self.inappList = serverData
                self.eventImage = resimg
                print("\n---------- [ resimg : \(resimg) ] ----------\n")
                
                
                if self.eventImage != "" {
                    self.eventView.isHidden = false
                    if self.eventImage.urlTrim() != "img_photo_default.png" {
                        self.eventImageView.setImage(with: self.eventImage)
                    }
                    self.tblHeightConstraint.constant = 68.0
                }else{
                    self.eventView.isHidden = true
                    self.tblHeightConstraint.constant = 0
                }
                
                self.tblList.reloadData()
            }else{
                self.toast("다시 시도해 주세요.")
            }
        }
        
        
    }
    
    fileprivate func CalPoint(){
        point = CompanyInfo.point
        afterpoint = point + beforepoint
        lblMyPoint.text = "\(point)"
        ExpectedPoint.text = "+\(beforepoint)pin"
        AfterPoint.text = "\(afterpoint)pin"
    }
    
    
    //MARK: - navigation back button
    @IBAction func barBack(_ sender: UIButton) {
        switch moreCmpInfo.freetype {
            case 2,3:
                //올프리 , 펀프리
                if moreCmpInfo.freedt >= muticmttodayDate() {
                    var vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_Step4VC") as! Sc_Step4VC
                    if SE_flag {
                        vc = SecurtSB.instantiateViewController(withIdentifier: "SE_Sc_Step4VC") as! Sc_Step4VC
                    }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.selInfo = self.selInfo
                    self.present(vc, animated: false, completion: nil)
                }else{
                    var vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_Step4VC") as! Sc_Step4VC
                    if SE_flag {
                        vc = SecurtSB.instantiateViewController(withIdentifier: "SE_Sc_Step4VC") as! Sc_Step4VC
                    }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    vc.selInfo = self.selInfo
                    self.present(vc, animated: false, completion: nil)
                }
            default :
                var vc = SecurtSB.instantiateViewController(withIdentifier: "Sc_Step4VC") as! Sc_Step4VC
                if SE_flag {
                    vc = SecurtSB.instantiateViewController(withIdentifier: "SE_Sc_Step4VC") as! Sc_Step4VC
                }
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overFullScreen
                vc.selInfo = self.selInfo
                self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    // 결제 선택
    @IBAction func NextDidTap(_ sender: Any) {
        if tblList.indexPathForSelectedRow?.row != nil {
            let selRow = tblList.indexPathForSelectedRow?.row
            let Productname = inappList[selRow ?? 0].product
            let Price = inappList[selRow ?? 0].price
            
            productIndex = selRow ?? 0
            goPayment(productIndex)
        }else{
            print("\n---------- [ 111 ] ----------\n")
            
        }
        
    }
    
    func goPayment(_ i: Int){
        if(i != -1){
            if self.inappList.count > 0 {
                if productsArray.count > 0 {
                    buyProduct(productsArray[i])
                }else{
                    self.toast("상품 정보를 가져오지 못했습니다. 잠시 후 시도해 주세요.")
                }
                
            }else{
                toast("다시 시도해 주세요.")
            }
        }
        
    }
    
    
    
    fileprivate func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        print("product \(product)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func requestProductData()
    {
        productsRequest?.cancel()
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers:
                self.productIdentifiers as Set<String>)
            request.delegate = self
            request.start()
        } else {
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplication.openSettingsURLString)
                if url != nil
                {
                    UIApplication.shared.openURL(url! as URL)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func transactionCompleteAction(_ esntlId: String, onCompletion: @escaping (Bool) -> Void) {
        print("\n---------- [ transactionCompleteAction ] ----------\n")
        var returnFlag:Bool = false
        if paymentTransactionArr.count == 0 {
            return
        }
        self.removeAllTransactioninPamentArr()
    }
    
    func removeAllTransactioninPamentArr(){
        paymentTransactionArr.removeAll()
        print("removeAll paymentTransactionArr.count \(self.paymentTransactionArr.count)")
    }
}


//MARK:- UITableViewMethods
extension InApp_ScVC: UITableViewDataSource, UITableViewDelegate {
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

// MARK: - SKProductsRequestDelegate
extension InApp_ScVC: SKProductsRequestDelegate , SKPaymentTransactionObserver {
    //결제 결과
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                print("------------------")
                print("paymentQueue purchased")
                complete(transaction: transaction)
//                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .failed:
                print("paymentQueue failed")
                fail(transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .restored:
                print("------------------")
                print("paymentQueue restored")
                restore(transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            default:
                break
            }
        }
    }
    //성공했을때
    private func complete(transaction: SKPaymentTransaction) {
        print("SKPaymentTransaction complete start")
        //deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)3
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            print("topController\(topController)")
            if type(of: topController) == InAppVC.self {
                NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: transaction)
            }else{
                print("Add Payment to paymentTransactionArr")
                paymentTransactionArr.append(transaction)
                print("paymentTransactionArr\(paymentTransactionArr)")
            }
        }
    }
    //복구했을때
    private func restore(transaction: SKPaymentTransaction) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if type(of: topController) == InAppVC.self {
                print("restore transaction Notification")
                NotificationCenter.default.post(name: .IAPHelperRestoreNotification, object: transaction)
            }else{
                print("Restore Add Payment to paymentTransactionArr")
                paymentTransactionArr.append(transaction)
                print(paymentTransactionArr)
            }
        }
    }
    // 실패 했을때
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if type(of: topController) == InAppVC.self {
                print("fail transaction Notification")
                if let transactionError = transaction.error as NSError?,
                    let localizedDescription = transaction.error?.localizedDescription,
                    transactionError.code != SKError.paymentCancelled.rawValue {
                    print("Transaction Error: \(localizedDescription)")
                }
                NotificationCenter.default.post(name: .IAPHelperFailNotification, object: transaction)
            }else{
                if let transactionError = transaction.error as NSError?,
                    let localizedDescription = transaction.error?.localizedDescription,
                    transactionError.code != SKError.paymentCancelled.rawValue {
                    print("Transaction Error: \(localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.stopAnimating(nil)
            }
        }
    }
    
    //post로 보낸 위치에서 작업이 끝났으면 아래 함수의 호출을 통해 트랜젝션을 종료할 수 있음
    func inAppfinishTransaction(transaction: SKPaymentTransaction){
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
    }
    
    
    func deliverProduct(transaction:SKPaymentTransaction) {
        
        if transaction.payment.productIdentifier == "com.wooriyo.pinpl.5pin"
        {
            print("Consumable Product Purchased")
            // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com.wooriyo.pinpl.11pin"
        {
            print("Non-Consumable Product Purchased")
            // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com.wooriyo.pinpl.23pin"
        {
            print("Auto-Renewable Subscription Product Purchased")
            // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "com.wooriyo.pinpl.36pin"
        {
            print("Free Subscription Product Purchased")
            // Unlock Feature
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        var products = response.products
        
        if (products.count != 0) {
            //  dispatchMain.async {
            products.sort(by: { (p0, p1) -> Bool in
                return p0.price.floatValue < p1.price.floatValue
            })
            for i in 0..<products.count {
                self.product = products[i] as? SKProduct ?? SKProduct()
                self.productsArray.append(self.product)
                self.validProducts.append(self.product)
            }
            // }
        } else {
            print("\n---------- [ No products found ] ----------\n")
        }
        
        var notFoundProduct: [String] = []
        notFoundProduct = response.invalidProductIdentifiers
        for product in notFoundProduct
        {
            print("\n---------- [ Product not found: \(product) ] ----------\n")
        }
        clearRequestAndHandler()
    }
    
    
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
    //구매 복구
    func restorePurchases(sender: UIButton) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    // 복구 완료시
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Transactions Restored")
        
        for transaction:SKPaymentTransaction in queue.transactions {
            
            if transaction.payment.productIdentifier == "com.wooriyo.pinpl.5pin"
            {
                print("Consumable Product Purchased")
                // Unlock Feature
            }
            else if transaction.payment.productIdentifier == "com.wooriyo.pinpl.11pin"
            {
                print("Non-Consumable Product Purchased")
                // Unlock Feature
            }
            else if transaction.payment.productIdentifier == "com.wooriyo.pinpl.23pin"
            {
                print("Auto-Renewable Subscription Product Purchased")
                // Unlock Feature
            }
            else if transaction.payment.productIdentifier == "com.wooriyo.pinpl.36pin"
            {
                print("Free Subscription Product Purchased")
                // Unlock Feature
            } 
        }
        
        let alert = UIAlertView(title: "Thank You", message: "Your purchase(s) were restored.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    
    
    func timeSetting(){
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
    }
}
