//
//  ProfileController.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import Kingfisher
import Firebase

extension ProfileController: FollowButtonDelegate {
    func didTapFollow(profileHeader: ProfileHeader) {
        if user.isCurrentUser {
            
        } else if user.isFollowed {
            FirestoreManager.unfollow(uid: user.uid) {
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            FirestoreManager.follow(uid: user.uid) {
                self.user.isFollowed = true
                self.collectionView.reloadData()
            }
        }
    }
}

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UIViewController {
        
    private var user: UserData {
        didSet { collectionView.reloadData() }
    }
    private var posts = [PostData]() {
        didSet { collectionView.reloadData() }
    }
    
    lazy var navigationView = ProfileNavigationView(userName: user.userName)
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 3
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        return collectionView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = user.userName
        getData()
    }
    
    init(user: UserData) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getData() {
        getPost()
        checkUserIsFollowed()
        getUserStats()
    }
    
    func getPost() {
        FirestoreManager.getPost(uid: user.uid) { posts in
            self.posts = posts
        }
    }
    
    func checkUserIsFollowed() {
        FirestoreManager.checkUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
        }
    }
    
    func getUserStats() {
        FirestoreManager.getUserStats(uid: user.uid) { userState in
            self.user.userStats = userState
        }
    }
    
    func setupLayout() {
        navigationView.delegate = self
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func rightBarButtonTapped() {
    }
}

extension ProfileController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        cell.postImageView.kf.setImage(with: URL(string: posts[indexPath.row].imageUrl))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        header.nameLabel.text = user.fullName
        header.profileImageView.kf.setImage(with: URL(string: user.profileImageUrl))
        header.postsLabel.attributedText = header.attributedStateText(value: user.userStats.posts, lable: "게시물")
        header.followersLable.attributedText = header.attributedStateText(value: user.userStats.followers, lable: "팔로우")
        header.followingsLable.attributedText = header.attributedStateText(value: user.userStats.following, lable: "팔로잉")
        
        if user.isCurrentUser == false {
            header.edit_followButton.setTitle(user.isFollowed ? "팔로우" : "팔로잉", for: .normal)
            header.edit_followButton.setTitleColor(user.isFollowed ? .black : .white, for: .normal)
            header.edit_followButton.backgroundColor = user.isFollowed ? UIColor.systemGray6 : UIColor.systemBlue
            
            header.share_messageButton.setTitle("메세지", for: .normal)
        }

        return header
    }
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 6) / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
}

extension ProfileController: LogoutDelegate {
    func didTapLogout() {
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
