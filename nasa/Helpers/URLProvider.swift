//
//  URLProvider.swift
//  nasa
//
//  Created by Danil Demchenko on 15.10.2022.
//

import Foundation

protocol URLProviderProtocol {
    var url: URL { get }
}


enum NasaApiEndpoint {
    case manifest(rover: RoverType)
    case photosbySol(rover: RoverType, sol: Int, page: Int = 1)
    case photosByData(rover: RoverType, date: Date, page: Int = 1)
    
    var url: URL {
        switch self {
        case .manifest(let rover):
            let config = Configurator(with: rover)
            var resultUrl = config.primaryUrl.appending(path: "/manifests/\(rover.rawValue)")
            resultUrl.append(queryItems: [
                .init(name: "api_key", value: config.apiKey)
            ])
            return resultUrl
        case .photosByData(let rover, let date, let page):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateStr = dateFormatter.string(from: date)
            
            let config = Configurator(with: rover)
            var resultUrl = config.primaryUrl.appending(path: "/rovers/\(rover.rawValue)/photos")
            resultUrl.append(queryItems: [
                .init(name: "earth_date", value: dateStr),
                .init(name: "page", value: String(page)),
                .init(name: "api_key", value: config.apiKey)
            ])
            return resultUrl
        case .photosbySol(let rover, let sol, let page):
            let config = Configurator(with: rover)
            var resultUrl = config.primaryUrl.appending(path: "/rovers/\(rover.rawValue)/photos")
            resultUrl.append(queryItems: [
                .init(name: "sol", value: String(sol)),
                .init(name: "page", value: String(page)),
                .init(name: "api_key", value: config.apiKey)
            ])
            return resultUrl
        }
    }
}

final class URLProvider: URLProviderProtocol {
    
    var url: URL
    
    init(endpoint: NasaApiEndpoint) {
        url = endpoint.url
    }
}
