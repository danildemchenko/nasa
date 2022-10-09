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
        let url: String
    }
}

final class RoverCell: UICollectionViewCell {
    
    weak var delegate: RoverCellDelegate!
    
    static let id = "rover"
    static let size = CGSize(width: UIScreen.main.bounds.width, height: 230)
    
    private let mainContainer = UIView()
    private var missionUrl = ""
    
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
        label.text = "mission".uppercased()
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textContainer.maximumNumberOfLines = 5
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.lineFragmentPadding = 0
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("MORE", for: .normal)
        button.setTitleColor(Constants.Color.primary, for: .normal)
        button.titleLabel?.font = .getGillSansRegular(ofSize: 12)
        return button
    }()
    
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
        
        moreButton.addTarget(self, action: #selector(moreButtonHandler), for: .touchDown)
    }
    
    private func addSubviews() {
        addSubview(mainContainer)
        
        [
            titleLabel,
            missionLabel,
            descriptionTextView,
            moreButton,
        ].forEach(mainContainer.addSubview)
    }
    
    private func addConstraints() {
        mainContainer.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.Offset.basic)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        missionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
            $0.leading.trailing.equalToSuperview()
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(missionLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview().inset(Constants.Offset.basic)
            $0.height.equalTo(30)
        }
    }
    
    private func configureRoverDescription(with text: String) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        let attributes = [NSAttributedString.Key.paragraphStyle: style]
        descriptionTextView.attributedText = NSAttributedString(string: text, attributes: attributes)
        descriptionTextView.font = .getGillSansRegular(ofSize: 15)
        descriptionTextView.textColor = Constants.Color.description
    }
    
    func configure(with config: RoverCell.CellConfig) {
        titleLabel.text = config.title.uppercased()
        configureRoverDescription(with: config.description)
        missionUrl = config.url
    }
}

@objc extension RoverCell {
    private func moreButtonHandler() {
        delegate.getRoverUrl(URL(string: missionUrl)!)
    }
}
