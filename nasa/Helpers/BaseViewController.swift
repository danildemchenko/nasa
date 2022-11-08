//
//  BaseViewController.swift
//  nasa
//
//  Created by Danil Demchenko on 08.11.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    func showErrorAlert(_ error: Error) {
        let errorMessage = getErrorAlertMessage(error)
        let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
    
    private func getErrorAlertMessage(_ error: Error) -> String {
        switch error as? ApiError {
        case .decode: return Localization.Error.general
        case .server: return Localization.Error.server
        default: return Localization.Error.general
        }
    }
}
