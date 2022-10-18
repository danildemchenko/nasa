//
//  HomeModel.swift
//  nasa
//
//  Created by Danil Demchenko on 07.10.2022.
//

import Foundation

protocol HomeModelProtocol {
    var controller: HomeController! { get set }
    func openRoverMissionPage(_ rover: RoverType)
}

final class HomeModel: HomeModelProtocol {
    weak var controller: HomeController!
    
    func openRoverMissionPage(_ rover: RoverType) {
        controller.openMission(with: ConfigurationService(with: rover).missionPageUrl)
    }
}
