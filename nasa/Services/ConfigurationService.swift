//
//  Configurator.swift
//  nasa
//
//  Created by Danil Demchenko on 15.10.2022.
//

import UIKit

final class ConfigurationService {
    
    let apiKey: String
    let missionPageUrl: URL
    let primaryUrl: URL
    
    init(with rover: RoverType) {
        var format = PropertyListSerialization.PropertyListFormat.xml
        
        guard let path = Bundle.main.path(forResource: rover.configName, ofType: "plist"),
              let file = FileManager.default.contents(atPath: path),
              let config = try? PropertyListSerialization.propertyList(from: file,
                                                                       options: .mutableContainersAndLeaves,
                                                                       format: &format) as? [String: Any] else {
            fatalError("plist not found")
        }
        
        apiKey = config["apiKey"] as! String
        
        let urls = config["urls"] as! [String: Any]
        primaryUrl = getURL(with: urls["photos"] as! [String: Any])
        missionPageUrl = getURL(with: urls["missionPage"] as! [String: Any])
        
        func getURL(with urlData: [String: Any]) -> URL {
            var urlComponents = URLComponents()
            urlComponents.scheme = urlData["scheme"] as? String
            urlComponents.host = urlData["host"] as? String
            urlComponents.path = (urlData["path"] as? String) ?? ""
            
            let version = urlData["version"] as! String
            if !version.isEmpty {
                urlComponents.path += "\(version)"
            }
            
            return urlComponents.url!
        }
    }
}
