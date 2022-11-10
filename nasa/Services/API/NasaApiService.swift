//
//  NasaApiService.swift
//  nasa
//
//  Created by Danil Demchenko on 02.11.2022.
//

import Foundation
import Moya

enum NasaApiTarget {
    case manifest(rover: RoverType)
    case photosbySol(rover: RoverType, sol: Int, page: Int)
    case photosByDate(rover: RoverType, date: Date, page: Int)
}

final class NasaApiService {
    
    private let target: NasaApiTarget
    private let config = ConfigurationService()
    
    init(target: NasaApiTarget) {
        self.target = target
    }
}

extension NasaApiService: TargetType {
    
    var headers: [String : String]? {
        [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
    }
    
    var baseURL: URL {
        ConfigurationService().baseUrl
    }
    
    var path: String {
        switch target {
        case .manifest(let rover):
            return "/manifests/\(rover.stringValue)"
        case .photosByDate(let rover, _, _):
            return "/rovers/\(rover.stringValue)/photos"
        case .photosbySol(let rover, _, _):
            return "/rovers/\(rover.stringValue)/photos"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Moya.Task {
        var params: [String: Any] = [:]
        
        switch target {
        case .manifest:
            params = [
                "api_key": config.apiKey
            ]
        case .photosByDate(_, let date, let page):
            params = [
                "api_key": config.apiKey,
                "page": page,
                "earth_date": date
            ]
        case .photosbySol(_, let sol, let page):
            params = [
                "api_key": config.apiKey,
                "page": page,
                "sol": sol
            ]
        }
        
        return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    }
}
