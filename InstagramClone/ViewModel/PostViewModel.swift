//
//  PostViewModel.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit

struct PostViewModel {
    var post: Post
    
    var imageUrl: URL? { return URL(string: post.imageUrl) }
    
    var userImageUrl: URL? { return URL(string: post.ownerImageUrl)}
    
    var username: String { return post.ownerUsername}
    
    var caption: String { return post.caption }
    
    var likes: Int { return post.likes}
    
    var likesLableText: String { return "좋아요 \(post.likes)개"}
    
    var likeButtonTintColor: UIColor {
        return post.didLike ? .red : .black
    }
    
    var likeButtonImage: UIImage? {
        let imageName = post.didLike ? "like_selected" : "like_unselected"
        return UIImage(named: imageName)
    }
    
    var timestampString: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: post.timestamp)
    }
    
    init(post: Post) {
        self.post = post
    }
}
