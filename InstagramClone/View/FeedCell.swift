//
//  FeedCell.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit

protocol FeedCellDelegate: AnyObject {
    func didTapUserName()
    func didTapLike(_ cell: FeedCell, post: PostData)
    func didTapComment(_ cell: FeedCell, post: PostData)
}

class FeedCell: UICollectionViewCell {
    
    // MARK:  Properties
    
    var viewModel: PostViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: FeedCellDelegate?
    
    var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapUserName))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        iv.image = UIImage(named: "Faker")
        return iv
    }()
    
    lazy var userNameButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        bt.addTarget(self, action: #selector(didTapUserName), for: .touchUpInside)
        return bt
    }()
    
    var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(named: "중꺽마")
        return iv
    }()
    
    private lazy var likeButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        bt.tintColor = .black
        bt.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return bt
    }()
    
    private lazy var commentButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        bt.tintColor = .black
        bt.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        return bt
    }()
    
    private lazy var shareButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        bt.tintColor = .black
        return bt
    }()
    
    var likeLable: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        lb.text = "좋아요 50개"
        return lb
    }()
    
    var captionLable: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.text = "팬이에요."
        return lb
    }()
    
    var postTimeLable: UILabel = {
        let lb = UILabel()
        lb.text = "1일 전"
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        lb.textColor = .lightGray
        return lb
    }()

    // MARK: LifCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(profileImageView) // self.contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
            make.height.width.equalTo(40)
        }
        profileImageView.layer.cornerRadius = 40/2
        
        addSubview(userNameButton)
        userNameButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(8)
        }
        
        addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        configureActionButtons()
        
        addSubview(likeLable)
        likeLable.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(-5)
            make.left.equalToSuperview().offset(10)
        }

        addSubview(captionLable)
        captionLable.snp.makeConstraints { make in
            make.top.equalTo(likeLable.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
        }

        addSubview(postTimeLable)
        postTimeLable.snp.makeConstraints { make in
            make.top.equalTo(captionLable.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Action
    
    @objc func didTapUserName() {
        //delegate?.didTapUserName(self, uid: viewModel.post.ownerUid)
    }
    
    @objc func didTapLike() {
        //delegate?.didTapLike(self, post: viewModel.post)
    }
    
    @objc func didTapComments() {
        //delegate?.didTapComment(self, post: viewModel.post)
    }
    
    // MARK: Helper
    
    func configure() {
        guard let viewModel = viewModel else { return }
//        profileImageView.sd_setImage(with: viewModel.userImageUrl)
//        userNameButton.setTitle(viewModel.username, for: .normal)
//
//        PostImageView.sd_setImage(with: viewModel.imageUrl)
//
//        likeButton.tintColor = viewModel.likeButtonTintColor
//        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
//        likeLable.text = viewModel.likesLableText
//
//        captionLable.text = viewModel.caption
//
//        postTimeLable.text = viewModel.timestampString
    }
    
    func configureActionButtons() {
        let buttonStackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
    }
}

