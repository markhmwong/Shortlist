//
//  MainTaskCell.swift
//  Shortlist
//
//  Created by Mark Wong on 12/6/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - Task Cell Version 2
class MainTaskCell: UICollectionViewCell {
    
    private let completeText: String = "Complete"
    
    private let incompleteText: String = "Incomplete"
    
    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.text = "High"
        label.textColor = ThemeV2.TextColor.DefaultColorWithAlpha1
        label.font = ThemeV2.CellProperties.Title1Black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layoutMargins = .zero
        label.alpha = 0.7
        return label
    }()
    
    lazy var completeStatus: UIImageView = {
        let config = UIImage.SymbolConfiguration(font: ThemeV2.CellProperties.Title2Regular)
        let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        let view = UIImageView(image: image)
        view.tintColor = UIColor.systemGreen.darker(by: 0)!
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category • Complete"
        label.textColor = ThemeV2.TextColor.DefaultColorWithAlpha1
        label.font = ThemeV2.CellProperties.SecondaryFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layoutMargins = .zero
        label.alpha = 0.7
        return label
    }()
    
    private lazy var taskNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = ThemeV2.TextColor.DefaultColor
        label.font = ThemeV2.CellProperties.Title1Black //changed dynamically, not controlled here
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layoutMargins = .zero
        return label
    }()
    
    private lazy var featureStack: TaskFeatureIcons = TaskFeatureIcons(frame: .zero)

    private var viewConstraintCheck: NSLayoutConstraint? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewsIfNeeded() {
        guard viewConstraintCheck == nil else { return }
        let lateralPadding: CGFloat = 25.0
        let topAndBottomPadding: CGFloat = 0.0

        backgroundColor = .blue
        layer.cornerRadius = 40.0
        clipsToBounds = false
        layer.borderWidth = 0.0
        layer.borderColor = ThemeV2.CellProperties.Border.cgColor
        
//        contentView.backgroundColor = .clear
        
        let bg = UIView()
        bg.backgroundColor = ThemeV2.Background
        backgroundView = bg

//        // neumorphic
//
        let cornerRadius: CGFloat = 15
        let shadowRadius: CGFloat = 2

        let darkShadow = CALayer()
        darkShadow.frame = bounds
        darkShadow.backgroundColor = ThemeV2.Background.cgColor
        darkShadow.shadowColor = UIColor(red: 0.87, green: 0.89, blue: 0.93, alpha: 1.0).cgColor
        darkShadow.cornerRadius = cornerRadius
        darkShadow.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = shadowRadius
        backgroundView?.layer.insertSublayer(darkShadow, at: 0)

        let lightShadow = CALayer()
        lightShadow.frame = bounds
        lightShadow.backgroundColor = ThemeV2.Background.cgColor
        lightShadow.shadowColor = UIColor.white.cgColor
        lightShadow.cornerRadius = cornerRadius
        lightShadow.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = shadowRadius
        backgroundView?.layer.insertSublayer(lightShadow, at: 0)
        print(bounds)

        contentView.addSubview(taskNameLabel)
        contentView.addSubview(priorityLabel)
//        contentView.addSubview(categoryLabel)
        contentView.addSubview(completeStatus)

//        priorityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topAndBottomPadding).isActive = true
//        priorityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: lateralPadding).isActive = true
//        priorityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//
//        viewConstraintCheck = taskNameLabel.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor, constant: 0.0)
//        viewConstraintCheck?.isActive = true
//        taskNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: lateralPadding).isActive = true
//        taskNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -55).isActive = true
//
//
//        completeStatus.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        completeStatus.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -lateralPadding).isActive = true
    }
    
//    override func updateConfiguration(using state: UICellConfigurationState) {
//        setupViewsIfNeeded()
//
//        guard state.taskItem != nil else {
//
//            return
//        }
//
//        if (state.taskItem?.redactionStyle()) != nil {
//            /// Path for 2.0 shortlist users
//            // Category label
//
////            categoryLabel.attributedText = state.taskItem?.redactedText(with:"Category • \(completionText(state.taskItem?.complete ?? false)) • \(reminderText(state.taskItem))")
////            categoryLabel.attributedText = state.taskItem?.redactedText(with:"Category • \(priorityText(Priority(rawValue: state.taskItem?.priority ?? 0) ?? .low)) • \(reminderText(state.taskItem))")
//            priorityLabel.attributedText = state.taskItem?.redactedText(with:"\(priorityText(Priority(rawValue: state.taskItem?.priority ?? 0) ?? .low))")
//
//            // Content label
//            // apply redaction style to font
//            taskNameLabel.attributedText = state.taskItem?.redactedText(with: state.taskItem?.name ?? "None")
//
//            if let priority = Priority.init(rawValue: state.taskItem?.priority ?? 0) {
//                // text size
//                switch priority {
//                    case .high:
//                        taskNameLabel.font = ThemeV2.Priority.HighPriorityFont
//
//                    case .medium:
//                        taskNameLabel.font = ThemeV2.Priority.MediumPriorityFont
//                    case .low:
//                        taskNameLabel.font = ThemeV2.Priority.LowPriorityFont
//                    default:
//                        taskNameLabel.font = ThemeV2.Priority.HighPriorityFont
//                }
//                priorityLabel.textColor = priority.color
//            }
//        } else {
//            /// A path for pre-2.0 Shortlist users where redaction was not a feature.
//
//            // Category label
////            categoryLabel.text = "Category • Complete"
//
//            // Priority Label
//            priorityLabel.text = "Unknown"
//
//            // Content label
//            taskNameLabel.text = state.taskItem?.name ?? "None"
//        }
//
//        completeStatus.tintColor = state.taskItem?.complete ?? false ? UIColor.systemGreen : UIColor.systemGray
//
//    }
    
    func completionText(_ state: Bool) -> String {
        if (state) {
            return completeText
        } else {
            return incompleteText
        }
    }
    
    func reminderText(_ task: Task?) -> String {
        if let reminderDate = task?.taskToReminder?.reminder {
            return "\(reminderDate.timeToStringInHrMin())"
        } else {
            return ""
        }
    }
    
    func priorityText(_ priority: Priority) -> String {
        return priority.stringValue
    }
}
