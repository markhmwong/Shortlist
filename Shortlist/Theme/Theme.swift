//
//  UIColor+Theme.swift
//  ReadyPlayer
//
//  Created by Mark Wong on 29/6/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

struct Theme {
    
    struct Font {
        static var Regular: String = "AvenirNext-Medium"
        static var Bold: String = "Avenir-Black"
		static var TitleRegular: String = "Georgia"
		static var TitleBold: String = "Georgia-Bold"
		
		static let Warning: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return .red
						case .light:
							return .red
						@unknown default:
							return .red
					}
				}
			} else {
				return .red
			}
		}()
		
		static let Placeholder: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor.white.adjust(by: 40.0)!
						case .light:
							return UIColor.black.adjust(by: 40.0)!
						@unknown default:
							return UIColor.white.adjust(by: 40.0)!
					}
				}
			} else {
				return UIColor.white.adjust(by: 40.0)!
			}
		}()
		
		static let DefaultColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return .white
						case .light:
							return .black
						@unknown default:
							return .white
					}
				}
			} else {
				return .white
			}
		}()
		
		static let FadedColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor.white.adjust(by: -40.0)!
						case .light:
							return UIColor.black.adjust(by: 40.0)!
						@unknown default:
							return UIColor.white.adjust(by: -40.0)!
					}
				}
			} else {
				return UIColor.white.adjust(by: -40.0)!
			}
		}()
		
        enum StandardSizes: CGFloat {
            //title sizes
            case h0 = 50.0
            case h1 = 30.0
            case h2 = 26.0
            case h3 = 24.0
            case h4 = 20.0
			case h5 = 18.0
            //body sizes
            case b0 = 15.0
            case b1 = 14.0
            case b2 = 12.0
            case b3 = 11.0
			case b4 = 10.0
			case b5 = 8.0
        }
        
        enum FontSize {
            case Standard(StandardSizes)
            case Custom(CGFloat)
            
            var value: CGFloat {
                switch self {
                case .Standard(let size):
                    switch UIDevice.current.screenType.rawValue {
                    case UIDevice.ScreenType.iPhones_5_5s_5c_SE.rawValue:
                        return size.rawValue * 0.8
                    case UIDevice.ScreenType.iPhoneXSMax.rawValue, UIDevice.ScreenType.iPhoneXR.rawValue:
                        return size.rawValue * 1.2
                    case UIDevice.ScreenType.iPad97.rawValue:
                        return size.rawValue * 1.2
                    case UIDevice.ScreenType.iPadPro129.rawValue, UIDevice.ScreenType.iPadPro105.rawValue, UIDevice.ScreenType.iPadPro11.rawValue:
                        return size.rawValue * 1.4
                    default:
                        return size.rawValue
                    }
                case .Custom(let customSize):
                    return customSize
                }
            }
        }
    }
    
    struct Cell {

		static let categoryBackground: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor.black.adjust(by: 40)!
						case .light:
							return UIColor.white.adjust(by: -10)!
						@unknown default:
							return UIColor.black.adjust(by: 40)!
					}
				}
			} else {
				return .black
			}
		}()
		
		static let background: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return .black
						case .light:
							return .white
						@unknown default:
							return .black
					}
				}
			} else {
				return .black
			}
		}()

		static let text: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:0.91, green:0.53, blue:0.04, alpha:1.0)
						case .light:
							return UIColor(red:0.91, green:0.53, blue:0.04, alpha:1.0)
						@unknown default:
							return UIColor(red:0.91, green:0.53, blue:0.04, alpha:1.0)
					}
				}
			} else {
				return UIColor(red:0.91, green:0.53, blue:0.04, alpha:1.0)
			}
		}()
		
		static let textFieldBackground: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor.black.adjust(by: 3)!
						case .light:
							return UIColor.white.adjust(by: -3)!
						@unknown default:
							return UIColor.black.adjust(by: 3)!
					}
				}
			} else {
				return UIColor.black.adjust(by: 3)!
			}
		}()
		static let idle: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return .green
						case .light:
							return .green
						@unknown default:
							return .green
					}
				}
			} else {
				return .green
			}
		}()
		
		static let inProgress: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return .yellow
						case .light:
							return .yellow
						@unknown default:
							return .yellow
					}
				}
			} else {
				return .yellow
			}
		}()
		static let taskCompleteColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
						case .light:
							return UIColor(red:0.05, green:0.05, blue:0.05, alpha:1.0)
						@unknown default:
							return UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
					}
				}
			} else {
				return UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
			}
		}()
		
		static let highlighted: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:0.26, green:0.75, blue:0.46, alpha:0.8)
						case .light:
							return UIColor(red:0.26, green:0.75, blue:0.46, alpha:0.8)
						@unknown default:
							return UIColor(red:0.26, green:0.75, blue:0.46, alpha:0.8)
					}
				}
			} else {
				return UIColor(red:0.26, green:0.75, blue:0.46, alpha:0.8)
			}
		}()
		
		static let iconColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:0.23, green:0.70, blue:0.89, alpha:1.0).adjust(by: 0.0)!
						case .light:
							return UIColor(red:0.23, green:0.70, blue:0.89, alpha:1.0).adjust(by: -10.0)!
						@unknown default:
							return UIColor(red:0.23, green:0.70, blue:0.89, alpha:1.0).adjust(by: 0.0)!
					}
				}
			} else {
				return UIColor(red:0.23, green:0.70, blue:0.89, alpha:1.0).adjust(by: 0.0)!
			}
		}()
    }
    
	struct ProgressBar {
		static let trackColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor.black.adjust(by: 10)!
						case .light:
							return UIColor.white.adjust(by: -10)!
						@unknown default:
							return UIColor.black.adjust(by: 10)!
					}
				}
			} else {
				return UIColor.black
			}
		}()
	}
	
    struct GeneralView {
		static let textFieldBackground: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor.black.adjust(by: 10)!
						case .light:
							return UIColor.white.adjust(by: -10)!
						@unknown default:
							return UIColor.black.adjust(by: 10)!
					}
				}
			} else {
				return UIColor.black
			}
		}()
		
		static let background: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor.black
						case .light:
							return UIColor.white
						@unknown default:
							return UIColor.black
					}
				}
			} else {
				return UIColor.black
			}
		}()
		
		static let headerBackground: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor.black
						case .light:
							return UIColor.white
						@unknown default:
							return UIColor.black
					}
				}
			} else {
				return UIColor.black
			}
		}()
    }
	
	struct Button {
		
		static let backgroundColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
						case .light:
							return UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
						@unknown default:
							return UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
					}
				}
			} else {
				return UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
			}
		}()
		
		static let textColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor.black
						case .light:
							return UIColor.black
						@unknown default:
							return UIColor.black
					}
				}
			} else {
				return UIColor.black
			}
		}()
		
		static let cornerRadius: CGFloat = 15.0
		
		static let donationButtonBackgroundColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:0.23, green:0.70, blue:0.89, alpha:1.0)
						case .light:
							return UIColor(red:0.23, green:0.70, blue:0.89, alpha:1.0)
						@unknown default:
							return UIColor(red:0.23, green:0.70, blue:0.89, alpha:1.0)
					}
				}
			} else {
				return UIColor(red:0.23, green:0.70, blue:0.89, alpha:1.0)
			}
		}()
	}
	
	struct Chart {
		static let lineTaskCompleteColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:0.00, green:0.82, blue:1.00, alpha:1.0)
						case .light:
							return UIColor(red:0.00, green:0.82, blue:1.00, alpha:1.0)
						@unknown default:
							return UIColor(red:0.00, green:0.82, blue:1.00, alpha:1.0)
					}
				}
			} else {
				return UIColor(red:0.00, green:0.82, blue:1.00, alpha:1.0)
			}
		}()
		
		static let lineTaskIncompleteColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:1.00, green:0.24, blue:0.00, alpha:1.0).adjust(by: 0.0)!
						case .light:
							return UIColor(red:1.00, green:0.24, blue:0.00, alpha:1.0).adjust(by: 0.0)!
						@unknown default:
							return UIColor(red:1.00, green:0.24, blue:0.00, alpha:1.0).adjust(by: 0.0)!
					}
				}
			} else {
				return UIColor(red:1.00, green:0.24, blue:0.00, alpha:1.0).adjust(by: 0.0)!
			}
		}()
		
		static let chartLineColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.8)
						case .light:
							return UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.8)
						@unknown default:
							return UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.8)
					}
				}
			} else {
				return UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.8)
			}
		}()
		
		static let meanLineColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.8)
						case .light:
							return UIColor(red:0.15, green:0.15, blue:0.15, alpha:0.8)
						@unknown default:
							return UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.8)
					}
				}
			} else {
				return UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.8)
			}
		}()
		
		static let chartTitleColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
						case .light:
							return UIColor(red:0.05, green:0.05, blue:0.05, alpha:0.8)
						@unknown default:
							return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
					}
				}
			} else {
				return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
			}
		}()
		
		static let chartBackgroundColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor.init { (UITraitCollection) -> UIColor in
					switch (UITraitCollection.userInterfaceStyle) {
						case .dark, .unspecified:
							return UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
						case .light:
							return UIColor(red:0.99, green:0.99, blue:0.99, alpha:1.0)
						@unknown default:
							return UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
					}
				}
			} else {
				return UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.0)
			}
		}()
	}
	
	struct Priority {
		
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
							return UIColor(red:0.35, green:0.53, blue:0.82, alpha:1.0).adjust(by: -15.0)!
						case .light:
							return UIColor(red:0.35, green:0.53, blue:0.82, alpha:1.0).adjust(by: -15.0)!
						@unknown default:
							return UIColor(red:0.35, green:0.53, blue:0.82, alpha:1.0).adjust(by: -15.0)!
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
