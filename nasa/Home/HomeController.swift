//
//  HomeController.swift
//  nasa
//
//  Created by Danil Demchenko on 07.10.2022.
//

import UIKit
import SafariServices

final class HomeController: UIViewController {
    
    private var homeView: HomeViewProtocol
    private var model: HomeModelProtocol
    
    init(homeView: HomeViewProtocol, model: HomeModelProtocol) {
        self.homeView = homeView
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        homeView = HomeView()
        model = HomeModel(nasaApiService: NasaApiService(), storageService: StorageService())
        
        super.init(coder: coder)
    }
    
    override func loadView() {
        // MARK: substitution => native view of UIViewController with custom homeView
        view = homeView as? UIView
    }
    
    override func viewDidLoad() {
        model.controller = self
        homeView.controller = self
    }
    
    func openMission(with url: URL) {
        let safariController = SFSafariViewController(url: url)
        safariController.modalPresentationStyle = .popover
        present(safariController, animated: true)
    }
    
    func selectedRover(_ rover: RoverType) {
        model.openRoverMissionPage(rover)
    }
    
    func openRover(with manifest: Manifest, and rover: RoverType) {
        let model = RoverPhotosModel(nasaApiService: NasaApiService())
        let roverPhotosController = RoverPhotosController(model: model,
                                                          roverPhotosView: RoverPhotosView(),
                                                          rover: rover)
        roverPhotosController.setupManifestData(manifest)
        roverPhotosController.modalPresentationStyle = .overFullScreen
        present(roverPhotosController, animated: true)
    }
    
    func selectedIndexRover(_ index: Int) {
        model.fetchManifest(for: RoverType(rawValue: index)!)
    }
}
