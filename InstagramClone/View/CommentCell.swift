//
//  CommentCell.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/09.
//

import UIKit
import SnapKit

class CommentCell : UICollectionViewCell  {
    
    var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40 / 2
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    var commentLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        return lb
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.width.height.equalTo(40)
        }

        addSubview(commentLabel)
        commentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(profileImageView.snp.left).offset(8)
            make.right.equalToSuperview().offset(-8)
        }
    }
}
