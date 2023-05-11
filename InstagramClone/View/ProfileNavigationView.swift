//
//  ProfileNavigationView.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/09.
//

import UIKit
import SnapKit

protocol LogoutDelegate: AnyObject {
    func didTapLogout()
}

class ProfileNavigationView: UIView {
     
    weak var delegate: LogoutDelegate?
    
    var userNameLable: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return lb
    }()
    
    private lazy var logoutButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.forward"), for: .normal)
        bt.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        bt.tintColor = .black
        return bt
    }()
    
    private lazy var addPostButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "Post"), for: .normal)
        bt.tintColor = .black
        return bt
    }()
    
    init(userName: String) {
        super.init(frame: .zero)
        backgroundColor = .white
        setupLayout()
        userNameLable.text = userName
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(userNameLable)
        userNameLable.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
        })

        addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        addSubview(addPostButton)
        addPostButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalTo(logoutButton.snp.left).offset(-20)
        }
    }
    
    @objc func logoutButtonTapped() {
        delegate?.didTapLogout()
    }
}
