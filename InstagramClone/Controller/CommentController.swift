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
    
    private var viewModel: CommentViewModel
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 3
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()
    
    private lazy var inputTextView : CommentTextView = {
        let view = CommentTextView()
        view.delegate = self
        view.autoresizingMask = .flexibleHeight
        return view
    }()
    
    // MARK: - Lifecycle
    
    init(user: UserData, post : PostData) {
        self.viewModel = CommentViewModel(user: user, post: post)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.onUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.fetchComments()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override var inputAccessoryView: UIView? {
        get { return inputTextView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
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
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .lightGray
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "paperplane"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        rightBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func rightBarButtonTapped() {
    }
}

// MARK: - UICOllectionViewDataSource

extension CommentController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CommentCell
        
        let comment = viewModel.comments[indexPath.row]
        cell.setup(comment: comment)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CommentController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}

// MARK: - CommentInputAccessoryViewDelegate

extension CommentController: TextViewDelegate {
    func didTapPostButton(inputView: CommentTextView, commment: String) {
        viewModel.addComment(comment: commment)
        inputView.clearTextView()
        viewModel.fetchComments()
    }
}
