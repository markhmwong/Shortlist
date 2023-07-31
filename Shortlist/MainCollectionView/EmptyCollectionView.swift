//
//  EmptyCollectionView.swift
//  EveryTime
//
//  Created by Mark Wong on 26/5/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class EmptyCollectionView: UIView {
    
    private var delegate: MainViewController?
	
	private let fontName = Theme.Font.Regular

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeV2.CellProperties.Title2Regular
        label.textAlignment = .center
        label.alpha = 0.8
        label.numberOfLines = 0
        label.sizeToFit()
		label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let image: UIView = UIView()
	
	init(message: String) {
		super.init(frame: .zero)
        messageLabel.text = message
		self.setupView()
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
		backgroundColor = .clear
        addSubview(messageLabel)
        image.translatesAutoresizingMaskIntoConstraints = false
        addSubview(image)
        
        image.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        image.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        messageLabel.anchorView(top: topAnchor, bottom: nil, leading: nil, trailing: nil, centerY: nil, centerX: centerXAnchor, padding: UIEdgeInsets(top: UIScreen.main.bounds.height - (UIScreen.main.bounds.height / 2), left: 10.0, bottom: 0.0, right: -10.0), size: CGSize(width: UIScreen.main.bounds.width - 20.0, height: 0.0))

        
        self.buildCollage()
    }
    
    func buildCollage() {
        let globeImage = UIImage(systemName: "music.mic.circle.fill")?.withRenderingMode(.alwaysTemplate)
        let globe = UIImageView(image: globeImage)
        globe.translatesAutoresizingMaskIntoConstraints = false
        globe.tintColor = .systemIndigo.adjust(by: 40)!
        
        image.addSubview(globe)
        globe.centerXAnchor.constraint(equalTo: image.centerXAnchor, constant: -20).isActive = true
        globe.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: -130).isActive = true
        globe.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05).isActive = true
        globe.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05).isActive = true
        
        let fuelImage = UIImage(systemName: "fuelpump.circle.fill")?.withRenderingMode(.alwaysTemplate)
        let pump = UIImageView(image: fuelImage)
        pump.translatesAutoresizingMaskIntoConstraints = false
        pump.tintColor = .systemRed.adjust(by: 40)!
        
        image.addSubview(pump)
        pump.centerXAnchor.constraint(equalTo: image.centerXAnchor, constant: -50).isActive = true
        pump.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: -60).isActive = true
        pump.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.09).isActive = true
        pump.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.09).isActive = true
        
        let carFillImage = UIImage(systemName: "car.circle.fill")?.withRenderingMode(.alwaysTemplate)
        let car = UIImageView(image: carFillImage)
        car.translatesAutoresizingMaskIntoConstraints = false
        car.tintColor = .systemOrange.adjust(by: 40)!
        
        image.addSubview(car)
        car.centerXAnchor.constraint(equalTo: image.centerXAnchor, constant: -120).isActive = true
        car.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: -100).isActive = true
        car.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05).isActive = true
        car.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05).isActive = true
        
        let musicFillImage = UIImage(systemName: "music.note.tv.fill")?.withRenderingMode(.alwaysTemplate)
        let music = UIImageView(image: musicFillImage)
        music.translatesAutoresizingMaskIntoConstraints = false
        music.tintColor = .systemPurple.adjust(by: 40)!
        
        image.addSubview(music)
        music.centerXAnchor.constraint(equalTo: image.centerXAnchor, constant: 120).isActive = true
        music.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: -90).isActive = true
        music.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05).isActive = true
        music.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05).isActive = true
        
        let giftImage = UIImage(systemName: "giftcard.fill")?.withRenderingMode(.alwaysTemplate)
        let gift = UIImageView(image: giftImage)
        gift.translatesAutoresizingMaskIntoConstraints = false
        gift.tintColor = .systemBlue.adjust(by: 40)!
        
        image.addSubview(gift)
        gift.centerXAnchor.constraint(equalTo: image.centerXAnchor, constant: 40).isActive = true
        gift.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: -50).isActive = true
        gift.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05).isActive = true
        gift.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05).isActive = true
        
        let waveformImage = UIImage(systemName: "waveform.path.ecg.rectangle.fill")?.withRenderingMode(.alwaysTemplate)
        let waveform = UIImageView(image: waveformImage)
        waveform.translatesAutoresizingMaskIntoConstraints = false
        waveform.tintColor = .systemGreen.adjust(by: 40)!
        
        image.addSubview(waveform)
        waveform.centerXAnchor.constraint(equalTo: image.centerXAnchor, constant: 60).isActive = true
        waveform.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: -130).isActive = true
        waveform.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.08).isActive = true
        waveform.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.08).isActive = true
        
        let dollarImage = UIImage(systemName: "dollarsign.circle.fill")?.withRenderingMode(.alwaysTemplate)
        let dollar = UIImageView(image: dollarImage)
        dollar.translatesAutoresizingMaskIntoConstraints = false
        dollar.tintColor = .systemGray.adjust(by: 40)!
        
        image.addSubview(dollar)
        dollar.centerXAnchor.constraint(equalTo: image.centerXAnchor, constant: 100).isActive = true
        dollar.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: -30).isActive = true
        dollar.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.06).isActive = true
        dollar.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.06).isActive = true
        
        animateImage(image: dollar)
        animateImage(image: waveform)
        animateImage(image: gift)
        animateImage(image: music)
        animateImage(image: pump)
        animateImage(image: car)
        animateImage(image: globe)
    }
    
    func animateImage(image: UIImageView) {
        UIView.animate(withDuration: 1.0, delay: CGFloat.random(in: 0...1), options: [.autoreverse, .curveEaseInOut, .repeat]) {
            image.transform = CGAffineTransform(translationX: 0, y: CGFloat(Int.random(in: 2...5)))
        } completion: { state in
            image.transform = CGAffineTransform(translationX: 0, y: CGFloat(Int.random(in: 2...5)))
        }
    }
}
