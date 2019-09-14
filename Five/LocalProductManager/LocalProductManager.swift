//
//  LocalProductManager.swift
//  Five
//
//  Created by Mark Wong on 14/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

class LocalProductManager {
    
    static let sharedInstance = LocalProductManager()
    
    private init() {
        
    }
    
    // Sets purchase state to true locally
    func restorePurchasesToKeyChain(productIdentifier: String) {
        KeychainWrapper.standard.set(true, forKey: productIdentifier)
    }
    
}
