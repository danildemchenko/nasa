//
//  ManifestView.swift
//  nasa
//
//  Created by Danil Demchenko on 19.10.2022.
//

import UIKit

protocol ManifestViewProtocol {
    var controller: ManifestController! { get set }
    var manifest: ManifestModel.Manifest! { get set }
    var photos: [ManifestModel.RoverPhoto]! { get set }
}

final class ManifestView: UIView {
    
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
    
    private let photosView = ManifestInfoView()
    private let dayView = ManifestInfoView()
    private let solView = ManifestInfoView()
    
    weak var controller: ManifestController!
    
    var manifest: ManifestModel.Manifest! {
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
    
    var photos: [ManifestModel.RoverPhoto]! {
        didSet {
            print(photos)
        }
    }
    
    private let unit = UIScreen.main.bounds.width / 375
    
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
    
    private func configureAppearance() {
        backgroundColor = .white
        
        [
            titleLabel,
            dateLabel,
        ].forEach(addShadows)
    }
    
    private func addSubviews() {
        [
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
    
    private func addShadows(to label: UILabel) {
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
}

extension ManifestView: ManifestViewProtocol {}
