//
//  HomeController.swift
//  nasa
//
//  Created by Danil Demchenko on 07.10.2022.
//

import UIKit
import SafariServices

final class HomeController: UIViewController {
    
    private var _view: HomeViewProtocol
    
    private var model: HomeModelProtocol
    
    init(_view: HomeViewProtocol, model: HomeModelProtocol) {
        self._view = _view
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        _view = HomeView()
        model = HomeModel()
        
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = _view as? UIView
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
