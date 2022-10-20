//
//  ManifestModel.swift
//  nasa
//
//  Created by Danil Demchenko on 18.10.2022.
//

import Foundation

protocol ManifestModelProtocol {
    var service: ManifestServiceProtocol { get }
    var storageService: StorageServiceProtocol { get }
    var controller: ManifestController! { get set }
    
    func fetchManifest(for rover: RoverType)
    func fetchRoverPhotosByEarthDate(rover: RoverType, date: Date, page: Int)
}

final class ManifestModel {
    
    struct ManifestResponse: Codable {
        let photoManifest: Manifest
        
        enum CodingKeys: String, CodingKey {
            case photoManifest = "photo_manifest"
        }
    }
    
    struct Manifest: Codable {
        let name: String
        private let launchDateStr: String
        private let status: String
        private let maxSol: Int
        private let maxDateStr: String
        private let totalPhotos: Int
        private let photos: [Photo]
        
        enum CodingKeys: String, CodingKey {
            case name
            case launchDateStr = "launch_date"
            case status
            case maxSol = "max_sol"
            case maxDateStr = "max_date"
            case totalPhotos = "total_photos"
            case photos = "photos"
        }
        
        enum ManifestStatus: String {
            case active
            case complete
        }
        
        var launchDate: Date? {
            Constants.PrimaryDateFormatter.manifest.date(from: launchDateStr)
        }
        
        var maxSolString: String {
            String(maxSol)
        }
        
        var totalPhotosString: String {
            String(totalPhotos)
        }
        
        var launchDateManifestString: String {
            let date = Constants.PrimaryDateFormatter.request.date(from: launchDateStr)
            return Constants.PrimaryDateFormatter.manifest.string(from: date!)
        }
        
        var amountOfDaysString: String {
            String(photos.count)
        }
        
        var manifestStatus: ManifestStatus {
            ManifestStatus(rawValue: status)!
        }
    }
    
    // we only need photo counts
    struct Photo: Codable {}
    
    struct RoverPhotos: Codable {
        let photos: [RoverPhoto]
    }
    
    struct RoverPhoto: Codable {
        let id: Int
        let sol: Int
        let img_src: String
        let earth_date: String
        let rover: Rover
    }
    
    struct Rover: Codable {
        let id: Int
        let name: String
        let landing_date: String
        let launch_date: String
        let status: String
    }
    
    var service: ManifestServiceProtocol
    var storageService: StorageServiceProtocol
    weak var controller: ManifestController!
    
    init(service: ManifestServiceProtocol, storageService: StorageServiceProtocol) {
        self.service = service
        self.storageService = storageService
    }
}

extension ManifestModel: ManifestModelProtocol {
    func fetchManifest(for rover: RoverType) {
        if let storedManifest: ManifestModel.Manifest =
            storageService.getStoredObject(with: "manifest-\(rover.stringValue)") {
            print("stored")
            self.controller.setupPrimaryManifestData(storedManifest)
        } else {
            service.getManifest(for: rover) { [weak self] manifest, error in
                print("api call")
                DispatchQueue.main.async {
                    if manifest?.manifestStatus == .complete {
                        self?.storageService.store(object: manifest!, with: "manifest-\(rover.stringValue)")
                    }
                    self?.controller.setupPrimaryManifestData(manifest!)
                }
            }
        }
    }
    
    func fetchRoverPhotosByEarthDate(rover: RoverType, date: Date, page: Int) {
        service.getPhotosByEarthDate(rover: rover, date: date, page: page) { [weak self] roverPhotos, error in
            DispatchQueue.main.async {
                self?.controller.setupPhotosByEarthDate(roverPhotos?.photos ?? [])
            }
        }
    }
}
