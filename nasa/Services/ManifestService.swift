//
//  Service.swift
//  nasa
//
//  Created by Danil Demchenko on 18.10.2022.
//

import Foundation

protocol ManifestServiceProtocol: AnyObject {
    func getManifest(for rover: RoverType, completion: @escaping (ManifestModel.Manifest?, Error?) -> Void)
    func getPhotosBySol(rover: RoverType,
                        sol: Int,
                        page: Int,
                        completion: @escaping (ManifestModel.RoverPhotos?, Error?) -> Void)
    func getPhotosByEarthDate(rover: RoverType, date: Date,
                              page: Int,
                              completion: @escaping (ManifestModel.RoverPhotos?, Error?) -> Void)
}

final class ManifestService: ManifestServiceProtocol {
    func getManifest(for rover: RoverType, completion: @escaping (ManifestModel.Manifest?, Error?) -> Void) {
        let url = URLProvider(endpoint: .manifest(rover: rover)).url
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            let manifest = try? JSONDecoder().decode(ManifestModel.ManifestResponse.self, from: data)
            completion(manifest?.photoManifest, nil)
        }
        .resume()
    }
    
    func getPhotosBySol(rover: RoverType,
                        sol: Int,
                        page: Int,
                        completion: @escaping (ManifestModel.RoverPhotos?, Error?) -> Void) {
        let url = URLProvider(endpoint: .photosbySol(rover: rover, sol: sol, page: page)).url
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            let roverPhotos = try? JSONDecoder().decode(ManifestModel.RoverPhotos.self, from: data)
            completion(roverPhotos, nil)
        }
        .resume()
    }
    
    func getPhotosByEarthDate(rover: RoverType,
                              date: Date,
                              page: Int,
                              completion: @escaping (ManifestModel.RoverPhotos?, Error?) -> Void) {
        let url = URLProvider(endpoint: .photosByDate(rover: rover, date: date, page: page)).url
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            let roverPhotos = try? JSONDecoder().decode(ManifestModel.RoverPhotos.self, from: data)
            completion(roverPhotos, nil)
        }
        .resume()
    }
}
