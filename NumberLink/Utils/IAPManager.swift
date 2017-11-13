//
//  IAPManager.swift
//  NumberLink
//
//  Created by Thuong Nguyen on 11/2/17.
//  Copyright © 2017 Thuong Nguyen. All rights reserved.
//
import Foundation
import StoreKit

protocol IAPDelegate {
    func purchased()
}

class IAPManager: NSObject {
    
    var delegate: IAPDelegate?
    var product: SKProduct?
    var productRequest: SKProductsRequest!
    
    static var instance: IAPManager?
    
    static func getInstance() -> IAPManager? {
        if instance == nil {
            instance = IAPManager()
        }
        return instance
    }
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func purchase() {
        if product != nil {
            let payment = SKPayment(product: product!)
            SKPaymentQueue.default().add(payment)
        }
    }
    
}

extension IAPManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        product = response.products[0]
    }
    
    func fetchProducts() {
        let productIds = Set([Common.productID])
        productRequest = SKProductsRequest(productIdentifiers: productIds)
        productRequest.delegate = self
        productRequest.start()
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                purchased(transaction)
                break
            case .restored:
                handleOtherCases(transaction)
                break
            case .failed:
                handleOtherCases(transaction)
                break
            case .deferred:
                handleOtherCases(transaction)
                break
            case .purchasing:
                handleOtherCases(transaction)
                break
                
            }
        }
    }
    
    func purchased(_ transaction: SKPaymentTransaction) {
        delegate?.purchased()
        SKPaymentQueue.default().finishTransaction(transaction)
        showPurchasedAlert()
    }
    
    func restore(_ transaction: SKPaymentTransaction) {
        delegate?.purchased()
        SKPaymentQueue.default().finishTransaction(transaction)
        showPurchasedAlert()
    }
    
    
    
    func handleOtherCases(_ transaction: SKPaymentTransaction) {
    }
    
    func showPurchasedAlert() {
        GameViewController.showAlertView(title: "Purchase Successfully", message: "You have purchased successfully. Now all the ads are removed. Enjoy the game!")
    }
}
