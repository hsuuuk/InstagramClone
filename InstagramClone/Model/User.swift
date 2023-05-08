//
//  User.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import Foundation
//import FirebaseAuth

struct User {
    let email: String
    let fullname: String
    let username: String
    let profileImageUrl: String
    let uid: String
    
    //var isFollowed = false
    
    var stats: UserStats!
    
    //var isCurrentUser : Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? "faker@gmail.com"
        self.fullname = dictionary["fullName"] as? String ?? "이상혁"
        self.username = dictionary["userName"] as? String ?? "Faker"
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
        self.stats = UserStats(followers: 0, following: 0, posts: 0)
    }
}

struct UserStats {
    let followers: Int
    let following: Int
    let posts: Int
}
