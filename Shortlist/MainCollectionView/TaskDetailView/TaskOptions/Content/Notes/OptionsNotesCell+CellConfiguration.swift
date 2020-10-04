//
//  Configuration.swift
//  Shortlist
//
//  Created by Mark Wong on 2/10/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class EditNoteView: UITextView, UIContentView, UITextViewDelegate {
	
	var configuration: UIContentConfiguration
	
	lazy var textView: UITextView = {
		let view = UITextView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.text = "Unknown"
		view.textColor = ThemeV2.TextColor.DefaultColor
		view.backgroundColor = .clear
		view.isScrollEnabled = false
		view.delegate = self
		view.sizeToFit()
		return view
	}()
	
	init(config: UIContentConfiguration) {
		self.configuration = config
		super.init(frame: .zero, textContainer: nil)
		isScrollEnabled = false
		sizeToFit()
		text = "c.text A longer text to show multiline c.text A longer text to show multilinec.text A longer text to show multilinec.text A longer text to show multiline"
		addSubview(textView)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

struct OptionsNotesConfig: UIContentConfiguration {
	var text: String = "Text String"
	
	func makeContentView() -> UIView & UIContentView {
		return EditNoteView(config: self)
	}
	
	func updated(for state: UIConfigurationState) -> OptionsNotesConfig {
		return self
	}
}
