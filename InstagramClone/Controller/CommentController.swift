//
//  CommentController.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/08.
//

import UIKit
import SnapKit
import Kingfisher

private let cellIdentifier = "CommentCell"

class CommentController : UIViewController {
    
    // MARK: - Properties
    
    private let user: UserData
    private let post: PostData
    private var comments = [CommentData]() {
        didSet { self.collectionView.reloadData() }
    }
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 3
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        return collectionView
    }()
    
    private lazy var commentInputView : CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccessoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Lifecycle
    
    init(user: UserData, post : PostData) {
        self.user = user
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        fetchComments()
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
     // MARK: - API
    
    func fetchComments() {
//        FirestoreManager.getCommnet(post: post.postId) { comment in
//            self.comments = comment
//        }
    }
    
    // MARK: - Helpers
    
    func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.title = "댓글"
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
    }
}

// MARK: - UICOllectionViewDataSource

extension CommentController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CommentCell
        cell.commentLabel.text = comments[indexPath.row].comment
        cell.profileImageView.kf.setImage(with: URL(string: comments[indexPath.row].profileImageUrl))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CommentController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let viewModel = CommentViewModel(comment: comments[indexPath.row])
//        let height = viewModel.size(forWidth: view.frame.width).height + 32
//        return CGSize(width: view.frame.width, height: height)
        return CGSize(width: 100, height: 100)
    }
}

// MARK: - UICollectionViewDelegate

extension CommentController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = comments[indexPath.row].uid
        FirestoreManager.getUser(uid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
            self.navigationController?.navigationBar.tintColor = .black
            self.navigationController?.navigationBar.topItem?.title = ""
        }
    }
}

// MARK: - CommentInputAccessoryViewDelegate

extension CommentController: CommentInputAccessoryViewDelegate {
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String) {
//        guard let tab = self.tabBarController as? MainTabController else  { return }
//        guard let currentUser = tab.user else { return }
//
//        showLoader(true)
//
//        CommentService.uploadComment(comment: comment, postID: post.postId, user: currentUser) { [self] error in
//            self.showLoader(false)
//            inputView.clearCommentTextView()
//
//            NotificationService.uploadNotification(toUid: self.post.ownerUid, fromUser: currentUser, type: .comment, post: self.post)
//        }
    }
}
