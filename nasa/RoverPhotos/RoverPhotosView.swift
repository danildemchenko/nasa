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
    
    private lazy var barCurrentHeight: CGFloat = unitH * 90
    private lazy var barCurrentWidth = UIScreen.main.bounds.width - 36 * unitW
    
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
            $0.bottom.equalTo(bottomBar.snp.top).offset(-38).priority(99)
            $0.top.greaterThanOrEqualTo(dateLabel.snp.bottom).offset(20).priority(100)
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
        
        bottomBar.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(barCurrentWidth)
            $0.height.equalTo(barCurrentHeight)
        }
        
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
        let barMiddleHeight: CGFloat = unitH * 473
        let barMinHeight: CGFloat = unitH * 90
        let barMaxHeight: CGFloat = unitH * 813
        let barMaxWidth = UIScreen.main.bounds.width
        let barMinWidth = UIScreen.main.bounds.width - 36 * unitW
        let middleHeighBorder = barMiddleHeight - 200
        
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: self)
     
            if translation.y < 0 {
                isBarDraggingDown = false
            } else {
                if (barCurrentHeight < barMaxHeight) {
                    isBarDraggingDown = true
                }
            }
            
            UIView.animate(withDuration: 0.25, delay: 0) {
                self.bottomBar.backgroundColor = .white
                self.barCurrentHeight -= translation.y
                
                if self.barCurrentHeight < barMiddleHeight {
                    self.barCurrentWidth -= translation.y / 4
                    self.barCurrentWidth = min(max(self.barCurrentWidth, barMinWidth), barMaxWidth)
                }
        
                self.bottomBar.snp.updateConstraints {
                    $0.height.equalTo(self.barCurrentHeight)
                    $0.width.equalTo(self.barCurrentWidth)
                }
                self.layoutIfNeeded()
            }
            
            recognizer.setTranslation(.zero, in: self)
            
        case .ended:
            if (self.barCurrentHeight < barMaxHeight &&
                self.barCurrentHeight > middleHeighBorder &&
                isBarDraggingDown == true) ||
                (self.barCurrentHeight < barMiddleHeight && isBarDraggingDown == false) {
                    self.barCurrentHeight = barMiddleHeight
                    self.updateBar(height: barCurrentHeight)
            } else if barCurrentHeight  > barMiddleHeight && isBarDraggingDown == false {
                let dateLabelOriginY = dateLabel.frame.origin.y
                let diff = UIScreen.main.bounds.height - dateLabelOriginY - 10
                barCurrentHeight  = diff
                updateBar(height: barCurrentHeight)
            } else if self.barCurrentHeight < middleHeighBorder && isBarDraggingDown == true {
                barCurrentHeight = barMinHeight
                updateBar(height: barCurrentHeight, width: barMinWidth)
                
                UIView.animate(withDuration: 0.35) {
                    self.bottomBar.backgroundColor = .white.withAlphaComponent(0.8)
                }
            }
        default:
            break
        }
    }
    
    private func updateBar(height: CGFloat, width: CGFloat = UIScreen.main.bounds.width) {
        UIView.animate(withDuration: 0.35) {
            self.barCurrentWidth = width
            self.bottomBar.snp.updateConstraints {
                $0.height.equalTo(height)
                $0.width.equalTo(self.barCurrentWidth)
            }
            
            self.layoutIfNeeded()
        }
    }
}
