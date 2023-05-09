//
//  ProfileCell.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import SnapKit

class ProfileCell: UICollectionViewCell {
    
    var viewModel: PostViewModel? {
        didSet { configure() }
    }
    
    var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        //postImageView.sd_setImage(with: viewModel.imageUrl)
    }
}
