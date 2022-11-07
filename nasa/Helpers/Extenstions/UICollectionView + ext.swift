//
//  UICollectionView + ext.swift
//  nasa
//
//  Created by Danil Demchenko on 03.11.2022.
//

import UIKit

extension UICollectionView {
    func cell<T: UICollectionViewCell>(forClass cellType: T.Type = T.self, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: cellType), for: indexPath) as? T else {
            return T()
        }
        return cell
    }
    
    func register<T: UICollectionViewCell>(cellType: T.Type = T.self) {
        register(cellType, forCellWithReuseIdentifier: String(describing: cellType))
    }
}
