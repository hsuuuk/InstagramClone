//
//  FeedController.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import FirebaseAuth
import Kingfisher

private let cellIdentifier = "FeedCell"

class FeedController: UIViewController {
    
//    private let refresher = UIRefreshControl()
    
    private var posts = [PostData]() {
        didSet { collectionView.reloadData() }
    }

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPosts()
    }
    
    func getPosts() {
        FirestoreManager.getPost { posts in
            self.posts = posts
        }
    }
    
    func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
//        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
//        collectionView.refreshControl = refresher
        
        navigationItem.title = "게시물"
        
        let logoutBarButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"), style: .plain, target: self, action: #selector(logoutBarButtonTapped))
        logoutBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = logoutBarButton
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
//    @objc func handleRefresh() {
//        posts.removeAll()
//        fetchPosts()
//        refresher.endRefreshing()
//        //collectionView.reloadData()
//    }
    
    @objc func logoutBarButtonTapped() {
        do {
            try Auth.auth().signOut()
            let controller = UINavigationController(rootViewController: LoginController())
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension FeedController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FeedCell
        cell.profileImageView.kf.setImage(with: URL(string: posts[indexPath.row].profileImageUrl))
        cell.PostImageView.kf.setImage(with: URL(string: posts[indexPath.row].imageUrl))
        cell.userNameButton.titleLabel?.text = posts[indexPath.row].userName
        cell.captionLable.text = posts[indexPath.row].caption
        cell.userNameButton.setTitle(posts[indexPath.row].userName, for: .normal)
        return cell
    }
}

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width , height: height)
    }
}
