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
        let homeController = HomeController(homeView: HomeView(), model: HomeModel())

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = homeController
        window?.makeKeyAndVisible()
    }
}
