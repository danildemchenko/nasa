//
//  RoverType.swift
//  nasa
//
//  Created by Danil Demchenko on 21.10.2022.
//

import Foundation

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
