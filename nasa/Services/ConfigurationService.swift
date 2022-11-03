//
//  Configurator.swift
//  nasa
//
//  Created by Danil Demchenko on 15.10.2022.
//

import UIKit

final class ConfigurationService {
    
    let apiKey: String
    let baseUrl: URL
    
    private let config: [String : Any]
    
    init() {
        var format = PropertyListSerialization.PropertyListFormat.xml
        
        guard let path = Bundle.main.path(forResource: "Main", ofType: "plist"),
              let file = FileManager.default.contents(atPath: path),
              let config = try? PropertyListSerialization.propertyList(from: file,
                                                                       options: .mutableContainersAndLeaves,
                                                                       format: &format) as? [String: Any] else {
            fatalError("plist not found")
        }
        
        self.config = config
        
        apiKey = config["apiKey"] as! String
        baseUrl = URL(string: (config["baseUrl"] as! String))!
    }
    
    func getMissionPageUrl(of rover: RoverType) -> URL {
        let missionPages = config["missionPages"] as! [String: Any]
        let roverData = missionPages[rover.stringValue] as! [String: Any]
        var urlComponents = URLComponents()
        
        urlComponents.scheme = roverData["scheme"] as? String
        urlComponents.host = roverData["host"] as? String
        urlComponents.path = (roverData["path"] as? String) ?? ""
        return urlComponents.url!
    }
}
