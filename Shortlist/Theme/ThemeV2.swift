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
        static let TertiaryBoldFont: UIFont = UIFont.preferredFont(forTextStyle: .footnote).with(weight: .bold)

		static let TertiaryFont: UIFont = UIFont.preferredFont(forTextStyle: .footnote).with(weight: .regular)
		
		static let Title3Font: UIFont = UIFont.preferredFont(forTextStyle: .title3).with(weight: .regular)

		static let LargeBoldFont: UIFont = UIFont.preferredFont(forTextStyle: .largeTitle).with(weight: .bold)
		
		static let HeadingBoldFont: UIFont = UIFont.preferredFont(forTextStyle: .headline).with(weight: .black)
		
		static let Title1Black: UIFont = UIFont.preferredFont(forTextStyle: .title1).with(weight: .bold)

		static let Title1Regular: UIFont = UIFont.preferredFont(forTextStyle: .title1).with(weight: .regular)
		
		static let Title2Regular: UIFont = UIFont.preferredFont(forTextStyle: .title2).with(weight: .regular)

		static let Title2Bold: UIFont = UIFont.preferredFont(forTextStyle: .title2).with(weight: .bold)

		static let Title2Black: UIFont = UIFont.preferredFont(forTextStyle: .title2).with(weight: .black)
		
		static let Title3Bold: UIFont = UIFont.preferredFont(forTextStyle: .title3).with(weight: .bold)
		
		static let Title3Regular: UIFont = UIFont.preferredFont(forTextStyle: .title3).with(weight: .regular)
		
		static let Title3Light: UIFont = UIFont.preferredFont(forTextStyle: .title3).with(weight: .light)

		static let HeadingFont: UIFont = UIFont.preferredFont(forTextStyle: .headline).with(weight: .regular)
		
		static let PrimaryFont: UIFont = UIFont.preferredFont(forTextStyle: .subheadline).with(weight: .regular)
		
		static let SecondaryFont: UIFont = UIFont.preferredFont(forTextStyle: .caption2).with(weight: .regular)
		
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
			static var Font: UIFont = UIFont.preferredFont(forTextStyle: .subheadline).with(weight: .bold)
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
							return .offBlack
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
							return UIColor.offWhite.withAlphaComponent(0.1)
						case .light:
							return .offWhite
						@unknown default:
							return UIColor.offWhite.withAlphaComponent(0.1)
					}
				}
			} else {
				return .white
			}
		}()
        
        static let AddANote: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.init { (UITraitCollection) -> UIColor in
                    switch (UITraitCollection.userInterfaceStyle) {
                        case .dark, .unspecified:
                            return UIColor.systemGray.adjust(by: -25)!
                        case .light:
                            return UIColor.systemGray.adjust(by: -25)!
                        @unknown default:
                            return UIColor.systemGray.adjust(by: -25)!
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
						return .offBlack
					case .light:
						return .offWhite
					@unknown default:
						return .offWhite
				}
			}
		} else {
			return .white
		}
	}()
	
	// MARK: Priority
	struct Priority {
		
        static let HighPriorityFont: UIFont = UIFont.preferredFont(forTextStyle: .largeTitle).with(weight: .regular)
		
		static let MediumPriorityFont: UIFont = UIFont.preferredFont(forTextStyle: .title3).with(weight: .regular)
		
		static let LowPriorityFont: UIFont = UIFont.preferredFont(forTextStyle: .subheadline).with(weight: .regular)
		
		static let highColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:1.00, green:0.00, blue:0.30, alpha:1.0).adjust(by: 0.0)!
						case .light:
							return UIColor(red:1.00, green:0.00, blue:0.30, alpha:1.0).adjust(by: 0.0)!
						@unknown default:
							return UIColor(red:1.00, green:0.00, blue:0.30, alpha:1.0).adjust(by: 0.0)!
					}
				}
			} else {
				return UIColor(red:1.00, green:0.00, blue:0.30, alpha:1.0).adjust(by: 0.0)!
			}
		}()
		
		static let mediumColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:0.86, green:0.50, blue:0.25, alpha:1.0).adjust(by: -10.0)!
						case .light:
							return UIColor(red:0.86, green:0.50, blue:0.25, alpha:1.0).adjust(by: -10.0)!
						@unknown default:
							return UIColor(red:0.86, green:0.50, blue:0.25, alpha:1.0).adjust(by: -10.0)!
					}
				}
			} else {
				return UIColor(red:0.86, green:0.50, blue:0.25, alpha:1.0).adjust(by: -10.0)!
			}
		}()
		
		static let lowColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:103/255, green:146/255, blue:171/255, alpha:1.0).adjust(by: -15.0)!
						case .light:
							return UIColor(red:103/255, green:146/255, blue:171/255, alpha:1.0).adjust(by: -15.0)!
						@unknown default:
							return UIColor(red:103/255, green:146/255, blue:171/255, alpha:1.0).adjust(by: -15.0)!
					}
				}
			} else {
				return UIColor(red:0.35, green:0.53, blue:0.82, alpha:1.0).adjust(by: -15.0)!
			}
		}()
		
		static let noneColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor.white.adjust(by: -30.0)!
						case .light:
							return UIColor.white.adjust(by: -30.0)!
						@unknown default:
							return UIColor.white.adjust(by: -30.0)!
					}
				}
			} else {
				return UIColor.white.adjust(by: -30.0)!
			}
		}()

	}
}
