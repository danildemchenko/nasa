//
//  UIFont + ext.swift
//  nasa
//
//  Created by Danil Demchenko on 08.10.2022.
//

import UIKit

extension UIFont {
    
    static func getGillSansSemiBold(ofSize: CGFloat) -> UIFont {
        UIFont(name: "GillSans-SemiBold", size: ofSize) ?? UIFont()
    }
    
    static func getGillSansRegular(ofSize: CGFloat) -> UIFont {
        UIFont(name: "GillSans", size: ofSize) ?? UIFont()
    }
    
    static func getSFProDisplayBold(ofSize: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Bold", size: ofSize) ?? UIFont()
    }
    
    static func getSFProDisplayRegular(ofSize: CGFloat) -> UIFont {
        UIFont(name: "SFProDisplay-Regular", size: ofSize) ?? UIFont()
    }
}
