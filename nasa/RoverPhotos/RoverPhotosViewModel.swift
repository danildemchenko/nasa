//
//  ManifestModel.swift
//  nasa
//
//  Created by Danil Demchenko on 18.10.2022.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import RxDataSources

protocol RoverPhotosViewModelProtocol {
    var provider: MoyaProvider<NasaApiService> { get }
    var sections: BehaviorRelay<[RoverPhotosViewModel.SectionModel]> { get }
    var disposeBag: DisposeBag { get }
    
    func fetchRoverPhotosByEarthDate(rover: RoverType, date: Date, page: Int)
}

final class RoverPhotosViewModel {
    var provider: MoyaProvider<NasaApiService>
    var sections = BehaviorRelay<[RoverPhotosViewModel.SectionModel]>(value: [])
    var disposeBag = DisposeBag()
    
    init(provider: MoyaProvider<NasaApiService>) {
        self.provider = provider
        
        //execute setupSections when loader is implemented
        //setupSections(with: [])
    }
    
    private func setupSections(with roverPhotos: [RoverPhoto]) {
        var items: [RoverPhotosViewModel.ItemModel] = []
        
        roverPhotos.forEach { photo in
            items.append(.photo(item: photo))
        }
        
        sections.accept([.main(items: items)])
    }
}

extension RoverPhotosViewModel: RoverPhotosViewModelProtocol {
    
    func fetchRoverPhotosByEarthDate(rover: RoverType, date: Date, page: Int) {
        provider.rx.request(.init(target: .photosByDate(rover: rover, date: date, page: page)))
            .asObservable()
            .decode(RoverPhotos.self)
            .subscribe(onNext: { decodedPhotosResponse in
                self.setupSections(with: decodedPhotosResponse.photos)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

extension RoverPhotosViewModel {
    enum SectionModel {
        case main(items: [ItemModel])
        
        var id: String {
            switch self {
            case .main: return String(describing: SectionModel.main)
            }
        }
    }
    
    enum ItemModel {
        case photo(item: RoverPhoto)
        
        var id: String {
            switch self {
            case .photo(let item): return "photo-\(item.id)"
            }
        }
    }
}


extension RoverPhotosViewModel.SectionModel: AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = RoverPhotosViewModel.ItemModel
    
    var items: [RoverPhotosViewModel.ItemModel] {
        switch self {
        case .main(let items):
            return items.map { $0 }
        }
    }
    
    var identity: String {
        id
    }
    
    init(original: RoverPhotosViewModel.SectionModel, items: [RoverPhotosViewModel.ItemModel]) {
        switch original {
        case .main:
            self = .main(items: items)
        }
    }
}

extension RoverPhotosViewModel.ItemModel: RxDataSources.IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String {
        id
    }
    
    static func == (lhs: RoverPhotosViewModel.ItemModel, rhs: RoverPhotosViewModel.ItemModel) -> Bool {
        lhs.id == rhs.id
    }
}
