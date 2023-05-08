//
//  SceneDelegate.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: windowScene)
//
//        let tabBarController = UITabBarController()
//
//        let VC1 = UINavigationController(rootViewController: FeedController())
//        VC1.view.backgroundColor = .white
//
//        let VC2 = UINavigationController(rootViewController: SearchController())
//        VC2.view.backgroundColor = .white
//
//        let VC3 = UINavigationController(rootViewController: ImageSelectorController())
//        VC3.view.backgroundColor = .white
//
//        let VC4 = UINavigationController(rootViewController: NotificationController())
//        VC4.view.backgroundColor = .white
//
//        let VC5 = UINavigationController(rootViewController: ProfileController())
//        VC5.view.backgroundColor = .white
//
//        tabBarController.setViewControllers([VC1, VC2, VC3, VC4, VC5], animated: false)
//
//        guard let items = tabBarController.tabBar.items else { return }
//        items[0].image = UIImage(systemName: "house")
//        items[1].image = UIImage(systemName: "magnifyingglass")
//        items[2].image = UIImage(systemName: "plus.app")
//        items[3].image = UIImage(systemName: "heart")
//        items[4].image = UIImage(systemName: "person")
//
//        tabBarController.tabBar.backgroundColor = .black
//        tabBarController.tabBar.tintColor = .white
//        tabBarController.tabBar.unselectedItemTintColor = .darkGray
//
//        tabBarController.selectedIndex = 0
//
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        window?.rootViewController = MainTabController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

