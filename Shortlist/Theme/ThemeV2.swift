//
//  ThemeV2.swift
//  Shortlist
//
//  Created by Mark Wong on 14/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

struct ThemeV2 {

	//neumorphic shadows
	static let NuemorphicLightShadow: UIColor = {
		if #available(iOS 13.0, *) {
			return UIColor.init { (UITraitCollection) -> UIColor in
				switch (UITraitCollection.userInterfaceStyle) {
					case .dark, .unspecified:
						return UIColor.white.withAlphaComponent(0.4)
					case .light:
						return .white
					@unknown default:
						return .white
				}
			}
		} else {
			return .white
		}
	}()
	
	// MARK: - Cell
	struct CellProperties {
		static let LargeBoldFont: UIFont = UIFont.preferredFont(forTextStyle: .largeTitle).with(weight: .bold)
		
		static let HeadingBoldFont: UIFont = UIFont.preferredFont(forTextStyle: .headline).with(weight: .bold)

		static let HeadingFont: UIFont = UIFont.preferredFont(forTextStyle: .headline).with(weight: .regular)
		
		static let PrimaryFont: UIFont = UIFont.preferredFont(forTextStyle: .subheadline).with(weight: .regular)
		
		static let SecondaryFont: UIFont = UIFont.preferredFont(forTextStyle: .caption2).with(weight: .regular)
		
		static let Background: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return .systemGray6
						case .light:
							return .offWhite
						@unknown default:
							return .white
					}
				}
			} else {
				return .white
			}
		}()
		
		static let Border: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return .systemGray4
						case .light:
							return .offWhite
						@unknown default:
							return .white
					}
				}
			} else {
				return .white
			}
		}()
	}
	
	// MARK: - Collection Header
	struct Header {
		struct SectionHeader {
			static var Font: UIFont = UIFont.preferredFont(forTextStyle: .subheadline).with(weight: .regular)
		}
	}
	
	struct Button {
		static let BackgroundColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return .offWhite
						case .light:
							return .black
						@unknown default:
							return .offWhite
					}
				}
			} else {
				return .white
			}
		}()
		
		static let DefaultTextColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return .black
						case .light:
							return .offWhite
						@unknown default:
							return .black
					}
				}
			} else {
				return .white
			}
		}()
	}
	
	/*
	
		Colors
	
	*/
	struct ButtonColor {
		static let DonateColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return .systemOrange
						case .light:
							return .systemOrange
						@unknown default:
							return .systemOrange
					}
				}
			} else {
				return .white
			}
		}()
	}
	
	/*
	
		MARK: - Text Color
	
	*/
	struct TextColor {
		static let DefaultColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return .offWhite
						case .light:
							return .black
						@unknown default:
							return .offWhite
					}
				}
			} else {
				return .white
			}
		}()
		
		static let DefaultColorWithAlpha1: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor.white.withAlphaComponent(0.1)
						case .light:
							return .black
						@unknown default:
							return UIColor.white.withAlphaComponent(0.1)
					}
				}
			} else {
				return .white
			}
		}()
	}
	
	static let Background: UIColor = {
		if #available(iOS 13.0, *) {
			return UIColor.init { (UITraitCollection) -> UIColor in
				switch (UITraitCollection.userInterfaceStyle) {
					case .dark, .unspecified:
						return .systemGray5
					case .light:
						return .offWhite
					@unknown default:
						return .white
				}
			}
		} else {
			return .white
		}
	}()
	

	
}
