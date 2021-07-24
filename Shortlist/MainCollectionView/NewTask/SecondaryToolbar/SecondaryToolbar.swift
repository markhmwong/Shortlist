//
//  SecondaryToolbar.swift
//  Shortlist
//
//  Created by Mark Wong on 27/5/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

enum SelectedFeature: Int {
    case priority = 0
    case redact
    case note
    case photo
    case reminder
    case none
}

class NewTaskSecondaryToolbar: UIView {
    
    private var viewModel: NewTaskViewModel
    
    // to add
    private lazy var reminderView: NewTaskReminderView = {
        let view = NewTaskReminderView(vm: self.viewModel)
        return view
    }()
    
    private lazy var priorityView: PriorityToolbar = {
        let view = PriorityToolbar(viewModel: self.viewModel)
        return view
    }()

    private lazy var redactView: RedactToolBar = {
        let view = RedactToolBar(viewModel: self.viewModel)
        return view
    }()
    
    private lazy var noteView: NotesToolbar = {
        let view = NotesToolbar(toolbar: toolbar)
        return view
    }()
    
    private lazy var photoView: PhotoToolbar = {
        let view = PhotoToolbar()
        return view
    }()
    
    private var currFeature: SelectedFeature = .none

    private var featureDictionary: [SelectedFeature : UIView] = [:]
    
    private var toggle: Bool = false
    
    private var toolbar: UIToolbar
    
    private var textView: UITextView
    
    init(vm: NewTaskViewModel, toolbar: UIToolbar, textView: UITextView) {
        self.viewModel = vm
        self.toolbar = toolbar
        self.textView = textView
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        priorityView.translatesAutoresizingMaskIntoConstraints = false
        priorityView.alpha = 0
        self.addSubview(priorityView)
        
        featureDictionary[.priority] = priorityView
        
        priorityView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        priorityView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        priorityView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        priorityView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        redactView.translatesAutoresizingMaskIntoConstraints = false
        redactView.alpha = 0
        self.addSubview(redactView)
        featureDictionary[.redact] = redactView
        redactView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        redactView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        redactView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        redactView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        noteView.translatesAutoresizingMaskIntoConstraints = false
        noteView.alpha = 0
        self.addSubview(noteView)
        featureDictionary[.note] = noteView
        noteView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        noteView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        noteView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        noteView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        reminderView.translatesAutoresizingMaskIntoConstraints = false
        reminderView.alpha = 0
        self.addSubview(reminderView)
        featureDictionary[.reminder] = reminderView
        reminderView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        reminderView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        reminderView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        reminderView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.alpha = 0
        self.addSubview(photoView)
        featureDictionary[.photo] = photoView
        photoView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        photoView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        photoView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        photoView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}

// toggle toolbar api
extension NewTaskSecondaryToolbar {
    
    func toggleFeature(_ feature: SelectedFeature) {
        // reset current feature
        if let curr = featureDictionary[currFeature] {
            curr.alpha = 0.0
        }
                
        if let view = featureDictionary[feature] {
            // update curr feature
            currFeature = feature
            
            if let c = view as? CycleFeatureProtocol {
                c.cycleFeature()
            }
            
            self.bringSubviewToFront(view)
            
            UIView.animate(withDuration: 0.10, delay: 0.0, options: [.curveEaseInOut]) {
                view.alpha = 1.0
            } completion: { state in
                //
            }

        }
    }

}

/*
 MARK: - Protocol
 
*/

protocol CycleFeatureProtocol {
    func cycleFeature()
}

/*
 
 MARK: - Priority View
 
 */
class PriorityToolbar: UIView, CycleFeatureProtocol {
    
    private lazy var highPriorityButton: PriorityButton = {
        let button = PriorityButton(priority: .high)
        button.addTarget(self, action: #selector(updatePriority), for: .touchDown)
        return button
    }()
    
    private lazy var mediumPriorityButton: PriorityButton = {
        let button = PriorityButton(priority: .medium)
        button.addTarget(self, action: #selector(updatePriority), for: .touchDown)
        return button
    }()
    
    private lazy var lowPriorityButton: PriorityButton = {
        let button = PriorityButton(priority: .low)
        button.addTarget(self, action: #selector(updatePriority), for: .touchDown)
        return button
    }()
    
    private var viewModel: NewTaskViewModel

    init(viewModel: NewTaskViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(mediumPriorityButton)
        addSubview(lowPriorityButton)
        addSubview(highPriorityButton)
        

        mediumPriorityButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mediumPriorityButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        mediumPriorityButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        highPriorityButton.trailingAnchor.constraint(equalTo: mediumPriorityButton.leadingAnchor, constant: -10).isActive = true
        highPriorityButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        highPriorityButton.topAnchor.constraint(equalTo: mediumPriorityButton.topAnchor, constant: 0).isActive = true

        lowPriorityButton.leadingAnchor.constraint(equalTo: mediumPriorityButton.trailingAnchor, constant: 10).isActive = true
        lowPriorityButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        lowPriorityButton.topAnchor.constraint(equalTo: highPriorityButton.topAnchor, constant: 0).isActive = true

        updateButton(viewModel.tempTask.priority)
    }
    
    func updateButton(_ priority: Priority) {
//        priorityLabel.text = priority.stringValue
    }
    
    func cycleFeature() {
        
    }
    
    @objc func updatePriority(_ sender: PriorityButton) {
        self.viewModel.tempTask.priority = sender.priority
    }
}


/*
 
 MARK: - Redact View
 
 */
class RedactToolBar: UIView, CycleFeatureProtocol {
    
    private lazy var redactTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body).with(weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeV2.TextColor.DefaultColor
        return label
    }()
    
    private var viewModel: NewTaskViewModel
    
    init(viewModel: NewTaskViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(redactTypeLabel)
        
        redactTypeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        redactTypeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        self.updateLabel(viewModel.tempTask.redact)
    }
    
    private func updateLabel(_ style: RedactStyle) {
        redactTypeLabel.text = style.stringValue
    }
    
    func cycleFeature() {
        let r = viewModel.tempTask.redact
        self.redactTypeLabel.alpha = 1.0
        switch r {
            case .none:
                viewModel.tempTask.redact = .highlight
            case .highlight:
                viewModel.tempTask.redact = .star
            case .star:
                viewModel.tempTask.redact = .none
        }
        
        UIView.animate(withDuration: 1.2, delay: 0.0, options: [.curveEaseInOut]) {
            self.redactTypeLabel.alpha = 0.0
        } completion: { state in
            //
        }
        
        redactTypeLabel.text = viewModel.tempTask.redact.stringValue
    }
}


/*
 
 MARK: - Notes View
 
 */
class NotesToolbar: UIView {
    
    private lazy var notesTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "New note"
        textField.inputAccessoryView = toolbar
        return textField
    }()
    
    private var toolbar: UIToolbar
    
    init(toolbar: UIToolbar) {
        self.toolbar = toolbar
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(notesTextField)
        
        notesTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        notesTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
}

/*
 
 MARK: - Photo View
 
 */
class PhotoToolbar: UIView {
    
    private lazy var leftView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rightView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cameraButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("camera", for: .normal)
        button.setTitleColor(ThemeV2.TextColor.DefaultColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openCamera), for: .touchDown)
        return button
    }()
    
    private lazy var albumButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("album", for: .normal)
        button.setTitleColor(ThemeV2.TextColor.DefaultColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(openAlbum), for: .touchDown)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(leftView)
        addSubview(rightView)
        
        leftView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        leftView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        leftView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        leftView.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
 
        rightView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rightView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        rightView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        rightView.leadingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        rightView.addSubview(cameraButton)
        
        cameraButton.centerXAnchor.constraint(equalTo: rightView.centerXAnchor).isActive = true
        cameraButton.centerYAnchor.constraint(equalTo: rightView.centerYAnchor).isActive = true
        
        leftView.addSubview(albumButton)
        
        albumButton.centerXAnchor.constraint(equalTo: leftView.centerXAnchor).isActive = true
        albumButton.centerYAnchor.constraint(equalTo: leftView.centerYAnchor).isActive = true
        
    }
    
    @objc func openCamera() {
        // camera or album
    }
    
    @objc func openAlbum() {
        
    }
    
}

/*
 
 MARK: - Priority Button
 */
protocol ButtonToggleProtocol {
    func resetButton()
}

class PriorityButton: UIButton, ButtonToggleProtocol {

    private lazy var innerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 26.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "High"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = ThemeV2.TextColor.DefaultColor
        return label
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImage(systemName: "exclamationmark.circle.fill")
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = image
        return view
    }()
    
    private var bottomShaderView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeV2.Background.adjust(by: 10)!
        view.layer.opacity = 0.4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var priority: Priority
    
    private var gl = CAGradientLayer()
    
    private let colorTop = ThemeV2.Background.adjust(by: 10)!
    private let colorBottom = ThemeV2.Background.adjust(by: 2)!
    
    init(priority: Priority) {
        self.priority = priority
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let width: CGFloat = UIScreen.main.bounds.width * 0.18
        let height: CGFloat = width * 1.00
        
        clipsToBounds = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = self.priority.color.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 10.0
        widthAnchor.constraint(equalToConstant: width).isActive = true
        
        title.text = self.priority.stringValue
        gl.colors = [ colorTop.cgColor, colorBottom.cgColor ]
        gl.locations = [ 0.0, 0.25]
        
        innerView.isUserInteractionEnabled = false
        innerView.layer.addSublayer(gl)
        addSubview(innerView)
        addSubview(image)
        addSubview(bottomShaderView)
        addSubview(title)

        innerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        innerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        innerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        innerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        bottomShaderView.topAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        bottomShaderView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomShaderView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomShaderView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -height * 0.13).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        image.tintColor = self.priority.color
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor, constant: height * 0.21).isActive = true
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
    
    override func draw(_ rect: CGRect) {
        innerView.frame = rect.insetBy(dx: 6, dy: 6)
        gl.frame = innerView.frame
    }
    
    
}
