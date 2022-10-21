//
//  Manifest.swift
//  nasa
//
//  Created by Danil Demchenko on 21.10.2022.
//

import Foundation

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
    private let photos: [ManifestPhoto]
    
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
        Constants.CustomDataFormatter.manifest.date(from: launchDateStr)
    }
    
    var maxSolString: String {
        String(maxSol)
    }
    
    var totalPhotosString: String {
        String(totalPhotos)
    }
    
    var launchDateManifestString: String {
        let date = Constants.CustomDataFormatter.request.date(from: launchDateStr)
        return Constants.CustomDataFormatter.manifest.string(from: date!)
    }
    
    var amountOfDaysString: String {
        String(photos.count)
    }
    
    var manifestStatus: ManifestStatus {
        ManifestStatus(rawValue: status)!
    }
}

// we only need photo counts
struct ManifestPhoto: Codable {}

