//
//  Localization.swift
//  nasa
//
//  Created by Danil Demchenko on 14.10.2022.
//

import UIKit

enum Localization {
    enum MainScreen {
        static let subtitle = NSLocalizedString("main_screen.subtitle", comment: "")
        static let mission = NSLocalizedString("main_screen.mission", comment: "")
        static let moreButton = NSLocalizedString("main_screen.more_button", comment: "")
        static let fetchButton = NSLocalizedString("main_screen.fetch_button", comment: "")
        
        enum Rover {
            enum Top {
                static let title = NSLocalizedString("main_screen.top-rover_title", comment: "")
                static let description = NSLocalizedString("main_screen.top-rover_description", comment: "")
            }
            enum Left {
                static let title = NSLocalizedString("main_screen.left-rover_title", comment: "")
                static let description = NSLocalizedString("main_screen.left-rover_description", comment: "")
            }
            enum Right {
                static let title = NSLocalizedString("main_screen.right-rover_title", comment: "")
                static let description = NSLocalizedString("main_screen.right-rover_description", comment: "")
            }
        }
    }
    
    enum Error {
        static let general = NSLocalizedString("error.message.general", comment: "")
        static let server = NSLocalizedString("error.message.server", comment: "")
    }
}
