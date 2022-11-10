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
    var roverUrlForOpening: PublishRelay<URL> { get }
    var manifest: PublishRelay<Manifest> { get }
    var error: PublishRelay<Error> { get }
    var disposeBag: DisposeBag { get }
    func fetchManifest()
    func setMissionPageUrl()
}

final class HomeViewModel {
    private var provider: MoyaProvider<NasaApiService>
    var storageService: StorageService
    var roversData: [RoverCell.CellConfig] = []
    var selectedRover = BehaviorRelay<RoverType>(value: .curiosity)
    var roverUrlForOpening = PublishRelay<URL>()
    var manifest = PublishRelay<Manifest>()
    var error = PublishRelay<Error>()
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
            manifest.accept(storedManifest)
        } else {
            provider.rx.request(.init(target: .manifest(rover: selectedRover.value)))
                .asObservable()
                .decode(ManifestResponse.self)
                .subscribe(onNext: { manifestResponse in
                    self.manifest.accept(manifestResponse.photoManifest)
                    self.storageService.store(object: manifestResponse.photoManifest,
                                              with: "manifest-\(self.selectedRover.value)")
                }, onError: { error in
                    self.error.accept(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    func setMissionPageUrl() {
        let roverMissionPageUrl = ConfigurationService().getMissionPageUrl(of: selectedRover.value)
        roverUrlForOpening.accept(roverMissionPageUrl)
    }
}
