//
//  UIView + ext.swift
//  nasa
//
//  Created by Danil Demchenko on 21.10.2022.
//

import UIKit

extension UIView {
    func addSystemShadows() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 2, height: 2)
    }
}
