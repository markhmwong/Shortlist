//
//  IAPProducts.swift
//  Shortlist
//
//  Created by Mark Wong on 14/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//	Base on https://www.raywenderlich.com/5456-in-app-purchase-tutorial-getting-started

import Foundation

public struct IAPProducts {
    
    public static let entireNonConsumeableProductArray: Set = [
        IAPProducts.shortId,
        IAPProducts.tallId,
        IAPProducts.grandeId,
		IAPProducts.astroId,
    ]
    
    public static let tipProductArray: Set = [
        IAPProducts.shortId,
        IAPProducts.tallId,
        IAPProducts.grandeId,
		IAPProducts.astroId,
    ]

    private static let tipProductIdentifiers: Set<ProductIdentifier> = tipProductArray
    private static let nonConsumableProductIdentifiers: Set<ProductIdentifier> = entireNonConsumeableProductArray

    public static let tipStore = IAPHelper(productIds: IAPProducts.tipProductIdentifiers)
    public static let restoreStore = IAPHelper(productIds: IAPProducts.nonConsumableProductIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

extension IAPProducts {
    public static let shortId = "com.whizbang.shortlist.tip.short"
    public static let tallId = "com.whizbang.shortlist.tip.tall"
    public static let grandeId = "com.whizbang.shortlist.tip.grande"
	public static let astroId = "com.whizbang.shortlist.tip.astronomical"

	enum TipProducts {
		case small
		case medium
		case large
		case astronomical
	}
	
	// cross reference against the sections in the collection list view
	static let tipProducts: [ String : TipSections] = [
		shortId : TipSections.small,
		tallId : TipSections.medium,
		grandeId : TipSections.large,
		astroId : TipSections.astronomical
	]
}
