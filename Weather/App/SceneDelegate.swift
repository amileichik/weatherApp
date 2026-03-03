//
//  SceneDelegate.swift
//  Weather
//
//  Created by Александр Милейчик on 2/27/26.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var appDependencies: AppDependenciesProtocol = AppDependencies()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        window.rootViewController = UINavigationController(rootViewController: appDependencies.makeRootViewController())
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
