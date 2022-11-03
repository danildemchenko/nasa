//
//  HomeModel.swift
//  nasa
//
//  Created by Danil Demchenko on 07.10.2022.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

protocol HomeViewModelProtocol {
    var selectedRover: BehaviorRelay<RoverType> { get }
    var storageService: StorageService { get set }
    var roversData: [RoverCell.CellConfig] { get }
    var roverUrlForOpening: PublishSubject<URL> { get }
    var manifest: PublishSubject<Manifest> { get }
    var disposeBag: DisposeBag { get }
    func fetchManifest()
}

final class HomeViewModel {
    private var provider: MoyaProvider<NasaApiService>
    var storageService: StorageService
    var roversData: [RoverCell.CellConfig] = []
    var selectedRover = BehaviorRelay<RoverType>(value: .curiosity)
    var roverUrlForOpening = PublishSubject<URL>()
    var manifest = PublishSubject<Manifest>()
    var disposeBag = DisposeBag()
    
    init(provider: MoyaProvider<NasaApiService>, storageService: StorageService) {
        self.provider = provider
        self.storageService = storageService
     
        RoverType.allCases.forEach { rover in
            switch rover {
            case .opportunity:
                roversData.append(.init(title: Localization.MainScreen.Rover.Top.title,
                                        description: Localization.MainScreen.Rover.Top.description))
            case .spirit:
                roversData.append(.init(title: Localization.MainScreen.Rover.Left.title,
                                        description: Localization.MainScreen.Rover.Left.description))
            case .curiosity:
                roversData.append(.init(title: Localization.MainScreen.Rover.Right.title,
                                        description: Localization.MainScreen.Rover.Right.description))
            }
        }
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func fetchManifest() {
        if let storedManifest: Manifest =
            storageService.getStoredObject(with: "manifest-\(selectedRover.value)") {
            manifest.onNext(storedManifest)
        } else {
            provider.rx.request(.init(target: .manifest(rover: selectedRover.value)))
                .asObservable()
                .decode(ManifestResponse.self)
                .subscribe(onNext: { manifestResponse in
                    self.manifest.onNext(manifestResponse.photoManifest)
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
    }
}