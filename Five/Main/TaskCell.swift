//
//  TaskCell.swift
//  Five
//
//  Created by Mark Wong on 20/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell, UITextFieldDelegate {
    
    var task: Task? = nil {
        didSet {
            guard let taskName = task?.name else {
                print("didset")
                updateNameLabel(string: "Unknown name")
                return
            }
            print(taskName)
            
            addSubview(name)
            addSubview(taskButton)
            
            taskButton.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: bounds.width / 8, height: 0.0))
            name.anchorView(top: topAnchor, bottom: bottomAnchor, leading: taskButton.trailingAnchor, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)
            
            updateNameLabel(string: taskName)
        }
    }
    
    //convert to textfield
    lazy var name: UITextField = {
        let label = UITextField()
        label.delegate = self
        label.keyboardType = UIKeyboardType.default
        label.keyboardAppearance = UIKeyboardAppearance.dark
        label.textColor = UIColor.white
        label.returnKeyType = UIReturnKeyType.done
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var taskButton: TaskButton = {
        let button = TaskButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTask), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateNameLabel(string: String) {
        DispatchQueue.main.async {
            self.name.attributedText = NSAttributedString(string: "\(string)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b1).value)!])
        }
    }
    
    @objc
    func handleTask() {
        print(task?.name!)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.removeFromSuperview()
        taskButton.removeFromSuperview()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("did end")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateTask(taskNameString: textField.text!)
        textField.resignFirstResponder()
        return true
    }
    
    func updateTask(taskNameString: String) {
        task!.name = taskNameString
        CoreDataManager.shared.saveContext()
    }
}

class TaskButton: UIButton {
    
    private struct Constants {
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
    }
    
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
//        layer.cornerRadius = 10.0
    }
    
    override func draw(_ rect: CGRect) {
        //set up the width and height variables
        //for the horizontal stroke
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.height / 2, y: rect.height / 2), radius: rect.height / 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        UIColor.green.setFill()
        path.fill()
        
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        
        //create the path
        let plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = Constants.plusLineWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.move(to: CGPoint(
            x: halfWidth - halfPlusWidth,
            y: halfHeight))
        
        //add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(
            x: halfWidth + halfPlusWidth,
            y: halfHeight))
        
        //set the stroke color
        UIColor.white.setStroke()
        
        //draw the stroke
        plusPath.stroke()
    }
    
}
