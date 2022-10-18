//
//  HomeView.swift
//  nasa
//
//  Created by Danil Demchenko on 07.10.2022.
//

import UIKit
import SnapKit

protocol TopRoversViewDelegate: AnyObject {
    func tapAt(rover: RoverType)
}

protocol HomeViewProtocol {
    var controller: HomeController! { get set }
}

// MARK: substituted main view
final class HomeView: UIView, HomeViewProtocol {
    
    weak var controller: HomeController!
    
    // MARK: HARDCODED STATIC DATA
    let roversData: [RoverCell.CellConfig] = [
        .init(
            title: Localization.MainScreen.Rover.Top.title,
            description: Localization.MainScreen.Rover.Top.description
        ),
        .init(
            title: Localization.MainScreen.Rover.Left.title,
            description: Localization.MainScreen.Rover.Left.description
        ),
        .init(
            title: Localization.MainScreen.Rover.Right.title,
            description: Localization.MainScreen.Rover.Right.description
        ),
    ]
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let topRoversView = TopRoversView()
    
    static let unit = UIScreen.main.bounds.width / 375
    
    private let fetchPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.MainScreen.subtitle.uppercased()
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
        button.setTitle(Localization.MainScreen.fetchButton, for: .normal)
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
        
        topRoversView.delegate = self
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            topRoversView,
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
            $0.leading.trailing.bottom.top.equalToSuperview()
            $0.width.equalTo(snp.width)
        }
        
        topRoversView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(1.25)
        }
        
        fetchPhotoLabel.snp.makeConstraints {
            $0.top.equalTo(topRoversView.snp.bottom).offset(16 * HomeView.unit)
            $0.leading.trailing.equalToSuperview().offset(16 * HomeView.unit)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        topRoversView.animate(selectedRoverTag: indexPath.item)
    }
}

// MARK: UICollectionViewDataSource
extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roversData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoverCell.id, for: indexPath) as! RoverCell
        let item = roversData[indexPath.item]
        cell.configure(with: .init(title: item.title, description: item.description))
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        RoverCell.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.selectedRover(RoverType(rawValue: indexPath.item)!)
    }
}

// MARK: TopRoversViewDelegate
extension HomeView: TopRoversViewDelegate {
    func tapAt(rover: RoverType) {
        collectionView.scrollToItem(at: .init(row: rover.rawValue, section: 0), at: .bottom, animated: true)
    }
}
