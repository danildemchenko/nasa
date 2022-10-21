//
//  ManifestController.swift
//  nasa
//
//  Created by Danil Demchenko on 18.10.2022.
//

import UIKit

final class RoverPhotosController: UIViewController {
    
    var roverPhotosView: RoverPhotosViewProtocol
    var rover: RoverType
    
    private var model: RoverPhotosModel
    
    init(model: RoverPhotosModel, roverPhotosView: RoverPhotosViewProtocol, rover: RoverType) {
        self.model = model
        self.roverPhotosView = roverPhotosView
        self.rover = rover
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        model = RoverPhotosModel(nasaApiService: NasaApiService())
        roverPhotosView = RoverPhotosView()
        rover = RoverType(rawValue: 0)!
       
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = roverPhotosView as? UIView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        model.fetchRoverPhotosByEarthDate(rover: .opportunity,
                                          date: Constants.CustomDataFormatter.request.date(from: "2015-6-3")!,
                                          page: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.controller = self
    }
        
    func setupManifestData(_ manifest: Manifest) {
        roverPhotosView.manifest = manifest
        roverPhotosView.backgroundImage = UIImage(named: rover.stringValue)
    }
    
    func setupPhotosByEarthDate(_ photos: [RoverPhoto]) {
        roverPhotosView.photos = photos
    }
}
