//
//  ManifestInfoView.swift
//  nasa
//
//  Created by Danil Demchenko on 19.10.2022.
//

import UIKit

final class ManifestInfoView: UIView {
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = .getGillSansSemiBold(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .getGillSansSemiBold(ofSize: 16)
        label.textColor = .white.withAlphaComponent(0.6)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubviews()
        addConstraints()
    }
    
    private func configureAppearance() {

    }
    
    private func addSubviews() {
        [
            numberLabel,
            textLabel,
        ].forEach(addSubview)
    }
    
    private func addConstraints() {
        numberLabel.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalTo(numberLabel.snp.bottom).inset(5)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
