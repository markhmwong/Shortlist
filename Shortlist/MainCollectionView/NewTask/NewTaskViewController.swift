//
//  NewTaskViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 18/4/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit
import PhotosUI

class NewTaskViewController: UIViewController, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var viewModel: NewTaskViewModel
    
    private var coordinator: NewTaskCoordinator
    
    // toolbar buttons
    var priorityButton: UIBarButtonItem! = nil
    
    var redactButton: UIBarButtonItem! = nil
    
    var reminderButton: UIButton! = nil
    
    var noteButton: UIButton! = nil
    
    var photoButton: UIBarButtonItem! = nil
    
    // test
    var scribbleButton: UIButton! = nil
    
    private var taskFeatureToolbar = UIToolbar()
    
    private lazy var secondaryToolbar: NewTaskSecondaryToolbar = {
        let view = NewTaskSecondaryToolbar(vm: self.viewModel, toolbar: self.taskFeatureToolbar, textView: dataInputView)
        return view
    }()
    
    private lazy var noteView: NewTaskReminderView = {
        let view = NewTaskReminderView(vm: self.viewModel)
        return view
    }()
    
    private var keyboardHeight: CGFloat = 0
    
    private lazy var textContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 0.0
        view.backgroundColor = ThemeV2.Background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dataInputView: UITextView = {
        let textField = UITextView(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "A new task to focus on.."
        textField.font = UIFont.preferredFont(forTextStyle: .title3).with(weight: .regular)
        textField.textColor = ThemeV2.TextColor.DefaultColor
        textField.autocapitalizationType = .sentences
        textField.backgroundColor = .clear
        textField.becomeFirstResponder()
        textField.delegate = self
        return textField
    }()
    
    private lazy var characterLimit: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeV2.TextColor.DefaultColor
        label.alpha = 0.5
        label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .regular)
        return label
    }()
    
    private lazy var taskTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "What would you like to do today?"
        label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .regular)
        label.alpha = 0.5
        return label
    }()
    
    var bottomConstraint: NSLayoutConstraint! = nil
    
    var constraint: NSLayoutConstraint! = nil
    
    var heightConstraint: NSLayoutConstraint! = nil
    
    private var highItem: UIAction! = nil
    
    private var mediumItem: UIAction! = nil
    
    private var lowItem: UIAction! = nil
    
    private var highlightItem: UIAction! = nil
    
    private var astericksItem: UIAction! = nil
    
    private var noneItem: UIAction! = nil
    
    init(viewModel: NewTaskViewModel, coordinator: NewTaskCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(textContainer)
        view.addSubview(dataInputView)
        view.addSubview(characterLimit)
        view.addSubview(taskTitleLabel)
        view.addSubview(secondaryToolbar)
        
        taskTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        taskTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        
        textContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        textContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        textContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        dataInputView.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: 10).isActive = true
        dataInputView.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: 0).isActive = true
        dataInputView.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: 10).isActive = true
        dataInputView.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor, constant: -10).isActive = true

        characterLimit.topAnchor.constraint(equalTo: textContainer.topAnchor, constant: 10).isActive = true
        characterLimit.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor).isActive = true

        
        heightConstraint = secondaryToolbar.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.26)
        heightConstraint.isActive = true
        secondaryToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        secondaryToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        bottomConstraint = secondaryToolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.isActive = true
        
        // initialise text
        updateCharacterLimit()
        addKeyboardToolBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc
    func handleKeyboardNotification(_ notification : Notification?) {
        
        if let info = notification?.userInfo {
            
            let isKeyboardShowing = notification?.name == UIResponder.keyboardDidShowNotification
            
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                
                if (isKeyboardShowing) {
                    keyboardHeight = kbFrame.height
                    bottomConstraint?.constant = -kbFrame.height //reminderView.frame.height
                } else {
                    bottomConstraint?.constant = 0
                }
                
                UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseInOut, animations: { [unowned self] in
                    self.view.layoutIfNeeded()
                }) { (completed) in
                    
                }
            }
        }
    }
    
    func addBlurToViewController() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    func addKeyboardToolBar() {
        
        self.priorityMenu()
        
        self.redactMenu()
        
        let reminderImage = UIImage(systemName: "alarm")?.withRenderingMode(.alwaysTemplate)
        self.reminderButton = UIButton()
        reminderButton.tintColor = viewModel.tempTask.priority.color
        reminderButton.tag = SelectedFeature.reminder.rawValue
        reminderButton.setImage(reminderImage, for: .normal)
        reminderButton.addTarget(self, action: #selector(featureToggle), for: .touchDown)
        let reminderItem = UIBarButtonItem(customView: reminderButton)
        
        let noteImage = UIImage(systemName: "note.text")?.withRenderingMode(.alwaysTemplate)
        self.noteButton = UIButton()
        noteButton.tintColor = viewModel.tempTask.priority.color
        noteButton.tag = SelectedFeature.note.rawValue
        noteButton.setImage(noteImage, for: .normal)
        noteButton.addTarget(self, action: #selector(featureToggle), for: .touchDown)
        let noteItem = UIBarButtonItem(customView: noteButton)
        
        self.cameraMenu()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        taskFeatureToolbar.items = [flexibleSpace, priorityButton, flexibleSpace, redactButton, flexibleSpace, reminderItem, flexibleSpace, noteItem, flexibleSpace, photoButton, flexibleSpace]
        
        taskFeatureToolbar.sizeToFit()
        dataInputView.inputAccessoryView = taskFeatureToolbar
    }
    
    private func cameraMenu() {
        let cameraItem = UIAction(title: "Camera", image: UIImage(systemName: "camera.fill")) { (action) in
                 print("Camera action was tapped")
                self.presentCamera()
            }
        let albumItem = UIAction(title: "Album", image: UIImage(systemName: "photo.fill.on.rectangle.fill")) { (action) in
                 print("Album action was tapped")
                self.presentPicker(filter: PHPickerFilter.images)
            }
        let menu = UIMenu(title: "Media", options: [], children: [cameraItem , albumItem])
        let image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        self.photoButton = UIBarButtonItem(title: "Menu", image: image, primaryAction: nil, menu: menu)
        photoButton.tintColor = viewModel.tempTask.priority.color
        photoButton.tag = SelectedFeature.photo.rawValue
        
    }
    
    private func redactMenu() {
        self.noneItem = UIAction(title: "None", image: UIImage(systemName: "textformat.abc")) { (action) in
            self.noneItem.state = .on
            self.astericksItem.state = .off
            self.highlightItem.state = .off
            self.viewModel.redactSelected(redact: .none)
            self.viewModel.rebuildMenu(items: [self.noneItem, self.astericksItem, self.highlightItem], button: self.redactButton)
        }
        self.astericksItem = UIAction(title: "Astericks", image: UIImage(systemName: "staroflife.fill")) { (action) in
            self.noneItem.state = .off
            self.astericksItem.state = .on
            self.highlightItem.state = .off
            self.viewModel.redactSelected(redact: .star)
            self.viewModel.rebuildMenu(items: [self.noneItem, self.astericksItem, self.highlightItem], button: self.redactButton)
        }
        self.highlightItem = UIAction(title: "Highlight", image: UIImage(systemName: "highlighter")) { (action) in
            self.noneItem.state = .off
            self.astericksItem.state = .off
            self.highlightItem.state = .on
            self.viewModel.redactSelected(redact: .highlight)
            self.viewModel.rebuildMenu(items: [self.noneItem, self.astericksItem, self.highlightItem], button: self.redactButton)
        }
        
        self.noneItem.state = .on //default state
        
        let menu = UIMenu(title: "Redact Text", options: [], children: [noneItem , astericksItem, highlightItem] )
        let image = UIImage(systemName: "text.redaction")?.withRenderingMode(.alwaysTemplate)
        self.redactButton = UIBarButtonItem(title: "Redact", image: image, primaryAction: nil, menu: menu)
        redactButton.tintColor = viewModel.tempTask.priority.color
        redactButton.tag = SelectedFeature.photo.rawValue
        
    }


    private func priorityMenu() {
        highItem = UIAction(title: "High", image: UIImage(systemName: "1.circle.fill")) { (action) in
            self.highItem.state = .on
            self.mediumItem.state = .off
            self.lowItem.state = self.mediumItem.state
            
            self.viewModel.prioritySelected(priority: .high)
            self.viewModel.rebuildMenu(items: [self.highItem, self.mediumItem, self.lowItem], button: self.priorityButton)
        }
        
        mediumItem = UIAction(title: "Medium", image: UIImage(systemName: "2.circle.fill")) { (action) in
            self.highItem.state = .off
            self.lowItem.state = self.highItem.state
            self.mediumItem.state = .on
            self.viewModel.prioritySelected(priority: .medium)
            self.viewModel.rebuildMenu(items: [self.highItem, self.mediumItem, self.lowItem], button: self.priorityButton)
        }
        
        lowItem = UIAction(title: "Low", image: UIImage(systemName: "3.circle.fill")) { (action) in
            self.highItem.state = .off
            self.lowItem.state = self.highItem.state
            self.mediumItem.state = .on
            self.viewModel.prioritySelected(priority: .low)
            self.viewModel.rebuildMenu(items: [self.highItem, self.mediumItem, self.lowItem], button: self.priorityButton)
        }

        highItem.state = .on
        let menu = UIMenu(title: "Priority", options: [], children: [highItem , mediumItem, lowItem])
        let image = UIImage(systemName: "exclamationmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
        self.priorityButton = UIBarButtonItem(title: "Priority", image: image, primaryAction: nil, menu: menu)
        priorityButton.tintColor = viewModel.tempTask.priority.color
        priorityButton.tag = SelectedFeature.photo.rawValue
        
    }

    //MARK: - Toolbar selectors
    private func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    private func presentPicker(filter: PHPickerFilter) {
        var configuration = PHPickerConfiguration()
        configuration.filter = filter
        configuration.selectionLimit = 0
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func redactToggle() {
        let r = viewModel.tempTask.redact
        var imageName = ""
        switch r {
        case .highlight:
            viewModel.tempTask.redact = .star
            imageName = "staroflife.fill"
        case .star:
            viewModel.tempTask.redact = .none
            imageName = "eye"
        case .none:
            viewModel.tempTask.redact = .highlight
            imageName = "highlighter"
        }
//        self.redactButton.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    @objc func switchPriority() {
        let p = viewModel.tempTask.priority
        switch p {
            case .high:
                viewModel.tempTask.priority = .medium
            case .medium:
                viewModel.tempTask.priority = .low
            case .low:
                viewModel.tempTask.priority = .high
            case .none:
                viewModel.tempTask.priority = .none
        }
        
        self.priorityButton.tintColor = viewModel.tempTask.priority.color
//        self.priorityButton.setImage(UIImage(systemName: "exclamationmark.circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    func addNewTask(day: Day) {
        viewModel.createTask(day: day)
    }
    
    /*
     
        MARK: - Feature Toggle
     
    */
    @objc func featureToggle(_ sender: UIButton) {
        if let feature = SelectedFeature.init(rawValue: sender.tag) {
            secondaryToolbar.toggleFeature(feature)
        }
    }
    
    
    
    /*
    
        MARK: - Image Picker
    
    */
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
                guard !results.isEmpty else { return }
        let result = results[0]
        let provider = result.itemProvider
        let state = provider.canLoadObject(ofClass: UIImage.self)
        
        if state {
            provider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let i = image as? UIImage {
//                    self.viewModel.saveImage(imageData: i)
                }
            }
        }
    }
}

extension NewTaskViewController: UITextViewDelegate {
     func updateCharacterLimit() {
        let currCount: Int = dataInputView.text.count
        let limit = (CharacterLimitConstants.titleLimit - currCount)
        formatCharacterLimit("\(limit) / \(CharacterLimitConstants.titleLimit)")
    }
    
    private func formatCharacterLimit(_ text: String) {
        characterLimit.text = text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currCount = textView.text.count + (text.count - range.length)
        if currCount <= CharacterLimitConstants.titleLimit {
            viewModel.tempTask.title = dataInputView.text
            updateCharacterLimit()
            return true
        } else {
            return false
        }
    }
}


