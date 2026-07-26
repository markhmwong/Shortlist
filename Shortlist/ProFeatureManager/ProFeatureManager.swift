//
//  ProManager.swift
//  Shortlist
//
//  Created by Mark Wong on 19/1/2025.
//  Copyright © 2025 Mark Wong. All rights reserved.
//

import Foundation
import RevenueCat

/// Source of truth for the Shortlist Pro entitlement, backed by RevenueCat.
final class ProFeatureManager: NSObject {

	static let shared: ProFeatureManager = ProFeatureManager()

	// MARK: - Constants

	// TODO: replace with the real keys from the RevenueCat dashboard (Project settings > API keys)
	// once the Shortlist project + Pro offering/entitlement have been created there.
	private var apiKey: String {
		#if DEBUG
		return "appl_REPLACE_WITH_SANDBOX_KEY"
		#else
		return "appl_REPLACE_WITH_PRODUCTION_KEY"
		#endif
	}

	/// Must match the entitlement identifier configured in the RevenueCat dashboard.
	let proEntitlementIdentifier = "Shortlist Pro"

	// MARK: - Properties

	private(set) var customerInfo: CustomerInfo?
	private(set) var isPro: Bool = false

	private override init() {
		super.init()
	}

	// MARK: - Configuration

	/// Configure the RevenueCat SDK. Call once on app launch.
	func configure() {
		#if DEBUG
		Purchases.logLevel = .debug
		#endif
		Purchases.configure(withAPIKey: apiKey)

		Task {
			await refreshCustomerInfo()
		}
	}

	// MARK: - Entitlement Status

	@MainActor
	func refreshCustomerInfo() async {
		do {
			let info = try await Purchases.shared.customerInfo()
			customerInfo = info
			updateProStatus(info)
		} catch {
			print("ProFeatureManager: failed to fetch customer info — \(error.localizedDescription)")
		}
	}

	private func updateProStatus(_ info: CustomerInfo) {
		isPro = info.entitlements[proEntitlementIdentifier]?.isActive == true
		NotificationCenter.default.post(name: .proStatusChanged, object: nil, userInfo: ["isPro": isPro])
	}

	// MARK: - Offerings & Purchases

	func fetchOfferings() async throws -> Offerings {
		try await Purchases.shared.offerings()
	}

	@discardableResult
	func purchase(package: Package) async throws -> PurchaseResultData {
		let result = try await Purchases.shared.purchase(package: package)
		if !result.userCancelled {
			await refreshCustomerInfo()
		}
		return result
	}

	@discardableResult
	func restorePurchases() async throws -> CustomerInfo {
		let info = try await Purchases.shared.restorePurchases()
		customerInfo = info
		updateProStatus(info)
		return info
	}
}

// MARK: - Notification Names

extension Notification.Name {
	static let proStatusChanged = Notification.Name("proStatusChanged")
}
