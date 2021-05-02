//
//  NewTaskReminderView.swift
//  Shortlist
//
//  Created by Mark Wong on 1/5/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

class NewTaskReminderView: UIView {
    
    private var viewModel: NewTaskViewModel
    
    private lazy var presetStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(vm: NewTaskViewModel) {
        self.viewModel = vm
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.alpha = 0.0
        self.backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .time
//        datePicker.preferredDatePickerStyle = .inline
//        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
//        datePicker.backgroundColor = .clear
//        datePicker.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(datePicker)
        
//        datePicker.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        datePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        for n in stride(from: 1, to: 8, by: 1) {
            let fifteenMinute = PresetTimersButton()
            let time = n * 15
            fifteenMinute.tag = time
            fifteenMinute.setTitle("\(time)mins", for: .normal)
            fifteenMinute.addTarget(self, action: #selector(presetTime), for: .touchDown)
            presetStackView.addArrangedSubview(fifteenMinute)

        }
        
        scrollView.addSubview(presetStackView)
        
        presetStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        presetStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        presetStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        presetStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        let component = Calendar.current.dateComponents([.hour, .minute, .second], from: sender.date)
        viewModel.tempTask.reminder = component
    }
    
    @objc func presetTime(_ sender: UIButton) {
        switch sender.tag {
            case 15:
                ()
            case 30:
                ()
            case 45:
                ()
            default:
                ()
        }
    }
}

// MARK: Preset Button
class PresetTimersButton: UIButton {
    
    private var padding: UIEdgeInsets
    
    override init(frame: CGRect) {
        self.padding = UIEdgeInsets(top: 10, left: 30, bottom: -10, right: -30)
        super.init(frame: frame)
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        self.translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10.0
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.offWhite.cgColor
        layer.backgroundColor = UIColor.white.adjust(by: -70)!.cgColor
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption2).with(weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
