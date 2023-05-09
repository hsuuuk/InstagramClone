//
//  ProfileNavigationView.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/09.
//

import UIKit
import SnapKit

class ProfileNavigationView: UIView {
     
    var userNameLable: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        lb.textAlignment = .left
        return lb
    }()
    
    private lazy var settingButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(systemName: "bag"), for: .normal)
        bt.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        bt.tintColor = .black
        return bt
    }()
    
    private lazy var addPostButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(systemName: "bag"), for: .normal)
        bt.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        bt.tintColor = .black
        return bt
    }()
    
    init(userName: String) {
        super.init(frame: .zero)
        
        setupLayout()
        userNameLable.text = userName
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(userNameLable)
        userNameLable.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        })
        
//        addSubview(settingButton)
//        settingButton.snp.makeConstraints({ make in
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview()
//        })
//
//        addSubview(addPostButton)
//        addPostButton.snp.makeConstraints({ make in
//            make.centerY.equalToSuperview()
//            make.right.equalTo(settingButton.snp.left).offset(-10)
//        })
    }
    
    @objc func buttonTapped() {
    }
}
