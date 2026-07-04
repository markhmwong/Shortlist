//
//  WelcomeViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 4/7/2026.
//  Copyright © 2026 Mark Wong. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {

    var onDismiss: (() -> Void)?

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "AppIcon") ?? UIImage(systemName: "checkmark.circle.fill")
        iv.tintColor = .label
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Shortlist 3"
        l.font = .systemFont(ofSize: 36, weight: .bold)
        l.textAlignment = .center
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Three goals.\nOne day.\nNothing more."
        l.font = .preferredFont(forTextStyle: .title3)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private let bodyLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Shortlist 3 is a complete rebuild. " +
                 "Previous tasks haven't carried over — " +
                 "today is a fresh start."
        l.font = .preferredFont(forTextStyle: .body)
        l.textColor = .tertiaryLabel
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private lazy var startButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Set my first goal"
        config.cornerStyle = .large
        config.baseBackgroundColor = .label
        config.baseForegroundColor = .systemBackground
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        isModalInPresentation = true

        [iconImageView, titleLabel, subtitleLabel, bodyLabel, startButton].forEach {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            bodyLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            bodyLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            startButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            startButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 54),
        ])
    }

    @objc private func handleStart() {
        LegacyStoreHandler.markWelcomeShown()
        dismiss(animated: true) { [weak self] in
            self?.onDismiss?()
        }
    }
}
