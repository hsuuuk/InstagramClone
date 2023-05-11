//
//  CommentInputAccessoryView.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/09.
//

import UIKit

protocol TextViewDelegate: AnyObject {
    func didTapPostButton(inputView: CommentTextView, commment: String)
}

class CommentTextView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: TextViewDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let commentTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let postButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("게시", for: .normal)
        bt.setTitleColor(.systemBlue, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        //bt.layer.borderWidth = 1
        bt.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        return bt
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 사이즈를 zero로 설정하여 내용의 크기에 맞게 동적으로 크기를 조절하도록 설정
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - Helpers
    
    func setupLayout() {
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        containerView.addSubview(postButton)
        postButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(8)
            make.right.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        containerView.addSubview(commentTextView)
        commentTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(0)
            make.right.equalTo(postButton.snp.left).offset(0)
        }
    }
    
    func clearTextView() {
        commentTextView.text = nil
    }
    
    // MARK: - Actions
    
    @objc func didTapPostButton() {
        delegate?.didTapPostButton(inputView: self, commment: commentTextView.text)
    }
}

