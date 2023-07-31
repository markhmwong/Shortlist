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
import EventKit
import UIKit
// check for the following permissions
// biometrics - done
// camera
// microphone
// calendars
// reminders
// notifications

// Not possible to change the state of permissions for the moment - 12/9/2020
class PrivacyPermissionsService: NSObject {
    
    typealias AuthorisationStatus = Int
    
    let context = LAContext()
    
    let event = EKEventStore()
    
    static let sharedService: PrivacyPermissionsService = PrivacyPermissionsService()
    
	override init() {
		super.init()
	}
	
    class func shared() -> PrivacyPermissionsService {
        return self.sharedService
    }
    
	// MARK: Biometrics
	// TouchID/FaceId
	func isBiometricsAllowed() -> AuthorisationStatus {
		
		var error: NSError?
        let status = self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        switch status {
            case true:
                return 3
            case false:
                return 2
        }
	}
    
    func checkBiometrics() {
        //must use biometrics we don't need a check
    }
	
	// MARK: - Camera
	func isCameraAllowed() -> AuthorisationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video).rawValue
	}
    
    func checkCamera() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }

	// MARK: - Reminders
	func isRemindersAllowed() -> AuthorisationStatus {
        return ReminderService.getReminderAuthorizationStatus().rawValue
	}
	
	// MARK: - Photo Library
	func isPhotosAllowed() -> AuthorisationStatus {
        return PHPhotoLibrary.authorizationStatus(for: .readWrite).rawValue
	}
    
    func checkAlbum() -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func checkCalendar() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
    }
    
    func checkReminder() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .reminder)
    }
    
    func isCalendarAllowed() {
        event.requestAccess(to: .event) { granted, err in
            
        }
    }
}

extension PrivacyPermissionsService {
    func requestCameraAuthorisation(_ completionHandler: @escaping () -> ()) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                completionHandler()
            } else {
                self.goToAppPrivacySettings()
            }
        }
    }

    func requestAlbumAuthorisation(_ completionHandler: @escaping (PHAuthorizationStatus) -> ()) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                completionHandler(status)
        }
    }
    
    func requestEventAuthorisation(_ completionHandler: @escaping () -> ()) {
        self.event.requestAccess(to: .event) { granted, err in
            if granted {
                completionHandler()
            } else {
                self.goToAppPrivacySettings()
            }
        }
    }
    
    func requestReminderAuthorisation(_ completionHandler: @escaping () -> ()) {
        self.event.requestAccess(to: .reminder) { granted, err in
            if granted {
                completionHandler()
            } else {
                self.goToAppPrivacySettings()
            }
        }
    }
}

// MARK: Call app permissions in Settings
extension PrivacyPermissionsService {
    func goToAppPrivacySettings() {
        DispatchQueue.main.async {
            guard let url = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(url) else {
                    assertionFailure("Not able to open App privacy settings")
                    return
            }

            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
