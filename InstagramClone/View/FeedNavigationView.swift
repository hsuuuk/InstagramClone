//
//  FeedNavigationView.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/10.
//

import UIKit
import SnapKit

class FeedNavigationView: UIView {
     
    var userNameLable: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return lb
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Instagram_logo_black")
        return iv
    }()
    
    private lazy var likeButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "Like"), for: .normal)
        bt.tintColor = .black
        return bt
    }()
    
    private lazy var shareButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "Share"), for: .normal)
        bt.tintColor = .black
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
            make.width.equalTo(125)
            make.height.equalTo(45)
        })

        addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-20)
        }
        
        addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalTo(shareButton.snp.left).offset(-20)
        }
    }
}

