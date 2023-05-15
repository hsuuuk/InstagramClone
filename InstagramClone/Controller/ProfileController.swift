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
    func didTapFollow(header: ProfileHeader) {
        viewModel.toggleFollow { isFollowed in
            DispatchQueue.main.async {
                if self.viewModel.user.isCurrentUser == false {
                    header.edit_followButton.setTitle(isFollowed ? "팔로우" : "팔로잉", for: .normal)
                    header.edit_followButton.setTitleColor(isFollowed ? .black : .white, for: .normal)
                    header.edit_followButton.backgroundColor = isFollowed ? UIColor.systemGray6 : UIColor.systemBlue
                    header.share_messageButton.setTitle("메세지", for: .normal)
                    self.viewModel.fetchUser()
                    self.viewModel.onUpdated()
                }
            }
        }
    }
}

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UIViewController {
    
    private var viewModel: UserViewModel

    lazy var navigationView = ProfileNavigationView(userName: viewModel.user.userName)
    
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
        viewModel.onUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = viewModel.user.userName
        viewModel.fetchPost()
        viewModel.fetchUser()
    }
    
    init(user: UserData) {
        self.viewModel = UserViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        return viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        
        let post = viewModel.posts[indexPath.row]
        cell.setup(post: post)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        
        header.setup(user: viewModel.user)

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
