//
//  IAPHelperVC.swift
//  PinPle
//
//  Created by seob on 2021/03/02.
//  Copyright © 2021 WRY_010. All rights reserved.
//

import UIKit
import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandlervc = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
    static let IAPHelperVCPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

open class IAPHelperVC: NSObject  {
    private let productIdentifiers: Set<ProductIdentifier>
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var ProductsRequestCompletionHandlervc: ProductsRequestCompletionHandlervc?
    
    
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
//
//        for productIdentifier in productIds {
//            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
//
//            if purchased {
//                purchasedProductIdentifiers.insert(productIdentifier)
//                print("Previously purchased: \(productIdentifier)")
//            } else {
//                print("Not purchased: \(productIdentifier)")
//            }
//        }
         
        
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

extension IAPHelperVC {
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandlervc) {
        print("\n---------- [ 111 ] ----------\n")
        productsRequest?.cancel()
        ProductsRequestCompletionHandlervc = completionHandler
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
        SKPaymentQueue.default().add(self)
    }
    
    
    public func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPHelperVC: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("\n---------- [ Loaded list of products. ] ----------\n")
        let products = response.products
        ProductsRequestCompletionHandlervc?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("\n---------- [ Failed to load list of products ] ----------\n")
        print("\n---------- [ Error: \(error.localizedDescription) ] ----------\n")
        ProductsRequestCompletionHandlervc?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        ProductsRequestCompletionHandlervc = nil
    }
}

extension IAPHelperVC: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
                case .purchased:
                    complete(transaction: transaction)
                    break
                case .failed:
                    fail(transaction: transaction)
                    break
                case .restored:
                    restore(transaction: transaction)
                    break
                case .deferred:
                    break
                case .purchasing:
                    break
                @unknown default:
                    fatalError()
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...111")
        
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        
        if let transactionError = transaction.error as NSError?,
           let localizedDescription = transaction.error?.localizedDescription,
           transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .IAPHelperVCPurchaseNotification, object: identifier)
    }
}

public struct InAppProducts {
//    public static let product:[String] = [
//                                          "com.wooriyo.wooriyo.11pin",
//                                          "com.wooriyo.wooriyo.23pin",
//                                          "com.wooriyo.wooriyo.36pin",
//                                          "com.wooriyo.wooriyo.5pin"]
    public static let product:[String] = [
                                          "com.wooriyo.wooriyo.10pin",
                                          "com.wooriyo.wooriyo.20pin",
                                          "com.wooriyo.wooriyo.30pin",
                                          "com.wooriyo.wooriyo.5pin"]
    
    static let productIdentifiers: Set<String> = Set<String>([product[0], product[1], product[2], product[3]])
    static let productIdTuple = [(p_id: product[0], p_title: "store_pinpl_11"),
                                 (p_id: product[1], p_title: "store_pinpl_23"),
                                 (p_id: product[2], p_title: "store_pinpl_36"),
                                 (p_id: product[3], p_title: "store_pinpl_5")]
//    static let productIdTuple = [(p_id: product[0], p_title: "store_pinpl_11"),
//                                 (p_id: product[1], p_title: "store_pinpl_23"),
//                                 (p_id: product[2], p_title: "store_pinpl_36"),
//                                 (p_id: product[3], p_title: "store_pinpl_5")]
    //var productArray = [AnyObject]()
    
    public static let store = IAPHelperVC(productIds: InAppProducts.productIdentifiers)
    
//    private static let productIdentifiers: Set<ProductIdentifier> = [InAppProducts.product]
//    public static let store = IAPHelperVC(productIds: InAppProducts.productIdentifiers)
}
