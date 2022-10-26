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
    private let photosView = InfoView()
    private let dayView = InfoView()
    private let solView = InfoView()
    private let upperBottomBar = UIView()
    
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
    
    private let bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let barHandle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "979797").withAlphaComponent(0.5)
        return view
    }()
    
    
    private var isBarDraggingDown = false
    private var heightConstraint: NSLayoutConstraint = .init()
    private var widthConstraint: NSLayoutConstraint = .init()
    
    private lazy var barBottomHeight: CGFloat = unitH * 90
    private lazy var bottomBarStartWidth = UIScreen.main.bounds.width - 36 * unitW
    private lazy var bottomBarUpdatedWidth = UIScreen.main.bounds.width
    
    private let unitH = UIScreen.main.bounds.height / 812
    private let unitW = UIScreen.main.bounds.width / 375
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.barHandle.layer.cornerRadius = self.barHandle.frame.height / 2
        }
    }
    
    private func configureAppearance() {
        [
            titleLabel,
            dateLabel,
        ].forEach { $0.addSystemShadows() }
        
        upperBottomBar.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                                   action: #selector(bottomBarGestureHandler(_:))))
    }
    
    private func addSubviews() {
        [
            backgroundImageContainer,
            titleLabel,
            dateLabel,
            stackView,
            bottomBar,
        ].forEach(addSubview)
        
        [
            photosView,
            dayView,
            solView,
        ].forEach(stackView.addArrangedSubview)
        
        bottomBar.addSubview(upperBottomBar)
        upperBottomBar.addSubview(barHandle)
    }
    
    private func addConstraints() {
        backgroundImageContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(unitW * 24)
            $0.leading.trailing.equalToSuperview().inset(unitW * 20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(unitW * 3)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(unitW * 27)
            $0.height.equalTo(unitW * 55)
            $0.bottom.equalTo(bottomBar.snp.top).offset(-38)
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
        
        heightConstraint = bottomBar.heightAnchor.constraint(equalToConstant: barBottomHeight)
        widthConstraint = bottomBar.widthAnchor.constraint(equalToConstant: bottomBarStartWidth)
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20),
            bottomBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            widthConstraint,
            heightConstraint,
        ])
        
        upperBottomBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        barHandle.snp.makeConstraints {
            $0.height.equalTo(6)
            $0.width.equalTo(108)
            $0.center.equalToSuperview()
        }
    }
}

extension RoverPhotosView: RoverPhotosViewProtocol {}

@objc extension RoverPhotosView {
    @objc func bottomBarGestureHandler(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let safeAreaHeight = safeAreaLayoutGuide.layoutFrame.height
            let translation = recognizer.translation(in: self)
            
            if translation.y < 0 {
                isBarDraggingDown = false
            } else {
                if (heightConstraint.constant < safeAreaHeight) {
                    isBarDraggingDown = true
                }
            }
            
            UIView.animate(withDuration: 0.25, delay: 0) {
                self.heightConstraint.constant -= translation.y
                self.layoutIfNeeded()
            }
            
            recognizer.setTranslation(.zero, in: self)
            
        case .ended:
            let barMiddleHeight: CGFloat = unitH * 473
            let barTopHeight: CGFloat = unitH * 813
            
            UIView.animate(withDuration: 0.35, delay: 0) {
                if self.heightConstraint.constant < barMiddleHeight && self.isBarDraggingDown == false {
                    self.heightConstraint.constant = barMiddleHeight
                    self.widthConstraint.constant = self.bottomBarUpdatedWidth
                    self.bottomBar.backgroundColor = .white
                } else if self.heightConstraint.constant > barMiddleHeight && self.isBarDraggingDown == false {
                    let titleLabelOriginY = self.titleLabel.frame.origin.y
                    let diff =
                        (self.safeAreaLayoutGuide.layoutFrame.size.height -  titleLabelOriginY - titleLabelOriginY / 2)
                        * self.unitH
                    self.heightConstraint.constant = diff
                    self.widthConstraint.constant = self.bottomBarUpdatedWidth
                    self.bottomBar.backgroundColor = .white
                } else if self.heightConstraint.constant < barMiddleHeight - 200 && self.isBarDraggingDown == true {
                    self.heightConstraint.constant = self.barBottomHeight
                    self.widthConstraint.constant = self.bottomBarStartWidth
                    self.bottomBar.backgroundColor = .white.withAlphaComponent(0.8)
                } else if self.heightConstraint.constant < barTopHeight && self.isBarDraggingDown == true {
                    self.heightConstraint.constant = barMiddleHeight
                    self.widthConstraint.constant = self.bottomBarUpdatedWidth
                    self.bottomBar.backgroundColor = .white
                }
                self.layoutIfNeeded()
            }
        default:
            break
        }
    }
}
