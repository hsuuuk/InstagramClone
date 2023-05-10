//
//  UserData.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/08.
//

import Foundation
import Firebase

struct UserData {
    let uid: String
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImageUrl: String
    var userStats: UserStats
    
    var isFollowed: Bool = false
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.password = data["password"] as? String ?? ""
        self.fullName = data["fullName"] as? String ?? ""
        self.userName = data["userName"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
        self.userStats = UserStats(followers: 0, following: 0, posts: 0)
    }
}

struct UserStats {
    let followers: Int
    let following: Int
    let posts: Int
}
