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
    
    private var user: UserData
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
    
    init(user: UserData) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            // 좋아요 누른 사용자 확인
            self.posts.forEach { post in
                FirestoreManager.checkUserLikedPost(post: post) { didLike in
                    if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                        self.posts[index].didLike = didLike
                    }
                }
            }
            
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
        appearance.shadowColor = .lightGray
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
        cell.delegate = self
        
        cell.profileImageView.kf.setImage(with: URL(string: posts[indexPath.row].profileImageUrl))
        cell.postImageView.kf.setImage(with: URL(string: posts[indexPath.row].imageUrl))
        cell.userNameButton.setTitle(posts[indexPath.row].userName, for: .normal)
        cell.captionLable.text = posts[indexPath.row].caption
        cell.userNameButton.setTitle(posts[indexPath.row].userName, for: .normal)
        cell.likeLable.text = "좋아요 \(posts[indexPath.row].likes)개"
        cell.userNameButtonDown.setTitle(posts[indexPath.row].userName, for: .normal)
        
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

extension FeedController: FeedCellDelegate {
    func didTapUserName(cell: FeedCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = posts[indexPath.row]
        
        FirestoreManager.getUser(uid: post.uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
            self.navigationController?.navigationBar.tintColor = .black
            self.navigationController?.navigationBar.topItem?.title = ""
        }
    }
    
    func didTapLike(cell: FeedCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = posts[indexPath.row]
        
        print(post.didLike)
        post.didLike.toggle()
        print(post.didLike)

        if post.didLike {
            print("start like")
            FirestoreManager.likePost(post: post) {
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                post.likes += 1
                self.posts[indexPath.row] = post
                //NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like, post: post)
            }
        } else {
            print("start unlike")
            FirestoreManager.unlikePost(post: post) {
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                post.likes -= 1
                self.posts[indexPath.row] = post
            }
        }
    }
    
    func didTapComment(cell: FeedCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let controller = CommentController(user: user, post: posts[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}
