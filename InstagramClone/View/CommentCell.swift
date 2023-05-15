//
//  CommentCell.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/09.
//

import UIKit
import SnapKit

class CommentCell : UICollectionViewCell  {
    
    var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40 / 2
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var userNameButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        return bt
    }()
    
    var dateLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        lb.textColor = .gray
        return lb
    }()
    
    var commentLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        lb.numberOfLines = 0
        lb.lineBreakMode = .byWordWrapping
        return lb
    }()
    
    lazy var replyCommentButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("답글 달기", for: .normal)
        bt.setTitleColor(.gray, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        return bt
    }()
    
    lazy var likeButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "Like"), for: .normal)
        bt.tintColor = .black
        return bt
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(comment: CommentData) {
        commentLabel.text = comment.comment
        profileImageView.kf.setImage(with: URL(string: comment.profileImageUrl))
        userNameButton.setTitle(comment.userName, for: .normal)
        dateLabel.text = comment.date.dateValue().relativeTime()
    }

    func setupLayout() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(15)
            make.width.height.equalTo(40)
        }
        
        addSubview(userNameButton)
        userNameButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(profileImageView.snp.right).offset(10)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userNameButton)
            make.left.equalTo(userNameButton.snp.right).offset(5)
        }
        
        addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(15)
            make.width.equalTo(15)
        }

        addSubview(commentLabel)
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameButton.snp.bottom)
            make.left.equalTo(profileImageView.snp.right).offset(10)
            make.right.equalTo(likeButton.snp.left).offset(-15)
        }
        
        addSubview(replyCommentButton)
        replyCommentButton.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom)
            make.left.equalTo(profileImageView.snp.right).offset(10)
        }
    }
}
