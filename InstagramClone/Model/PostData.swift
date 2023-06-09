//
//  PostData.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/08.
//

import Foundation
import Firebase

struct PostData {
    var caption: String
    var likes: Int
    var imageUrl: String
    var date: Timestamp
    var postId: String
    var uid: String
    var profileImageUrl: String
    var userName: String
    
    var didLike: Bool = false
    var commentCount: Int = 0

    init(postId: String, data: [String: Any]) {
        self.postId = postId
        self.caption = data["caption"] as? String ?? ""
        self.likes = data["likes"] as? Int ?? 0
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.date = data["date"] as? Timestamp ?? Timestamp(date: Date())
        self.uid = data["uid"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.userName = data["userName"] as? String ?? ""
    }
}
