//
//  ProfileHeaderViewModel.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
//    var followButtonText: String {
//        if user.isCurrentUser {
//            return "프로필 편집"
//        }
//        
//        return user.isFollowed ? "팔로잉" : "팔로우"
//    }
//    
//    var followButtonBackgroundColor: UIColor {
//        if user.isCurrentUser {
//            return .white
//        }
//        
//        return user.isFollowed ? .systemGray6 : .systemBlue
//    }
//    
//    var followButtonTextColor: UIColor {
//        if user.isCurrentUser {
//            return .black
//        }
//        
//        return user.isFollowed ? .black : .white
//    }
    
    var numberOfFollwers: NSAttributedString {
        return attributedStateText(value: user.stats.followers, lable: "팔로워")
    }
    
    var numberOfFollwing: NSAttributedString {
        return attributedStateText(value: user.stats.following, lable: "팔로잉")
    }
    
    var numberOfPosts: NSAttributedString {
        return attributedStateText(value: user.stats.posts, lable: "게시물")
    }
    
    init(user: User) {
        self.user = user
    }
    
    func attributedStateText(value: Int, lable: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: lable, attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
}
