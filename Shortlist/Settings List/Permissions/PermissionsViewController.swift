//
//  PermissionsViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 12/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import PhotosUI

class PermissionsViewController: UIViewController, UICollectionViewDelegate {
	
//	private let privacyService = PrivacyPermissionsService()
	
	private var viewModel: PermissionsViewModel
	
    private var permissions: PrivacyPermissionsService = PrivacyPermissionsService()
    
	private lazy var tableView: BaseCollectionView = {
		let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createListLayout(appearance: .insetGrouped, separators: true, header: false, headerElementKind: ""))
		view.delegate = self
		return view
	}()
	
	init(viewModel: PermissionsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = ThemeV2.Background
		navigationItem.title = "Permissions"
		view.addSubview(tableView)
		
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		
		viewModel.configureDiffableDataSource(collectionView: tableView)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PermissionsCell
        
        let type = cell.permissionType()
        
        switch type {
        case .photoLibrary:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [unowned self] (status) in
                DispatchQueue.main.async { [unowned self] in
                    //showUI(for: status)
                    self.permissions.goToAppPrivacySettings()
                }
            }
        case .camera:
            switch self.permissions.checkCamera() {
                case .authorized: // The user has previously granted access to the camera.
                    self.permissions.goToAppPrivacySettings()
                case .notDetermined, .denied, .restricted: // The user has not yet been asked for camera access.
                    self.permissions.requestCameraAuthorisation {
                        // refresh ui once access has been granted
                        DispatchQueue.main.async {
                            self.viewModel.configureDiffableDataSource(collectionView: self.tableView)
                        }
                    }
                @unknown default:
                    self.permissions.goToAppPrivacySettings()
            }
        case .biometric:
            ()
        case .reminder:
            ()
        }
	}
}

