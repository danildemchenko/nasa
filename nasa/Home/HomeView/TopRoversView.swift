//
//  TopRoversView.swift
//  nasa
//
//  Created by Danil Demchenko on 14.10.2022.
//

import UIKit
import SnapKit

extension TopRoversView {
    struct TopRoversViewConfig {
        let topImageName: String
        let leftImageName: String
        let rightImageName: String
    }
}

final class TopRoversView: UIView {
    
    var delegate: TopRoversViewDelegate!
    
    private let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 0
        return imageView
    }()
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 1
        return imageView
    }()
    
    private let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tag = 2
        return imageView
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
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: Constants.scaleFactor, y: Constants.scaleFactor)
        transform = transform.translatedBy(x: -Constants.unit * 3, y: -Constants.unit * 32)
        topImageView.transform = transform
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(action1)))
    }
    
    private func addSubviews() {
        [
            topImageView,
            leftImageView,
            rightImageView,
        ].forEach(addSubview)
    }
    
    private func addConstraints() {
        topImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(Constants.Offset.basic)
            $0.height.equalTo(Constants.unit * 268)
        }
        
        leftImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.Offset.basic)
            $0.bottom.equalToSuperview()
            $0.size.equalTo(Constants.unit * 330)
        }
        
        rightImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.Offset.basic)
            $0.bottom.equalToSuperview().inset(31)
            $0.height.equalTo(Constants.unit * 268)
            $0.width.equalTo(rightImageView.snp.height).multipliedBy(0.5)
        }
    }
    
    func configure(with config: TopRoversViewConfig) {
        topImageView.image = UIImage(named: config.topImageName)
        leftImageView.image = UIImage(named: config.leftImageName)
        rightImageView.image = UIImage(named: config.rightImageName)
    }
    
    func animate(selectedRoverTag: Int) {
        [
            topImageView,
            leftImageView,
            rightImageView,
        ].forEach { roverImageView in
            let scaleFactor = selectedRoverTag == roverImageView.tag ? Constants.scaleFactor : 1
            let offset: CGFloat = selectedRoverTag == roverImageView.tag ? Constants.unit : 0

            UIView.animate(withDuration: 0.25) {
                var transform = CGAffineTransform.identity
                transform = transform.scaledBy(x: scaleFactor, y: scaleFactor)

                switch roverImageView {
                case self.topImageView: transform = transform.translatedBy(x: -offset * 3, y: -offset * 32)
                case self.leftImageView: transform = transform.translatedBy(x: -offset * 37, y: -offset * 37)
                case self.rightImageView: transform = transform.translatedBy(x: offset * 17, y: 0)
                default: break
                }

                roverImageView.transform = transform
            }
        }
    }
    
    @objc private func action1(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: sender.view)
        let segment = checkTapSegment(point: touchLocation)
        delegate.tapAtRover(with: segment.tag)
        animate(selectedRoverTag: segment.tag)
    }

    private func checkTapSegment(point: CGPoint) -> UIImageView {
        let rightTriangle = (CGPoint(x: Constants.unit * 375, y: Constants.unit * 128),
                             CGPoint(x: Constants.unit * 375, y: Constants.unit * 470),
                             CGPoint(x: Constants.unit * 200, y: Constants.unit * 300))

        let leftTriangle = (CGPoint(x: 0, y: Constants.unit * 100),
                            CGPoint(x: Constants.unit * 375, y: Constants.unit * 470),
                            CGPoint(x: 0, y: Constants.unit * 470))

        if pointIsContain(at: rightTriangle) {
            return rightImageView
        } else if pointIsContain(at: leftTriangle) {
            return leftImageView
        } else {
            return topImageView
        }

        func pointIsContain(at triangle: (CGPoint, CGPoint, CGPoint)) -> Bool {
            let a = (triangle.0.x - point.x) * (triangle.1.y - triangle.0.y) - (triangle.1.x - triangle.0.x)
                * (triangle.0.y - point.y)
            let b = (triangle.1.x - point.x) * (triangle.2.y - triangle.1.y) - (triangle.2.x - triangle.1.x)
                * (triangle.1.y - point.y)
            let c = (triangle.2.x - point.x) * (triangle.0.y - triangle.2.y) - (triangle.0.x - triangle.2.x)
                * (triangle.2.y - point.y)

            return (a >= 0 && b >= 0 && c >= 0) || (a <= 0 && b <= 0 && c <= 0)
        }
    }
}

private extension Constants {
    static let scaleFactor = 1.25
}
