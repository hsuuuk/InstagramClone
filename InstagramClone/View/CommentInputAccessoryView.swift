//
//  CommentInputAccessoryView.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/09.
//

import UIKit

protocol CommentInputAccessoryViewDelegate: AnyObject {
    func didTapPostButton(_ inputView: CommentInputAccessoryView, commment: String)
}

class CommentInputAccessoryView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CommentInputAccessoryViewDelegate?
    
    private let commentTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "댓글 달기..."
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        //tv.placeholderShouldCenter = true
        return tv
    }()
    
    private let postButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("게시", for: .normal)
        bt.setTitleColor(.systemBlue, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        bt.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        return bt
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(postButton)
        postButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.width.height.equalTo(50)
        }
        
        addSubview(commentTextView)
        commentTextView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.right.equalTo(postButton.snp.left).offset(-8)
        }
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - Actions
    
    @objc func handlePostTapped() {
        delegate?.didTapPostButton(self, commment: commentTextView.text)
    }
    
    // MARK: - Helpers
    
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }
}

