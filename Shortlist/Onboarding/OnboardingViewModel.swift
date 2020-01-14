//
//  OnboardingViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 7/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class OnboardingViewModel {

	let version: String = ApplicationDetails.shared.currentVersion()
	
	var dataSource: [ OnboardingPage ] = []
	
	let cellId: String = "onboardCellId"
	
	init() {
		//convert string to int, if previous version is higher than the current use the newest update details
		let details = OnboardingDetails.deltaLogs
		let versionAsDouble = ApplicationDetails.shared.currentVersionAsDouble()
		dataSource = details[versionAsDouble] ?? [OnboardingPage(title: "Unknown", details: "Unknown", image: "Unknown")]
	}
	
	func registerCells(_ collView: UICollectionView) {
		collView.register(OnboardingCell.self, forCellWithReuseIdentifier: "onboardCellId")
	}
	
	func cellForCollectionView(_ collView: UICollectionView, indexPath: IndexPath, coordinator: OnboardingCoordinator?) -> UICollectionViewCell {
		let cell = collView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OnboardingCell
		
		let pageDetails = dataSource[indexPath.item]
		cell.data = pageDetails
		cell.coordinator = coordinator
		if (indexPath.row == dataSource.count - 1) {
			cell.updateButton("Close")
		}
		return cell
	}
}



