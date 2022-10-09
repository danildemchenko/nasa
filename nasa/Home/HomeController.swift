//
//  HomeController.swift
//  nasa
//
//  Created by Danil Demchenko on 07.10.2022.
//

import UIKit
import SafariServices

final class HomeController: UIViewController {
    
    var _view = HomeView()
    
    private let model = HomeModel()
    
    override func loadView() {
        view = _view
    }
    
    override func viewDidLoad() {
        model.controller = self
        _view.controller = self
        
        model.getRovers()
    }
    
    func setData(_ data: [HomeModel.Rover]) {
        _view.setupView(with: data)
    }
    
    func openMission(with url: URL) {
        let safariController = SFSafariViewController(url: url)
        safariController.modalPresentationStyle = .popover
        present(safariController, animated: true)
    }
}
