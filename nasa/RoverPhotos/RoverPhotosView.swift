//
//  ManifestView.swift
//  nasa
//
//  Created by Danil Demchenko on 19.10.2022.
//

import UIKit

protocol RoverPhotosViewProtocol {
    var backgroundImage: UIImage? { get set }
    var manifest: Manifest! { get set }
    var photos: [RoverPhoto]! { get set }
}

final class RoverPhotosView: UIView {
    
    private let backgroundImageContainer: UIImageView = UIImageView()
            
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .getSFProDisplayBold(ofSize: 32)
        label.numberOfLines = 1
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .getSFProDisplayRegular(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let photosView = InfoView()
    private let dayView = InfoView()
    private let solView = InfoView()
    
    var manifest: Manifest! {
        didSet {
            titleLabel.text = manifest.name.uppercased()
            dateLabel.text = "launch at \(manifest.launchDateManifestString)"
            photosView.numberLabel.text = "\(manifest.totalPhotosString)"
            photosView.textLabel.text = "Photos"
            dayView.numberLabel.text = manifest.amountOfDaysString
            dayView.textLabel.text = "Day"
            solView.numberLabel.text = manifest.maxSolString
            solView.textLabel.text = "Sol"
        }
    }
    
    var backgroundImage: UIImage? {
        didSet {
            backgroundImageContainer.image = backgroundImage
        }
    }
    
    var photos: [RoverPhoto]! {
        didSet {
            print(photos)
        }
    }
    
    private let unit = UIScreen.main.bounds.width / 375
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init view")
        
        configureAppearance()
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureAppearance()
        addSubviews()
        addConstraints()
    }
    
    private func configureAppearance() {
        [
            titleLabel,
            dateLabel,
        ].forEach { $0.addSystemShadows() }
    }
    
    private func addSubviews() {
        [
            backgroundImageContainer,
            titleLabel,
            dateLabel,
            stackView,
        ].forEach(addSubview)
        
        [
            photosView,
            dayView,
            solView,
        ].forEach(stackView.addArrangedSubview)
    }
    
    private func addConstraints() {
        backgroundImageContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(unit * 24)
            $0.leading.trailing.equalToSuperview().inset(unit * 20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(unit * 3)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(unit * 27)
            $0.height.equalTo(unit * 55)
            $0.bottom.equalToSuperview().inset(100)
        }
        
        [
            photosView,
            dayView,
            solView,
        ].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(83)
            }
        }
    }
}

extension RoverPhotosView: RoverPhotosViewProtocol {}
