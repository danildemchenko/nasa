//
//  UIFont + ext.swift
//  nasa
//
//  Created by Danil Demchenko on 08.10.2022.
//

import UIKit

extension UIFont {
    
    static func getGillSansRegular(ofSize: CGFloat) -> UIFont {
        UIFont(name: "GillSans", size: ofSize) ?? UIFont()
    }
}
