//
//  TopRoversView.swift
//  nasa
//
//  Created by Danil Demchenko on 14.10.2022.
//

import UIKit
import SnapKit

final class TopRoversView: UIView {
    
    weak var delegate: TopRoversViewDelegate!
    
    private let topImageView = UIImageView()
    private let leftImageView = UIImageView()
    private let rightImageView = UIImageView()
        
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
        let imageViews = [topImageView, leftImageView, rightImageView]
     
        for (type, imageView) in zip(RoverType.allCases, imageViews) {
            imageView.image = UIImage(named: type.stringValue)
            imageView.tag = type.rawValue
        }
        
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: 1.35, y: 1.35)
        transform = transform.translatedBy(x: -HomeView.unit * 3, y: -HomeView.unit * 32)
        topImageView.transform = transform
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(containerViewHandler)))
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
            $0.top.leading.trailing.equalToSuperview().inset(16 * HomeView.unit)
            $0.height.equalTo(HomeView.unit * 268)
        }
        
        leftImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16 * HomeView.unit)
            $0.bottom.equalToSuperview()
            $0.size.equalTo(HomeView.unit * 330)
        }
        
        rightImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16 * HomeView.unit)
            $0.bottom.equalToSuperview().inset(31)
            $0.height.equalTo(HomeView.unit * 268)
            $0.width.equalTo(rightImageView.snp.height).multipliedBy(0.5)
        }
    }
    
    
    func animate(selectedRoverTag: Int) {
        [
            topImageView,
            leftImageView,
            rightImageView,
        ].forEach { roverImageView in
            let scaleFactor = selectedRoverTag == roverImageView.tag ? 1.35 : 1
            let offset: CGFloat = selectedRoverTag == roverImageView.tag ? HomeView.unit : 0

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
    
    private func checkTapSegment(point: CGPoint) -> UIImageView {
        let rightTriangle = (CGPoint(x: HomeView.unit * 375, y: HomeView.unit * 128),
                             CGPoint(x: HomeView.unit * 375, y: HomeView.unit * 470),
                             CGPoint(x: HomeView.unit * 200, y: HomeView.unit * 300))

        let leftTriangle = (CGPoint(x: 0, y: HomeView.unit * 100),
                            CGPoint(x: HomeView.unit * 375, y: HomeView.unit * 470),
                            CGPoint(x: 0, y: HomeView.unit * 470))

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

@objc extension TopRoversView {
    @objc private func containerViewHandler(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(in: sender.view)
        let segment = checkTapSegment(point: touchLocation)
        delegate.tapAt(rover: .init(rawValue: segment.tag)!)
        animate(selectedRoverTag: segment.tag)
    }
}
