//
//  ProfileHeader.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import SnapKit
//import SDWebImage

//protocol ProfileHeaderDelegate: AnyObject {
//    func header(_ profilHeader: ProfileHeader, didTapActionButtonFor user: User)
//}

class ProfileHeader: UICollectionReusableView {
    
    var viewModel: ProfileHeaderViewModel? {
        didSet { configure() }
    }
    
    //weak var delegate: ProfileHeaderDelegate?
    
    var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        //iv.frame.size = CGSize(width: 80, height: 80)
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
    
    private lazy var editProfileFollowButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("프로필 편집", for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        bt.layer.cornerRadius = 5
        bt.layer.borderColor = UIColor.lightGray.cgColor
        bt.layer.borderWidth = 0.5
        bt.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return bt
    }()
    
    lazy var postsLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.attributedText = attributedStateText(value: 1, lable: "게시물")
        return lb
    }()
    
    lazy var followersLable: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.attributedText = attributedStateText(value: 1, lable: "팔로워")
        return lb
    }()
    
    lazy var followingsLable: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.attributedText = attributedStateText(value: 1, lable: "팔로잉")
        return lb
    }()
    
    private let gridButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return bt
    }()
    
    private let listButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        bt.tintColor = UIColor(white: 0, alpha: 0.2)
        return bt
    }()
    
    private let bookmarkButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        bt.tintColor = UIColor(white: 0, alpha: 0.2)
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleEditProfileFollowTapped() {
        //        guard let viewModel = viewModel else { return }
        //        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        //        nameLable.text = viewModel.fullname
        //        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        //
        //        editProfileFollowButton.setTitle(viewModel.followButtonText, for: .normal)
        //        editProfileFollowButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        //        editProfileFollowButton.backgroundColor = viewModel.followButtonBackgroundColor
        //
        //        postsLable.attributedText = viewModel.numberOfPosts
        //        followersLable.attributedText = viewModel.numberOfFollwers
        //        followingsLable.attributedText = viewModel.numberOfFollwing
    }
    
    func configureUI() {
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
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(30)
        }
        
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLable, followingsLable])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        buttonStackView.distribution = .fillEqually
        addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        addSubview(topDivider)
        topDivider.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        addSubview(bottomDivider)
        bottomDivider.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
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
