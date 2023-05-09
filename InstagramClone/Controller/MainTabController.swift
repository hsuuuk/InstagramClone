//
//  MainTabController.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import FirebaseAuth
import YPImagePicker

class MainTabController: UITabBarController {
    
    // MARK: - Properties
        
    var user: UserData? {
        didSet {
            guard let user = user else { return }
            setupController(user: user)
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogin()
        fetchUser()
    }
    
    // MARK: - Helpers
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        UserService.fetchUser(withUid: uid) { user in
//            self.user = user
//        }
        
        FirestoreManager.getUser(uid: uid) { userData in
            self.user = userData
        }
    }
    
    func checkLogin() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }
        }
    }
    
    func setupController(user: UserData) {
        self.delegate = self
        
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(user: user))
        
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        
        let notification = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())
        
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: ProfileController(user: user))
        
        viewControllers = [feed, search, imageSelector, notification, profile]
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        self.tabBar.tintColor = .black
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            nav.navigationBar.standardAppearance = appearance
            nav.navigationBar.scrollEdgeAppearance = appearance
            
            let tabBarappearance = UITabBarAppearance()
            tabBarappearance.backgroundColor = .white
            nav.tabBarItem.standardAppearance = tabBarappearance
            nav.tabBarItem.scrollEdgeAppearance = tabBarappearance
        }
        
//        if #available(iOS 15, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = UIColor.white
//            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
//            UINavigationBar.appearance().standardAppearance = appearance
//            UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        }
        
//        if #available(iOS 15.0, *) {
//            let appearance = UITabBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .white
//            UITabBar.appearance().standardAppearance = appearance
//            UITabBar.appearance().scrollEdgeAppearance = appearance
//        }
        
        return nav
    }
}

// MARK: - AuthenticationDelegate

extension MainTabController: LoginDelegate {
    func loginComplete() {
        fetchUser()
        self.dismiss(animated: true)
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true)
            
            didFinishPickingMedia(picker)
        }
        return true
    }
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }

                let controller = UploadPostController()
                controller.selectedImage = selectedImage
                //controller.delegate = self
                controller.currentUser = self.user

                let navigationController = UINavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: false)
            }
        }
    }
}

// MARK: - UploadPostControllerDelegate

//extension MainTabController: UploadPostControllerDelegate {
//    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
//        selectedIndex = 0
//        controller.dismiss(animated: true)
//        
//        // 업로드 후 FeedController를 다시 첫화면으로
//        guard let feedNav = viewControllers?.first as? UINavigationController else { return }
//        guard let feed = feedNav.viewControllers.first as? FeedController else { return }
//        feed.handleRefresh()
//        viewControllers?.first
//    }
//}

