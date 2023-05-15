//
//  CommentViewModel.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/15.
//

import UIKit

class CommentViewModel {
    
    var onUpdated: () -> () = {}
    
    var user: UserData
    var post: PostData
    var comments = [CommentData]() {
        didSet { onUpdated() }
    }
    
    init(user: UserData, post: PostData) {
        self.user = user
        self.post = post
    }
    
    func fetchComments() {
        FirestoreManager.getComment(postId: post.postId) { comments in
            self.comments = comments
        }
    }
    
    func addComment(comment: String) {
        FirestoreManager.addComment(comment: comment, postID: post.postId, user: user) {
            
        }
    }
}


