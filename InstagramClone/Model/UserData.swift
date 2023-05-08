//
//  UserData.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/08.
//

import Foundation

struct UserData {
    let uid: String
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.password = data["password"] as? String ?? ""
        self.fullName = data["fullName"] as? String ?? ""
        self.userName = data["userName"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
