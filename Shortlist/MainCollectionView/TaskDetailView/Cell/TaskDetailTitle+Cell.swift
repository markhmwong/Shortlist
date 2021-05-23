//
//  TaskDetailTitle+Cell.swift
//  Shortlist
//
//  Created by Mark Wong on 4/4/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - Title Cell
class TaskDetailTitleCell: BaseCollectionViewCell<TitleItem>, TaskDetailAnimation {
    
    // private variables
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeV2.CellProperties.Title1Black
        label.textColor = ThemeV2.TextColor.DefaultColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.alpha = 1.0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var priorityLabel: PaddedLabel = {
        let label = PaddedLabel(xPadding: 20, yPadding: 10)
        label.font = ThemeV2.CellProperties.TertiaryFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.alpha = 1.0
        label.textAlignment = .center
        label.textColor = ThemeV2.TextColor.DefaultColor
        return label
    }()
    
    // public variables
    var editClosure: (() -> ())? = nil
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViewAdditionalViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewAdditionalViews() {
//        backgroundColor = UIColor.lightGray.adjust(by: 40)!
        // layout cell details
        let padding: CGFloat = 40.0
        let yPadding: CGFloat = 50.0
                
        contentView.addSubview(bodyLabel)
        contentView.addSubview(priorityLabel)

        priorityLabel.bottomAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: -10.0).isActive = true
        priorityLabel.leadingAnchor.constraint(equalTo: bodyLabel.leadingAnchor).isActive = true
        priorityLabel.trailingAnchor.constraint(equalTo: bodyLabel.trailingAnchor).isActive = true

        bodyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: yPadding).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 20).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -yPadding).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding).isActive = true
    }
    
    func animate() {
        self.bodyLabel.alpha = 0.3
        self.bodyLabel.transform = CGAffineTransform(translationX: 40, y: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0.15, options: [.curveEaseInOut, .preferredFramesPerSecond60]) {
            self.bodyLabel.alpha = 1.0
            self.bodyLabel.transform = CGAffineTransform(translationX: 0, y: 0) // origin
        } completion: { (_) in }
    }
    
    override func configureCell(with item: TitleItem) {
        bodyLabel.text = item.title
        
        // change priority visuals to reflect the priority level
        let priority = item.priority
        priorityLabel.textColor = priority.color
        priorityLabel.text = priority.stringValue
        
        switch priority {
            case .high:
                priorityLabel.font = ThemeV2.CellProperties.TertiaryBoldFont
                priorityLabel.alpha = 1.0
            case .medium:
                priorityLabel.alpha = 0.8
            case .low:
                priorityLabel.alpha = 0.65
            case .none:
                priorityLabel.textColor = UIColor.gray
        }
    }
}
