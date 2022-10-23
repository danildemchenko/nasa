//
//  ManifestModel.swift
//  nasa
//
//  Created by Danil Demchenko on 18.10.2022.
//

import Foundation

protocol RoverPhotosProtocol {
    var nasaApiService: NasaApiService { get }
    var controller: RoverPhotosController! { get set }
    
    func fetchRoverPhotosByEarthDate(rover: RoverType, date: Date, page: Int)
}

final class RoverPhotosModel {
    var nasaApiService: NasaApiService
    weak var controller: RoverPhotosController!
    
    init(nasaApiService: NasaApiService) {
        self.nasaApiService = nasaApiService
    }
}

extension RoverPhotosModel: RoverPhotosProtocol {
    
    func fetchRoverPhotosByEarthDate(rover: RoverType, date: Date, page: Int) {
        nasaApiService.getPhotosByEarthDate(rover: rover, date: date, page: page) { [weak self] roverPhotos, error in
            DispatchQueue.main.async {
                self?.controller.setupPhotosByEarthDate(roverPhotos?.photos ?? [])
            }
        }
    }
}
