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
    
    typealias AuthoisationStatus = Int
    
	override init() {
		super.init()
	}
	
	// MARK: Biometrics
	// TouchID/FaceId
	func isBiometricsAllowed() -> AuthoisationStatus {
		let context = LAContext()
		var error: NSError?
        let status = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        switch status {
        case true:
            return 3
        case false:
            return 2
        }
	}
	
	// MARK: - Camera
	func isCameraAllowed() -> AuthoisationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video).rawValue
	}
	
	// MARK: - Reminders
	func isRemindersAllowed() -> AuthoisationStatus {
        return ReminderService.getReminderAuthorizationStatus().rawValue
	}
	
	// MARK: - Photo Library
	func isPhotosAllowed() -> AuthoisationStatus {
        return PHPhotoLibrary.authorizationStatus(for: .readWrite).rawValue
	}
	
}
