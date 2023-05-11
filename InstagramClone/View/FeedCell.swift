//
//  FeedCell.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit

protocol FeedCellDelegate: AnyObject {
    func didTapUserName(cell: FeedCell)
    func didTapLike(cell: FeedCell)
    func didTapComment(cell: FeedCell)
    func didTapComent2(cell: FeedCell)
}

class FeedCell: UICollectionViewCell {
    
    // MARK:  Properties
    
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
    
    lazy var userNameButtonDown: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        bt.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -1, right: 0)
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
    
    lazy var likeButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
        bt.tintColor = .black
        bt.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return bt
    }()
    
    private lazy var commentButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "Comment"), for: .normal)
        bt.tintColor = .black
        bt.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        return bt
    }()
    
    private lazy var shareButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "Share"), for: .normal)
        bt.tintColor = .black
        return bt
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "Bookmark"), for: .normal)
        bt.tintColor = .black
        return bt
    }()
    
    var likeLable: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        return lb
    }()
    
    var captionLable: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.text = "팬이에요."
        return lb
    }()
    
    lazy var commentButton2: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("댓글 0개 보기", for: .normal)
        bt.setTitleColor(.lightGray, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        bt.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -1, right: 0)
        bt.addTarget(self, action: #selector(didTapCommentButton2), for: .touchUpInside)
        return bt
    }()
    
    var dateLable: UILabel = {
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
        
        let buttonStackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(5)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.centerY.equalTo(buttonStackView)
            make.right.equalToSuperview().offset(-20)
        }
        
        addSubview(likeLable)
        likeLable.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
        }
        
        addSubview(userNameButtonDown)
        userNameButtonDown.snp.makeConstraints { make in
            make.top.equalTo(likeLable.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
        }

        addSubview(captionLable)
        captionLable.snp.makeConstraints { make in
            make.top.equalTo(likeLable.snp.bottom).offset(5)
            make.left.equalTo(userNameButtonDown.snp.right).offset(5)
        }
        
        addSubview(commentButton2)
        commentButton2.snp.makeConstraints { make in
            make.top.equalTo(captionLable.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
        }

        addSubview(dateLable)
        dateLable.snp.makeConstraints { make in
            make.top.equalTo(commentButton2.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Action
    
    @objc func didTapUserName() {
        delegate?.didTapUserName(cell: self)
    }
    
    @objc func didTapLike() {
        delegate?.didTapLike(cell: self)
    }
    
    @objc func didTapComment() {
        delegate?.didTapComment(cell: self)
    }
    
    @objc func didTapCommentButton2() {
        delegate?.didTapComent2(cell: self)
    }
}

