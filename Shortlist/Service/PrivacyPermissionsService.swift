//
//  Privacy.swift
//  Shortlist
//
//  Created by Mark Wong on 12/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

// A service created to check for specific permission this app uses

import LocalAuthentication
import AVFoundation
import Photos
// check for the following permissions
// biometrics - done
// camera
// microphone
// calendars
// reminders
// notifications

// Not possible to change the state of permissions for the moment - 12/9/2020
class PrivacyPermissionsService: NSObject {
	
	typealias BiometricsState = Bool
		
	override init() {
		super.init()
	}
	
	// MARK: Biometrics
	// TouchID/FaceId
	func isBiometricsAllowed() -> BiometricsState {
		let context = LAContext()
		var error: NSError?
		return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
	}
	
	// MARK: - Camera
	func isCameraAllowed() -> Bool {
		let status = AVCaptureDevice.authorizationStatus(for: .video)
		switch status {
			case .authorized, .restricted:
				return true
			case .denied, .notDetermined:
				return false
			@unknown default:
				return false
		}

	}
	
	// MARK: - Reminders
	func isRemindersAllowed() -> Bool {
		let status = ReminderService.getReminderAuthorizationStatus()
		switch status {
			case .authorized, .restricted:
				return true
			case .denied, .notDetermined:
				return false
			@unknown default:
				return false
		}
	}
	
	// MARK: - Photo Library
	func isPhotosAllowed() -> Bool {
		let status = PHPhotoLibrary.authorizationStatus()
		switch status {
			case .authorized, .restricted, .limited:
				return true
			case .denied, .notDetermined:
				return false
			@unknown default:
				return false
		}
	}
	
}
