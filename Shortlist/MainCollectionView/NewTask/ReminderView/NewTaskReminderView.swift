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
    
    private lazy var customTimeView: UIView! = nil
    
    private lazy var presetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Preset Alarm in.."
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private var datePicker: UIDatePicker! = nil
    
    private var customTimeFlag: Bool = false
    
    private var backButton: UIButton! = nil
    
    private var saveCustomButton: UIButton! = nil
    
    var toggleView: (() -> ())! = nil
    
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

        self.addSubview(presetLabel)
        self.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        presetLabel.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: -5).isActive = true
        presetLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        
        for n in stride(from: 1, to: 8, by: 1) {
            let fifteenMinute = PresetTimersButton()
            let time = n * 15
            fifteenMinute.tag = time
            fifteenMinute.setTitle("\(time)mins", for: .normal)
            fifteenMinute.addTarget(self, action: #selector(presetTime), for: .touchDown)
            presetStackView.addArrangedSubview(fifteenMinute)
        }
        
        let custom = PresetTimersButton()
        let time = -1
        custom.tag = time
        custom.setTitle("Custom time", for: .normal)
        custom.addTarget(self, action: #selector(presetTime), for: .touchDown)
        presetStackView.addArrangedSubview(custom)
        
        scrollView.addSubview(presetStackView)
        
        presetStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        presetStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        presetStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
    }
    
    func checkIfToday() {
        
    }
    
    @objc func customTime() {
        customTimeFlag = !customTimeFlag
        
        if customTimeFlag {
            
            customTimeView = UIView()
            customTimeView.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(customTimeView)
            
            customTimeView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            customTimeView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            customTimeView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            customTimeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            
            datePicker = UIDatePicker()
            datePicker.datePickerMode = .time
            datePicker.preferredDatePickerStyle = .inline
            datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
            datePicker.backgroundColor = .clear
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            datePicker.alpha = 0
            customTimeView.addSubview(datePicker)
            
            datePicker.centerYAnchor.constraint(equalTo: customTimeView.centerYAnchor).isActive = true
            datePicker.centerXAnchor.constraint(equalTo: customTimeView.centerXAnchor).isActive = true
            
            backButton = UIButton()
            backButton.translatesAutoresizingMaskIntoConstraints = false
            backButton.setImage(UIImage(systemName: "arrow.backward.circle.fill"), for: .normal)
            backButton.addTarget(self, action: #selector(customTime), for: .touchDown)
            customTimeView.addSubview(backButton)
            
            backButton.centerYAnchor.constraint(equalTo: customTimeView.centerYAnchor).isActive = true
            
            saveCustomButton = UIButton()
            saveCustomButton.translatesAutoresizingMaskIntoConstraints = false
            saveCustomButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            saveCustomButton.addTarget(self, action: #selector(saveReminder), for: .touchDown)
            
            customTimeView.addSubview(saveCustomButton)
            
            saveCustomButton.trailingAnchor.constraint(equalTo: customTimeView.trailingAnchor).isActive = true
            saveCustomButton.centerYAnchor.constraint(equalTo: customTimeView.centerYAnchor).isActive = true
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 2, options: [.curveEaseInOut]) {
                self.datePicker.alpha = 1.0
                self.scrollView.alpha = 0.0
            } completion: { (state) in
                
            }
        } else {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 2, options: [.curveEaseInOut]) {
                self.datePicker.alpha = 0.0
                self.scrollView.alpha = 1.0
            } completion: { (state) in
                
            }
            removeCustomTimeView()
        }
        
    }
    
    func removeCustomTimeView() {
        datePicker.removeFromSuperview()
        datePicker = nil
        //chevron.backward.circle.fill
        
        backButton.removeFromSuperview()
        backButton = nil
        
        saveCustomButton.removeFromSuperview()
        saveCustomButton = nil
        
        customTimeView.removeFromSuperview()
        customTimeView = nil
    }
    
    @objc func saveReminder() {
        let dp = datePicker.calendar.dateComponents([.hour, .minute], from: datePicker.date)
        viewModel.tempTask.reminder = dp
        toggleView()
        customTime()
    }
    
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        let component = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        viewModel.tempTask.reminder = component
    }
    
    @objc func presetTime(_ sender: UIButton) {
        
        let buttons = presetStackView.arrangedSubviews as! [PresetTimersButton]
        for b in buttons {
            b.resetButton()
        }
        
        switch sender.tag {
            case 15:
                let c = Calendar.current.dateComponents([.hour, .minute], from: configDate(seconds: sender.tag))
                viewModel.tempTask.reminder = c
                toggleView()
            case 30:
                let c = Calendar.current.dateComponents([.hour, .minute], from: configDate(seconds: sender.tag))
                viewModel.tempTask.reminder = c
                toggleView()
            case 45:
                let c = Calendar.current.dateComponents([.hour, .minute], from: configDate(seconds: sender.tag))
                viewModel.tempTask.reminder = c
                toggleView()
            case 60:
                let c = Calendar.current.dateComponents([.hour, .minute], from: configDate(seconds: sender.tag))
                viewModel.tempTask.reminder = c
                toggleView()
            case -1:
                customTime()
            default:
                ()
        }
    }
    
    private func configDate(seconds: Int) -> Date {
        let d = Date().addingTimeInterval(TimeInterval(60 * seconds))
        return d
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
        titleLabel?.textColor = UIColor.offWhite
    }
    
    override var isHighlighted: Bool {
        didSet {
            layer.borderColor = UIColor.systemGreen.adjust(by: -60)!.cgColor
            setTitleColor(UIColor.systemGreen.adjust(by: -60), for: .normal)
            layer.backgroundColor = UIColor.systemGreen.adjust(by: -5)!.cgColor
        }
    }
    
    func resetButton() {
        layer.borderColor = UIColor.offWhite.cgColor

        titleLabel?.textColor = UIColor.offWhite
        layer.backgroundColor = UIColor.white.adjust(by: -70)!.cgColor
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
