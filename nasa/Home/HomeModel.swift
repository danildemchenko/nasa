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
    func moveToManifestScreen(with roverIndex: Int)
}

enum RoverType: Int, CaseIterable {
    case opportunity
    case spirit
    case curiosity
    
    var configName: String {
        switch self {
        case .opportunity: return "OpportunityConfig"
        case .spirit: return "SpiritConfig"
        case .curiosity: return "CuriosityConfig"
        }
    }
    
    var stringValue: String {
        switch self {
        case .opportunity: return "opportunity"
        case .spirit: return "spirit"
        case .curiosity: return "curiosity"
        }
    }
    
    var homeImage: String {
        switch self {
        case .opportunity: return "opportunity_home"
        case .spirit: return "spirit_home"
        case .curiosity: return "curiosity_home"
        }
    }
}

final class HomeModel: HomeModelProtocol {
    weak var controller: HomeController!
    
    func openRoverMissionPage(_ rover: RoverType) {
        controller.openMission(with: ConfigurationService(with: rover).missionPageUrl)
    }
    
    func moveToManifestScreen(with roverIndex: Int) {
        controller.openManifest(for: RoverType(rawValue: roverIndex)!)
    }
}
