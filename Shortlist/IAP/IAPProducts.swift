//
//  IAPProducts.swift
//  EveryTime
//
//  Created by Mark Wong on 14/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

public struct IAPProducts {
    
    public static let entireNonConsumeableProductArray: Set = [
        IAPProducts.shortId,
        IAPProducts.tallId,
        IAPProducts.grandeId,
    ]
    
    public static let tipProductArray: Set = [
        IAPProducts.shortId,
        IAPProducts.tallId,
        IAPProducts.grandeId,
    ]

    private static let tipProductIdentifiers: Set<ProductIdentifier> = tipProductArray
    private static let nonConsumableProductIdentifiers: Set<ProductIdentifier> = entireNonConsumeableProductArray

    public static let tipStore = IAPHelper(productIds: IAPProducts.tipProductIdentifiers)
    public static let restoreStore = IAPHelper(productIds: IAPProducts.nonConsumableProductIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

func resourceNameByCategory(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".")[2] // Index 2 is the category - theme, tips
}

extension IAPProducts {
    public static let shortId = "com.whizbang.shortlist.tip.short"
    public static let tallId = "com.whizbang.shortlist.tip.tall"
    public static let grandeId = "com.whizbang.shortlist.tip.grande"
}
