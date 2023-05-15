//
//  ProfileHeader.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import SnapKit

protocol FollowButtonDelegate: AnyObject {
    func didTapFollow(header: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    
    weak var delegate: FollowButtonDelegate?
    
    var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 80 / 2
        return iv
    }()
    
    var nameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.textColor = .black
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var edit_followButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("프로필 편집", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        bt.backgroundColor = .systemGray6
        bt.layer.cornerRadius = 8
        bt.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return bt
    }()
    
    lazy var share_messageButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("프로필 공유", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        bt.backgroundColor = .systemGray6
        bt.layer.cornerRadius = 8
        bt.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return bt
    }()
    
    lazy var postsLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var followersLable: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var followingsLable: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    
    private let gridButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "Grid"), for: .normal)
        bt.tintColor = .black
        return bt
    }()
    
    private let listButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "Reels"), for: .normal)
        bt.tintColor = UIColor(white: 0, alpha: 0.2)
        bt.tintColor = .gray
        return bt
    }()
    
    private let bookmarkButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "Tag"), for: .normal)
        bt.tintColor = UIColor(white: 0, alpha: 0.2)
        bt.tintColor = .gray
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleEditProfileFollowTapped() {
        delegate?.didTapFollow(header: self)
    }
    
    func setup(user: UserData) {
        nameLabel.text = user.fullName
        profileImageView.kf.setImage(with: URL(string: user.profileImageUrl))
        postsLabel.attributedText = attributedStateText(value: user.userStats.posts, lable: "게시물")
        followersLable.attributedText = attributedStateText(value: user.userStats.followers, lable: "팔로우")
        followingsLable.attributedText = attributedStateText(value: user.userStats.following, lable: "팔로잉")
        
        if user.isCurrentUser == false {
            edit_followButton.setTitle(user.isFollowed ? "팔로우" : "팔로잉", for: .normal)
            edit_followButton.setTitleColor(user.isFollowed ? .black : .white, for: .normal)
            edit_followButton.backgroundColor = user.isFollowed ? UIColor.systemGray6 : UIColor.systemBlue
            share_messageButton.setTitle("메세지", for: .normal)
        }
    }
    
    func setupLayout() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(12)
            make.height.width.equalTo(80)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(15)
        }
        
        let stackView1 = UIStackView(arrangedSubviews: [postsLabel, followersLable, followingsLable])
        stackView1.distribution = .fillEqually
        stackView1.axis = .horizontal
        addSubview(stackView1)
        stackView1.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
        
        let stackView2 = UIStackView(arrangedSubviews: [edit_followButton, share_messageButton])
        stackView2.distribution = .fillEqually
        stackView2.spacing = 5
        addSubview(stackView2)
        stackView2.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(30)
        }
        
        let stackView3 = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView3.distribution = .fillEqually
        addSubview(stackView3)
        stackView3.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        addSubview(bottomDivider)
        bottomDivider.snp.makeConstraints { make in
            make.top.equalTo(stackView3.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    func attributedStateText(value: Int, lable: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: lable, attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
}
