//
//  Service.swift
//  nasa
//
//  Created by Danil Demchenko on 18.10.2022.
//

import Foundation

protocol NasaApiServiceProtocol: AnyObject {
    func getManifest(for rover: RoverType, completion: @escaping (Manifest?, Error?) -> Void)
    func getPhotosBySol(rover: RoverType,
                        sol: Int,
                        page: Int,
                        completion: @escaping (RoverPhotos?, Error?) -> Void)
    func getPhotosByEarthDate(rover: RoverType, date: Date,
                              page: Int,
                              completion: @escaping (RoverPhotos?, Error?) -> Void)
}

final class NasaApiService: NasaApiServiceProtocol {
    func getManifest(for rover: RoverType, completion: @escaping (Manifest?, Error?) -> Void) {
        let url = URLService(endpoint: .manifest(rover: rover)).url
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            let manifest = try? JSONDecoder().decode(ManifestResponse.self, from: data)
            completion(manifest?.photoManifest, nil)
        }
        .resume()
    }
    
    func getPhotosBySol(rover: RoverType,
                        sol: Int,
                        page: Int,
                        completion: @escaping (RoverPhotos?, Error?) -> Void) {
        let url = URLService(endpoint: .photosbySol(rover: rover, sol: sol, page: page)).url
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            let roverPhotos = try? JSONDecoder().decode(RoverPhotos.self, from: data)
            completion(roverPhotos, nil)
        }
        .resume()
    }
    
    func getPhotosByEarthDate(rover: RoverType,
                              date: Date,
                              page: Int,
                              completion: @escaping (RoverPhotos?, Error?) -> Void) {
        let url = URLService(endpoint: .photosByDate(rover: rover, date: date, page: page)).url
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            let roverPhotos = try? JSONDecoder().decode(RoverPhotos.self, from: data)
            completion(roverPhotos, nil)
        }
        .resume()
    }
}
