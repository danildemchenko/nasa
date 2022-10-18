//
//  RoverCell.swift
//  nasa
//
//  Created by Danil Demchenko on 07.10.2022.
//

import UIKit
import SnapKit

extension RoverCell {
    struct CellConfig {
        let title: String
        let description: String
    }
}

final class RoverCell: UICollectionViewCell {
    
    private let mainContainer = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .getGillSansRegular(ofSize: 32)
        label.textColor = Constants.Color.title
        return label
    }()
    
    private let missionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Color.primary
        label.font = .getGillSansRegular(ofSize: 12)
        label.text = Localization.MainScreen.mission.uppercased()
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .getGillSansRegular(ofSize: 15)
        label.textColor = Constants.Color.description
        label.numberOfLines = 5
        return label
    }()

    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle(Localization.MainScreen.moreButton.uppercased(), for: .normal)
        button.setTitleColor(Constants.Color.primary, for: .normal)
        button.titleLabel?.font = .getGillSansRegular(ofSize: 12)
        return button
    }()
    
    static let id = "rover"
    static let size = CGSize(width: UIScreen.main.bounds.width, height: 230)
    
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
    }
    
    private func addSubviews() {
        addSubview(mainContainer)
        
        [
            titleLabel,
            missionLabel,
            descriptionLabel,
            moreButton,
        ].forEach(mainContainer.addSubview)
    }
    
    private func addConstraints() {
        mainContainer.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16 * HomeView.unit)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        missionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(missionLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(16 * HomeView.unit)
            $0.height.equalTo(30)
        }
    }
    
    func configure(with config: RoverCell.CellConfig) {
        titleLabel.text = config.title.uppercased()
        descriptionLabel.text = config.description
    }
}
