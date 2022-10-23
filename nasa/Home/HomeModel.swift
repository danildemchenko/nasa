//
//  HomeModel.swift
//  nasa
//
//  Created by Danil Demchenko on 07.10.2022.
//

import Foundation

protocol HomeModelProtocol {
    var controller: HomeController! { get set }
    var nasaApiService: NasaApiServiceProtocol { get set }
    var storageService: StorageService { get set }
    
    func openRoverMissionPage(_ rover: RoverType)
    func fetchManifest(for rover: RoverType)
}

final class HomeModel {
    var nasaApiService: NasaApiServiceProtocol
    var storageService: StorageService
    weak var controller: HomeController!
    
    init(nasaApiService: NasaApiServiceProtocol, storageService: StorageService) {
        self.nasaApiService = nasaApiService
        self.storageService = storageService
    }
}

extension HomeModel: HomeModelProtocol {
    func openRoverMissionPage(_ rover: RoverType) {
        controller.openMission(with: ConfigurationService(with: rover).missionPageUrl)
    }
    
    func fetchManifest(for rover: RoverType) {
        if let storedManifest: Manifest =
            storageService.getStoredObject(with: "manifest-\(rover.stringValue)") {
            self.controller.openRover(with: storedManifest, and: rover)
        } else {
            nasaApiService.getManifest(for: rover) { [weak self] manifestResponse, error in
                DispatchQueue.main.async {
                    if manifestResponse?.photoManifest.manifestStatus == .complete {
                        self?.storageService.store(object: manifestResponse?.photoManifest,
                                                   with: "manifest-\(rover.stringValue)")
                    }
                    self?.controller.openRover(with: manifestResponse!.photoManifest, and: rover)
                }
            }
        }
    }
}
