//
//  Constants.swift
//  nasa
//
//  Created by Danil Demchenko on 08.10.2022.
//

import UIKit

enum Constants {
    enum Color {
        static let primary = UIColor(hexString: "848B9B")
        static let title = UIColor(hexString: "2C2E30")
        static let description = UIColor(hexString: "6E7584")
        static let secondary = UIColor(hexString: "536DFE")
    }
    
    enum PrimaryDateFormatter {
        static var request: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter
        }
        
        static var manifest: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter
        }
    }
}
