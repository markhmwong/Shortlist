//
//  IAPHelper.swift
//  Shortlist
//
//  Created by Mark Wong on 14/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
    static let IAPHelperPurchaseCancelledNotification = Notification.Name("IAPHelperPurchaseCancelledNotification")
    static let IAPHelperPurchaseCompleteNotification = Notification.Name("IAPHelperPurchaseCompleteNotification")

}

open class IAPHelper: NSObject  {
  
    private let productIdentifiers: Set<ProductIdentifier>
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
  
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
        for productIdentifier in productIds {
            if let purchased = (KeychainWrapper.standard.bool(forKey: productIdentifier)) {
                if (purchased) {
                    purchasedProductIdentifiers.insert(productIdentifier)
                }
            }
        }
        super.init()
    }

    func addStoreObserver() {
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - StoreKit API

extension IAPHelper {
  
  public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler

    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest!.delegate = self
    productsRequest!.start()
  }

  public func buyProduct(_ product: SKProduct) {
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
    
    private func savePurchaseToKeyChain(productIdentifier: String) {
        LocalProductManager.sharedInstance.restorePurchasesToKeyChain(productIdentifier: productIdentifier)
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        //failed nothing to restore!
    }
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }

    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
//        print(transactions.count)
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {

  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    
    for transaction in transactions {
      switch (transaction.transactionState) {
          case .purchased:
            complete(transaction: transaction)
            queue.finishTransaction(transaction)
            break
          case .failed:
            fail(transaction: transaction)
            queue.finishTransaction(transaction)
            break
          case .restored:
            restore(transaction: transaction)
            queue.finishTransaction(transaction)
            break
          case .deferred:
            break
          case .purchasing:
            break
          @unknown default:
            ()
        }
    }
  }

  private func complete(transaction: SKPaymentTransaction) {
    deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
    NotificationCenter.default.post(name: .IAPHelperPurchaseCompleteNotification, object: nil)
    savePurchaseToKeyChain(productIdentifier: transaction.payment.productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }

  private func restore(transaction: SKPaymentTransaction) {
    guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
    LocalProductManager.sharedInstance.restorePurchasesToKeyChain(productIdentifier: productIdentifier)
    deliverPurchaseNotificationFor(identifier: productIdentifier)
    SKPaymentQueue.default().finishTransaction(transaction)
  }

  private func fail(transaction: SKPaymentTransaction) {
    NotificationCenter.default.post(name: .IAPHelperPurchaseCancelledNotification, object: nil)

    if let transactionError = transaction.error as NSError?,
      let _ = transaction.error?.localizedDescription,
        transactionError.code != SKError.paymentCancelled.rawValue {
      }
    SKPaymentQueue.default().finishTransaction(transaction)
  }

  private func deliverPurchaseNotificationFor(identifier: String?) {
    guard let identifier = identifier else { return }
        purchasedProductIdentifiers.insert(identifier)
    }
}
