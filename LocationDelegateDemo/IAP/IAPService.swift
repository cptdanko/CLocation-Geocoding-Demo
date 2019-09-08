//
//  IAPService.swift
//  LocationDelegateDemo
//
//  Created by Bhuman Soni on 8/9/19.
//  Copyright © 2019 Bhuman Soni. All rights reserved.
import Foundation
import StoreKit

class IAPService: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = IAPService()
    
    static let IAP_PRODUCTS: Set<String> = [
        "com.mydaytodo.modular.iap.1",
        "com.mydaytodo.modular.iap.2",
    ]
    
    var productMapping = [String:SKProduct]()
    
    var isAuthorizedForPayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    var purchaseBeingRestored = false
    public var iapTransDelegate: IAPTransDelegate?
    public var iapProdDelegate: IAPProductDelegate?
    
    var currentIapList = [MDTIapProduct]()
    
    func loadProducts() {
        let request = SKProductsRequest(productIdentifiers: IAPService.IAP_PRODUCTS)
        request.delegate = self
        request.start()
    }
    //MARK: product request delegate methods
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        currentIapList = [MDTIapProduct]()
        for product in response.products {
            productMapping[product.productIdentifier] = product
            let mdtProduct = MDTIapProduct()
            mdtProduct.desc = product.localizedDescription
            mdtProduct.price = product.price
            mdtProduct.name = product.localizedTitle
            mdtProduct.priceLocale = product.priceLocale
            mdtProduct.identifier = product.productIdentifier
            currentIapList.append(mdtProduct)
        }
        iapProdDelegate?.iapList = currentIapList
        iapProdDelegate?.iapLoaded()
    }
    func restoreIAPPurchase() {
        purchaseBeingRestored = true
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    func purchaseProduct(identifier: String) {
        if let prod = productMapping[identifier] {
            let payment = SKPayment(product: prod)
            SKPaymentQueue.default().add(payment)
        }
    }
    func completeTransaction(transaction: SKPaymentTransaction, productIdentifier:String) {
        SKPaymentQueue.default().finishTransaction(transaction)
        if purchaseBeingRestored {
            iapTransDelegate?.purchasesRestored(identifier: transaction.payment.productIdentifier)
        } else {
            iapTransDelegate?.purchaseComplete(identifier: transaction.payment.productIdentifier)
        }
        //UserDefaultsHelper.shared.toggleIAPPurchaseState(productIdentifier: productIdentifier, state: true)
    }
    //MARK: Payment transactions delegate
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for trans in transactions {
            switch trans.transactionState {
            case .purchased:
                completeTransaction(transaction: trans, productIdentifier: trans.payment.productIdentifier)
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(trans)
                //let prodId = trans.payment.productIdentifier
            //AnalyticsHelper.logIAPFail(type: IAP_FAIL.IAP_BUY, identifier: prodId)
            case .restored:
                completeTransaction(transaction: trans, productIdentifier: trans.payment.productIdentifier)
                break
            default:
                print("product not purchased")
                break
            }
        }
    }
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transaction in queue.transactions {
            if transaction.transactionState == .restored {
                completeTransaction(transaction: transaction, productIdentifier: transaction.payment.productIdentifier)
            } else {
                //AnalyticsHelper.logIAPFail(type: IAP_FAIL.IAP_RESTORE, identifier: transaction.payment.productIdentifier)
            }
        }
    }
}

protocol IAPTransDelegate {
    //trans = transaction
    func purchaseComplete(identifier: String)
    func purchasesRestored(identifier: String)
}
protocol IAPProductDelegate {
    var iapList: [MDTIapProduct] {get set}
    func iapLoaded()
}
