//
//  Post.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import Foundation

struct Post {
    var caption: String
    var likes: Int
    var imageUrl: String
    var ownerUid: String
    var timestamp: Date
    var postId: String
    var ownerImageUrl: String
    var ownerUsername: String
    var didLike = false
    
    init(postId: String, dictionary: [String: Any]) {
        self.postId = postId
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Date ?? Date()
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
    }
}
