//
//  HomeController.swift
//  nasa
//
//  Created by Danil Demchenko on 07.10.2022.
//

import UIKit
import SafariServices
import Moya
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let topRoversView = TopRoversView()
        
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
    
    weak var controller: HomeViewController!
    
    static let unit = UIScreen.main.bounds.width / 375
    
    private var viewModel: HomeViewModelProtocol
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = HomeViewModel(provider: MoyaProvider<NasaApiService>(), storageService: StorageService())
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        addSubviews()
        addConstraints()
        setupInitialRover()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [
            fetchAllButton,
            calendarButton,
        ].forEach {
            $0.layer.cornerRadius = $0.frame.height / 2
        }
    }
    
    private func setupInitialRover() {
        viewModel.selectedRover
            .take(1)
            .subscribe(onNext: { selectedRover in
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: selectedRover.rawValue, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
                }
                self.topRoversView.animate(selectedRoverTag: selectedRover.rawValue, duration: 0)
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    private func bind() {
        viewModel.selectedRover
            .skip(1)
            .subscribe(onNext: { selectedRover in
                let indexPath = IndexPath(row: selectedRover.rawValue, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
                self.topRoversView.animate(selectedRoverTag: selectedRover.rawValue)
            })
            .disposed(by: viewModel.disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { _ in
                self.viewModel.setMissionPageUrl()
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.roverUrlForOpening
            .subscribe(onNext: { url in
                self.openMission(with: url)
            })
            .disposed(by: viewModel.disposeBag)
        
        viewModel.manifest
            .subscribe { manifest in
                let roverPhotosModel = RoverPhotosViewModel(provider: MoyaProvider<NasaApiService>())
                let roverPhotosController = RoverPhotosViewController(
                    viewModel: roverPhotosModel, rover: self.viewModel.selectedRover.value
                )
                roverPhotosController.setupManifestData(manifest)
                roverPhotosController.modalPresentationStyle = .overFullScreen
                self.present(roverPhotosController, animated: true)
            }
            .disposed(by: viewModel.disposeBag)
        
        viewModel.error
            .subscribe(onNext: { error in
                self.showErrorAlert(error)
            })
            .disposed(by: viewModel.disposeBag)
        
        fetchAllButton.rx.tap
            .bind {
                self.viewModel.fetchManifest()
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    private func configureAppearance() {
        view.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RoverCell.self, forCellWithReuseIdentifier: RoverCell.id)
        
        topRoversView.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
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
            $0.width.equalTo(view.snp.width)
        }
        
        topRoversView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(1.25)
        }
        
        fetchPhotoLabel.snp.makeConstraints {
            $0.top.equalTo(topRoversView.snp.bottom).offset(16 * Constants.Unit.base)
            $0.leading.trailing.equalToSuperview().offset(16 * Constants.Unit.base)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(fetchPhotoLabel.snp.bottom).offset(13)
            $0.height.equalTo(230)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
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
        viewModel.selectedRover.accept(RoverType(rawValue: indexPath.item)!)
    }
    
    private func openMission(with url: URL) {
        let safariController = SFSafariViewController(url: url)
        safariController.modalPresentationStyle = .popover
        present(safariController, animated: true)
    }
}

// MARK: TopRoversViewDelegate
extension HomeViewController: TopRoversViewDelegate {
    func tapAt(rover: RoverType) {
        viewModel.selectedRover.accept(rover)
    }
}

// MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.roversData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoverCell.id, for: indexPath) as! RoverCell
        let item = viewModel.roversData[indexPath.item]
        cell.configure(with: .init(title: item.title, description: item.description))
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        RoverCell.size
    }
}
