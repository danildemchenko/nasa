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
    var selectedRover: RoverType { get set }
    var storageService: StorageService { get set }
    
    func setupInitialRover()
    func updateSelectedRover(_ newRover: RoverType)
    func openRoverMissionPage(_ rover: RoverType)
    func fetchManifest()
}

final class HomeModel {
    var nasaApiService: NasaApiServiceProtocol
    var storageService: StorageService
    var selectedRover: RoverType = .spirit
    
    weak var controller: HomeController!
    
    init(nasaApiService: NasaApiServiceProtocol, storageService: StorageService) {
        self.nasaApiService = nasaApiService
        self.storageService = storageService
    }
}

extension HomeModel: HomeModelProtocol {
    func setupInitialRover() {
        controller.setupRover()
    }
    
    func updateSelectedRover(_ newRover: RoverType) {
        selectedRover = newRover
        controller.updateRover(rover: selectedRover)
    }
    
    func openRoverMissionPage(_ rover: RoverType) {
        controller.openMission(with: ConfigurationService(with: rover).missionPageUrl)
    }
    
    func fetchManifest() {
        if let storedManifest: Manifest =
            storageService.getStoredObject(with: "manifest-\(selectedRover.stringValue)") {
            self.controller.openRover(with: storedManifest)
        } else {
            nasaApiService.getManifest(for: selectedRover) { [weak self] manifestResponse, error in
                DispatchQueue.main.async {
                    if manifestResponse?.photoManifest.manifestStatus == .complete {
                        self?.storageService.store(object: manifestResponse?.photoManifest,
                                                   with: "manifest-\(self?.selectedRover.stringValue)")
                    }
                    self?.controller.openRover(with: manifestResponse!.photoManifest)
                }
            }
        }
    }
}
