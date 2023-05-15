//
//  UserViewModel.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/15.
//

import UIKit

class UserViewModel {
    
    var onUpdated: () -> () = {}
    
    var user: UserData {
        didSet { onUpdated() }
    }
    
    var posts = [PostData]() {
        didSet { onUpdated() }
    }

    init(user: UserData) {
        self.user = user
    }
    
    func fetchPost() {
        FirestoreManager.getPost(uid: user.uid) { posts in
            self.posts = posts
        }
    }
    
    func fetchUser() {
        FirestoreManager.checkUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
        }
        
        FirestoreManager.getUserStats(uid: user.uid) { userState in
            self.user.userStats = userState
        }
    }
    
    func toggleFollow(completion: @escaping (Bool) -> ()) {
        if user.isCurrentUser {
            
        } else if user.isFollowed {
            FirestoreManager.unfollow(uid: user.uid) {
                self.user.isFollowed = false
                completion(false)
            }
        } else {
            FirestoreManager.follow(uid: user.uid) {
                self.user.isFollowed = true
                completion(true)
            }
        }
    }
}
