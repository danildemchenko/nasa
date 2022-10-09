//
//  HomeView.swift
//  nasa
//
//  Created by Danil Demchenko on 07.10.2022.
//

import UIKit
import SnapKit

protocol RoverCellDelegate: AnyObject {
    func getRoverUrl(_ url: URL)
}

final class HomeView: UIView {
    
    weak var controller: HomeController!
    
    private var rovers: [HomeModel.Rover] = []
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let topImageView = UIImageView()
    private let leftImageView = UIImageView()
    private let rightImageView = UIImageView()
    
    private let fetchPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "FETCH PHOTO FROM ROVER"
        label.font = .getGillSansRegular(ofSize: 12)
        label.textColor = Constants.Color.primary
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fetchAllButton, calendarButton])
        stackView.spacing = 30
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let fetchAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Fetch all", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Color.secondary
        return button
    }()
    
    private let calendarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Color.secondary
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
    
    override func layoutSubviews() {
        super.layoutSubviews()

        [
            fetchAllButton,
            calendarButton,
        ].forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
        }
    }
 
    private func configureAppearance() {
        backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RoverCell.self, forCellWithReuseIdentifier: RoverCell.id)

        self.topImageView.transform = Constants.Transorm.topImage
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            topImageView,
            leftImageView,
            rightImageView,
            fetchPhotoLabel,
            collectionView,
            buttonsStackView,
        ].forEach(contentView.addSubview)
    }
    
    private func addConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(snp.width)
            $0.top.equalTo(safeAreaInsets).offset(30)
        }
        
        topImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.leading.equalToSuperview().inset(Constants.Offset.basic)
        }
        
        leftImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.Offset.basic)
            $0.top.equalTo(topImageView).offset(117)
        }

        rightImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.Offset.basic)
            $0.top.equalTo(topImageView).offset(158)
        }

        fetchPhotoLabel.snp.makeConstraints {
            $0.top.equalTo(leftImageView.snp.bottom).offset(Constants.Offset.basic)
            $0.leading.trailing.equalToSuperview().offset(Constants.Offset.basic)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(fetchPhotoLabel.snp.bottom).offset(13)
            $0.height.equalTo(230)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        fetchAllButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        calendarButton.snp.makeConstraints {
            $0.height.equalTo(fetchAllButton)
            $0.width.equalTo(80)
        }
    }
    
    func setupView(with data: [HomeModel.Rover]) {
        rovers = data
        
        topImageView.image = UIImage(named: data[0].imageName)
        leftImageView.image = UIImage(named: data[1].imageName)
        rightImageView.image = UIImage(named: data[2].imageName)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        switch indexPath.row {
        case 0:
            UIView.animate(withDuration: Constants.animationDuration) {
                self.topImageView.transform = Constants.Transorm.topImage
            }
            UIView.animate(withDuration: Constants.animationDuration) {
                self.leftImageView.transform = Constants.Transorm.normal
            }
            UIView.animate(withDuration: Constants.animationDuration) {
                self.rightImageView.transform = Constants.Transorm.normal
            }
        case 1:
            UIView.animate(withDuration: Constants.animationDuration) {
                self.topImageView.transform = Constants.Transorm.normal
            }
            UIView.animate(withDuration: Constants.animationDuration) {
                self.leftImageView.transform = Constants.Transorm.leftImage
            }
            UIView.animate(withDuration: Constants.animationDuration) {
                self.rightImageView.transform = Constants.Transorm.normal
            }
        case 2:
            UIView.animate(withDuration: Constants.animationDuration) {
                self.topImageView.transform = Constants.Transorm.normal
            }
            UIView.animate(withDuration: Constants.animationDuration) {
                self.leftImageView.transform = Constants.Transorm.normal
            }
            UIView.animate(withDuration: Constants.animationDuration) {
                self.rightImageView.transform = Constants.Transorm.rightImage
            }
        default: break
        }
    }
}

extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rovers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoverCell.id, for: indexPath) as! RoverCell
        let item = rovers[indexPath.item]
        cell.delegate = self
        cell.configure(with: .init(title: item.name, description: item.mission, url: item.missionUrl))
        return cell
    }
}

extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        RoverCell.size
    }
}

extension HomeView: RoverCellDelegate {
    func getRoverUrl(_ url: URL) {
        controller.openMission(with: url)
    }
}

extension Constants {
    static let animationDuration = 0.2
    
    enum Transorm {
        static let normal: CGAffineTransform = .init(scaleX: 1, y: 1)
        static let topImage: CGAffineTransform = .init(scaleX: 1.1, y: 1.15)
        static let leftImage: CGAffineTransform = .init(scaleX: 1.07, y: 1.07)
        static let rightImage: CGAffineTransform = .init(scaleX: 1.2, y: 1.15)
    }
}
