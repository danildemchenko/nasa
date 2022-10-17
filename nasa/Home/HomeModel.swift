//
//  HomeModel.swift
//  nasa
//
//  Created by Danil Demchenko on 07.10.2022.
//

import Foundation

protocol HomeModelProtocol {
    var controller: HomeController! { get set }
    func getRovers()
}

final class HomeModel: HomeModelProtocol {
    
    struct Rover {
        let imageName: String
        let name: String
        let mission: String
        let missionUrl: URL
    }
    
    weak var controller: HomeController!
    
    func getRovers() {
        let data: [Rover] = [
            .init(imageName: "opportunity",
                  name: "Opportunity",
                  mission: "Opportunity was the second of the two rovers launched in 2003 to land on Mars and begin traversing the Red Planet in search of signs of ancient water. The rover explored the Martian terrain for almost 15 years, far outlasting her planned 90-day mission.",
                  missionUrl: ConfigurationService(with: .opportunity).missionPageUrl
                  ),
            .init(imageName: "spirit",
                  name: "Spirit",
                  mission: "Opportunity was the second of the two rovers launched in 2003 to land on Mars and begin traversing the Red Planet in search of signs of ancient water. The rover explored the Martian terrain for almost 15 years, far outlasting her planned 90-day mission. Additional text just for the test spirit",
                  missionUrl: ConfigurationService(with: .spirit).missionPageUrl
                 )
            ,
            .init(imageName: "curiosity",
                  name: "Curiosity",
                  mission: "Opportunity was the second of the two rovers launched in 2003 to land on Mars and begin traversing the Red Planet in search of signs of ancient water. The rover explored the Martian terrain for almost 15 years, far outlasting her planned 90-day mission. Additional text just for the test curiosity",
                  missionUrl: ConfigurationService(with: .curiosity).missionPageUrl
                 )
        ]
        controller.setData(data)
    }
}
