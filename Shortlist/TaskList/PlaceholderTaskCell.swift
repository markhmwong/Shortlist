//
//  PlaceholderTaskCell.swift
//  Shortlist
//
//  Created by Mark Wong on 4/7/2026.
//  Copyright © 2026 Mark Wong. All rights reserved.
//

import UIKit
import WhizUtilKit

final class PlaceholderTaskCell: BaseCollectionViewCell<Int> {

    private lazy var addLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+ Add a goal"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        return label
    }()

    override func setupViewsIfNeeded() {
        super.setupViewsIfNeeded()
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.separator.cgColor
        contentView.backgroundColor = .systemBackground

        contentView.addSubview(addLabel)
        NSLayoutConstraint.activate([
            addLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            addLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }

    override func configureCell(with item: Int) { }
}
