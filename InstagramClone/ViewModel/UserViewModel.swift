//
//  UserViewModel.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import Foundation

struct UserViewModel {
    private let user: User
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var username: String {
        return user.username
    }
    
    var fullname: String {
        return user.fullname
    }
    
    init(user: User) {
        self.user = user
    }
}
