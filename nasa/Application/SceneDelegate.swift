//
//  SceneDelegate.swift
//  nasa
//
//  Created by Danil Demchenko on 07.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        let homeModel = HomeModel(nasaApiService: NasaApiService(), storageService: StorageService())
        let homeController = HomeController(homeView: HomeView(), model: homeModel)

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = homeController
        window?.makeKeyAndVisible()
    }
}
