//
//  ManifestController.swift
//  nasa
//
//  Created by Danil Demchenko on 18.10.2022.
//

import UIKit
import Moya
import RxDataSources

final class RoverPhotosViewController: UIViewController {
    
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
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.minimumLineSpacing = Constants.Unit.base * 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        return collectionView
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
    
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<RoverPhotosViewModel.SectionModel>!
    var rover: RoverType
    
    private var viewModel: RoverPhotosViewModel
    
    init(viewModel: RoverPhotosViewModel, rover: RoverType) {
        self.viewModel = viewModel
        self.rover = rover
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = RoverPhotosViewModel(provider: MoyaProvider<NasaApiService>())
        rover = RoverType(rawValue: 0)!
       
        super.init(coder: coder)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        addSubviews()
        addConstraints()
        bind()
        
        viewModel.fetchRoverPhotosByEarthDate(rover: rover,
                                          date: Constants.CustomDataFormatter.request.date(from: "2015-6-3")!,
                                          page: 1)
    }
    
    private func configureAppearance() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "photoId")
        collectionView.backgroundColor = .brown
        dataSource = generateDataSource()
        
        collectionView.rx.setDelegate(self)
            .disposed(by: viewModel.disposeBag)
        
        [
            titleLabel,
            dateLabel,
        ].forEach { $0.addSystemShadows() }

        DispatchQueue.main.async {
            self.barHandle.layer.cornerRadius = self.barHandle.frame.height / 2
        }
        
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
        ].forEach(view.addSubview)
        
        [
            photosView,
            dayView,
            solView,
        ].forEach(stackView.addArrangedSubview)
        
        bottomBar.addSubview(upperBottomBar)
        bottomBar.addSubview(collectionView)
        upperBottomBar.addSubview(barHandle)
    }
    
    private func addConstraints() {
        backgroundImageContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(unitW * 24)
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
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(upperBottomBar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(Constants.Unit.base * 20)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func generateDataSource() -> RxCollectionViewSectionedAnimatedDataSource<RoverPhotosViewModel.SectionModel> {
        return RxCollectionViewSectionedAnimatedDataSource<RoverPhotosViewModel.SectionModel>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .none,
                                                           reloadAnimation: .fade,
                                                           deleteAnimation: .fade
                                                          ),
            configureCell: { dataSource, collectionView, indexPath, _ in
                let item: RoverPhotosViewModel.ItemModel = dataSource[indexPath]
                
                switch item {
                case .photo(let item):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoId",
                                                                  for: indexPath) as! UICollectionViewCell
                    cell.backgroundColor = .red
                    //configure cell with item
                    return cell
                }
            },
            configureSupplementaryView: {_, _, _, _ in
                return UICollectionReusableView()
            }
        )
    }
    
    private func bind() {
        viewModel.sections
            .asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel.disposeBag)
    }
        
    func setupManifestData(_ manifest: Manifest) {
        self.manifest = manifest
        backgroundImageContainer.image = UIImage(named: rover.stringValue)
    }
}

@objc extension RoverPhotosViewController {
    @objc func bottomBarGestureHandler(_ recognizer: UIPanGestureRecognizer) {
        let barMiddleHeight: CGFloat = unitH * 473
        let barMinHeight: CGFloat = unitH * 90
        let barMaxHeight: CGFloat = unitH * 813
        let barMaxWidth = UIScreen.main.bounds.width
        let barMinWidth = UIScreen.main.bounds.width - 36 * unitW
        let middleHeighBorder = barMiddleHeight - 200
        
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: view)
     
            isBarDraggingDown = translation.y > 0 && barCurrentHeight < barMaxHeight

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
                self.view.layoutIfNeeded()
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
            
            recognizer.setTranslation(.zero, in: view)
            
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
            
            self.view.layoutIfNeeded()
        }
    }
}

extension RoverPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Constants.Unit.base * 20 + 2 + 1
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / 2
        return .init(width: widthPerItem, height: 150)
    }
}
