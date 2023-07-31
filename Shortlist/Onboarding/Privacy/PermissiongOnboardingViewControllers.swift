//
//  CameraOnboarding.swift
//  Shortlist
//
//  Created by Mark Wong on 4/8/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import Foundation

import UIKit

class PermissionsOnboardingViewController: UIViewController {
    
    var nav: UINavigationController! = nil
    
    private let buttonConfiguration: UIButton.Configuration = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = UIColor.systemBlue
        config.buttonSize = .large
        config.title = "Allow"
        return config
    }()
    
    private lazy var allow: UIButton = {
        let button = UIButton(configuration: self.buttonConfiguration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(allowHandler), for: .touchDown)
        return button
    }()
    
    private lazy var disallow: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Not now", for: .normal)
        button.addTarget(self, action: #selector(dismissHandler), for: .touchDown)
        return button
    }()
    
    private let imageView: UIImageView
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "description"
        label.font = ThemeV2.CellProperties.PrimaryFont
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var assuranceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rest assured, Shortlist does not read any data for further analysis or knowingly send it to 3rd party companies. You may also reverse this activity within Shortlists' Settings > Permissions."
        label.font = ThemeV2.CellProperties.TertiaryFont
        label.numberOfLines = 0
        label.textAlignment = .center
        label.alpha = 0.85
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = ThemeV2.CellProperties.Title1Black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.alpha = 0.85
        return label
    }()
    
    init(imageStr: String, descriptionStr: String, title: String, nav: UINavigationController) {
        self.imageView = UIImageView(image: UIImage(systemName: imageStr))
        self.nav = nav
        super.init(nibName: nil, bundle: nil)
        descriptionLabel.text = descriptionStr
        self.allow.configuration?.title = "Allow \(title)"
        self.titleLabel.text = "\(title)"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.tintColor = .systemBlue
        view.backgroundColor = ThemeV2.Background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sidePaddingRatio: CGFloat = 0.06
        view.addSubview(allow)
        view.addSubview(disallow)
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
        view.addSubview(assuranceLabel)
        view.addSubview(titleLabel)
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.width / 3).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.24).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: UIScreen.main.bounds.width * 0.14).isActive = true //spacer
        descriptionLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width * sidePaddingRatio ).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIScreen.main.bounds.width * sidePaddingRatio ).isActive = true

        allow.topAnchor.constraint(equalTo: assuranceLabel.bottomAnchor, constant: UIScreen.main.bounds.width * 0.18).isActive = true //spacer
        allow.centerXAnchor.constraint(equalTo: descriptionLabel.centerXAnchor).isActive = true
        
        disallow.topAnchor.constraint(equalTo: allow.bottomAnchor, constant: 20).isActive = true
        disallow.centerXAnchor.constraint(equalTo: allow.centerXAnchor).isActive = true
        
        assuranceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15).isActive = true
        assuranceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        assuranceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width * sidePaddingRatio ).isActive = true
        assuranceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIScreen.main.bounds.width * sidePaddingRatio ).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.width * 0.14).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateAddTaskButton()
    }
    
    @objc func dismissHandler() {
        nav.dismiss(animated: true, completion: nil)
    }
    
    @objc func allowHandler() {
        
    }
    
    private func animateAddTaskButton() {
        UIView.animate(withDuration: 2.1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: [.repeat, .curveLinear, .preferredFramesPerSecond60, .allowUserInteraction], animations: {
            self.imageView.layer.opacity = 0.8
            self.imageView.tintColor = .systemBlue
        }, completion: { state in
            self.imageView.layer.opacity = 1.0
        })
    }
}

/*
 
 MARK: Viewcontrollers
 
 */

class BiometricsPermissionsViewController: PermissionsOnboardingViewController {
    init(nav: UINavigationController) {
        //touchid depending on phone
        super.init(imageStr: "faceid", descriptionStr: "To reveal redacted tasks Shortlist requires your permission to use iPhone's biometrics such as Touch Id/Face Id to reveal a redact task.", title: "Face Id/Touch Id", nav: nav)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func dismissHandler() {
        print("dismiss Biometrics")
    }
    
    override func allowHandler() {
        print("allow biometrics")
    }
}

/*
 
 MARK: Reminder ViewController
 
 */
class RemindersPermissionsViewController: PermissionsOnboardingViewController {
    
    private var permissions: PrivacyPermissionsService = PrivacyPermissionsService.shared()

    init(nav: UINavigationController) {
        super.init(imageStr: "alarm.fill", descriptionStr: "Would you like to allow Shortlist to reminder you with alarms.", title: "Reminders", nav: nav)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // dismiss uses default function
    
    override func allowHandler() {
        print("allow reminders")
        permissions.requestReminderAuthorisation {
            DispatchQueue.main.async {
                self.nav.dismiss(animated: true, completion: nil)
                print("to do show event")
            }
        }
    }
}

/*
 
 MARK: Notification ViewController
 
 */
class NotificationsPermissionsViewController: PermissionsOnboardingViewController {
    init(nav: UINavigationController) {
        super.init(imageStr: "app.badge.fill", descriptionStr: "Would you like to allow Shortlist to send you local notifications. You may have allowed Reminders.", title: "Notifications", nav: nav)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func allowHandler() {
        print("allow notifications")
    }
}

/*
 
 MARK: Calendar ViewController
 
 */

class CalendarPermissionsViewController: PermissionsOnboardingViewController {

    init(nav: UINavigationController) {
        super.init(imageStr: "calendar", descriptionStr: "You can draw tasks from the Calendar App. Would you like Shortlist to read from your Calendar?", title: "Calendar", nav: nav)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func allowHandler() {
        print("allow calendar")
    }
}

/*
 
 MARK: Event ViewController
 
 */
class EventPermissionsViewController: PermissionsOnboardingViewController {
        
    private var permissions: PrivacyPermissionsService = PrivacyPermissionsService.shared()
    
    init(nav: UINavigationController) {
        super.init(imageStr: "calendar.circle.fill", descriptionStr: "Allow the app to set reminders.", title: "Calendar", nav: nav)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func allowHandler() {
        print("allow calendar")
        permissions.requestEventAuthorisation {
            DispatchQueue.main.async {
                self.nav.dismiss(animated: true, completion: nil)
                print("to do show event")
            }
        }
    }
}

/*
 
 MARK: Camera ViewController
 
 */
class CameraPermissionsViewController: PermissionsOnboardingViewController {
        
    private var permissions: PrivacyPermissionsService = PrivacyPermissionsService.shared()
    
    init(nav: UINavigationController) {
        
        super.init(imageStr: "camera.fill", descriptionStr: "Allow Shortlist to access the camera module to take awesome photos!", title: "Camera", nav: nav)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func allowHandler() {
        permissions.requestCameraAuthorisation {
            DispatchQueue.main.async {
                self.nav.dismiss(animated: true, completion: nil)
                print("to do show camera")
            }
        }
    }
}

/*
 
 MARK: Album ViewController
 
 */
class AlbumPermissionsViewController: PermissionsOnboardingViewController {
    
    private var permissions: PrivacyPermissionsService = PrivacyPermissionsService.shared()
    
    init(nav: UINavigationController) {
        super.init(imageStr: "person.2.crop.square.stack.fill", descriptionStr: "Allow Shortlist to access the your album, so you can select images to add your tasks", title: "Album", nav: nav)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func allowHandler() {
        permissions.requestCameraAuthorisation {
            DispatchQueue.main.async {
                self.nav.dismiss(animated: true, completion: nil)
                print("to do show album")
            }
        }
    }
}
