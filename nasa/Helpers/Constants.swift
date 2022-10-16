//
//  Constants.swift
//  nasa
//
//  Created by Danil Demchenko on 08.10.2022.
//

import UIKit

enum Constants {
    static let unit = UIScreen.main.bounds.width / 375
    
    enum Color {
        static let primary = UIColor(hexString: "848B9B")
        static let title = UIColor(hexString: "2C2E30")
        static let description = UIColor(hexString: "6E7584")
        static let secondary = UIColor(hexString: "536DFE")
    }
    
    enum Offset {
        static let basic = 16 * Constants.unit
    }
}
