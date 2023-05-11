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
        self.delegate = self
        checkLogin()
        getUser()
    }
    
    // MARK: - Helpers
    
    func getUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
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
        let VC1 = FeedController(user: user)
        let VC2 = SearchController()
        let VC3 = PostController()
        let VC4 = NotificationController()
        let VC5 = ProfileController(user: user)

        let feed = navigationController(normalImage: #imageLiteral(resourceName: "Home"), selectedImage: #imageLiteral(resourceName: "Home_Selected"), rootViewController: VC1)
        let search = navigationController(normalImage: #imageLiteral(resourceName: "Search"), selectedImage: #imageLiteral(resourceName: "Search_Selected"), rootViewController: VC2)
        let post = navigationController(normalImage: #imageLiteral(resourceName: "Post"), selectedImage: #imageLiteral(resourceName: "Post"), rootViewController: VC3)
        let notification = navigationController(normalImage: #imageLiteral(resourceName: "Reels"), selectedImage: #imageLiteral(resourceName: "Reels_Selected"), rootViewController: VC4)
        let profile = navigationController(normalImage: UIImage(systemName: "person.circle")!, selectedImage: UIImage(systemName: "person.circle.fill")!, rootViewController: VC5)

        self.setViewControllers([feed, search, post, notification, profile], animated: true)
        
        setupTabBarColor()
    }

    func navigationController(normalImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let controller = UINavigationController(rootViewController: rootViewController)
        controller.tabBarItem.image = normalImage
        controller.tabBarItem.selectedImage = selectedImage
    
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        controller.navigationBar.standardAppearance = navigationBarAppearance
        controller.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        return controller
    }
    
    func setupTabBarColor() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.black
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.black
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}

extension MainTabController: LoginDelegate {
    func loginComplete() {
        getUser()
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

                let controller = UploadController()
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

