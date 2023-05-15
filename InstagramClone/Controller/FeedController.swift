//
//  FeedController.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import Firebase
import Kingfisher

private let cellIdentifier = "FeedCell"

class FeedController: UIViewController {
        
    private var viewModel: PostViewModel
    
    let navigationView = FeedNavigationView()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.refreshControl = refresher
        
        return collectionView
    }()
    
    private lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresher
    }()
    
    init(user: UserData) {
        self.viewModel = PostViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.fetchPosts()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupLayout() {
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
    }
    
    @objc func handleRefresh() {
        viewModel.posts.removeAll()
        viewModel.fetchPosts()
        refresher.endRefreshing()
    }
}

extension FeedController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        
        let post = viewModel.getPost(at: indexPath.row)
        cell.setup(post: post)
        
        return cell
    }
}

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8 + 50 + 20 * 4
        return CGSize(width: width , height: height)
    }
}

extension FeedController: FeedCellDelegate {
    func didTapUserName(cell: FeedCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = viewModel.posts[indexPath.row]
        
        FirestoreManager.getUser(uid: post.uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
            self.navigationController?.navigationBar.tintColor = .black
            self.navigationController?.navigationBar.topItem?.title = ""
        }
    }
    
    func didTapLike(cell: FeedCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        var post = viewModel.toggleLike(post: viewModel.posts[indexPath.row]) { didLike in
            DispatchQueue.main.async {
                cell.likeButton.setImage(UIImage(named: didLike ? "Like_Selected" : "Like"), for: .normal)
                cell.likeButton.tintColor = didLike ? .red : .black
                self.viewModel.onUpdated()
            }
        }
    }
    
    func didTapComment(cell: FeedCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let controller = CommentController(user: viewModel.user, post: viewModel.posts[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapComent2(cell: FeedCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let controller = CommentController(user: viewModel.user, post: viewModel.posts[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}
