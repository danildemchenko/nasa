//
//  ManifestController.swift
//  nasa
//
//  Created by Danil Demchenko on 18.10.2022.
//

import UIKit

final class ManifestController: UIViewController {
    
    let rover: RoverType
    
    private var model: ManifestModelProtocol
    private var manifestView: ManifestViewProtocol

    init(model: ManifestModelProtocol, manifestView: ManifestViewProtocol, rover: RoverType) {
        self.model = model
        self.manifestView = manifestView
        self.rover = rover
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        model = ManifestModel(service: ManifestService(), storageService: StorageService())
        manifestView = ManifestView()
        rover = RoverType(rawValue: 0)!
        
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = manifestView as? UIView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchManifestData()
        model.fetchRoverPhotosByEarthDate(rover: .opportunity,
                                          date: Constants.PrimaryDateFormatter.request.date(from: "2015-6-3")!,
                                          page: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.controller = self
        manifestView.controller = self
    }
    
    func fetchManifestData() {
        model.fetchManifest(for: rover)
    }
    
    func setupPrimaryManifestData(_ manifest: ManifestModel.Manifest) {
        manifestView.manifest = manifest
        (manifestView as! UIView).backgroundColor = UIColor(patternImage: UIImage(named: rover.stringValue)!)
    }
    
    func setupPhotosByEarthDate(_ photos: [ManifestModel.RoverPhoto]) {
        manifestView.photos = photos
    }
}
