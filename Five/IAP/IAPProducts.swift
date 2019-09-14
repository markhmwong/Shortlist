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
    
    public static let proProductArray: Set = [
        IAPProducts.proId
    ]
    
//    private static let productIdentifiers: Set<ProductIdentifier> = productArray
    private static let tipProductIdentifiers: Set<ProductIdentifier> = tipProductArray
    private static let proProductIdentifiers: Set<ProductIdentifier> = proProductArray
    private static let nonConsumableProductIdentifiers: Set<ProductIdentifier> = entireNonConsumeableProductArray

    
//    public static let store = IAPHelper(productIds: IAPProducts.productIdentifiers)
    public static let tipStore = IAPHelper(productIds: IAPProducts.tipProductIdentifiers)
    public static let proStore = IAPHelper(productIds: IAPProducts.proProductIdentifiers)
    public static let restoreStore = IAPHelper(productIds: IAPProducts.nonConsumableProductIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

func resourceNameByCategory(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".")[2] // Index 2 is the category - theme, tips
}

extension IAPProducts {
//    public static let DeepMintThemeId = DeepMintTheme.productIdentifier
//    public static let OrangeId = OrangeTheme.productIdentifier
//    public static let NeutralId = NeutralTheme.productIdentifier
//    public static let WhiteId = WhiteTheme.productIdentifier
//    public static let GrapeId = GrapeTheme.productIdentifier

    public static let shortId = "com.whizbang.Everytime.tip.short"
    public static let tallId = "com.whizbang.Everytime.tip.tall"
    public static let grandeId = "com.whizbang.Everytime.tip.grande"
    
    public static let proId = "com.whizbang.Everytime.pro"
}
