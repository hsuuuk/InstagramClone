//
//  CommentData.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/09.
//

import Foundation
import Firebase

struct CommentData {
    let uid : String
    let userName : String
    let profileImageUrl : String
    let comment : String
    let date : Timestamp
    let commentId: String
    
    init(commentId: String, data : [String : Any]) {
        self.commentId = commentId
        self.uid = data["uid"] as? String ?? ""
        self.userName = data["userName"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.comment = data["comment"] as? String ?? ""
        self.date = data["date"] as? Timestamp ?? Timestamp(date: Date())
    }
}
