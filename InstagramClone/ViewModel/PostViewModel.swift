//
//  PostViewModel.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/15.
//

import UIKit

class PostViewModel {
    
    var onUpdated: () -> () = {}
    
    var user: UserData
    var posts = [PostData]() {
        didSet { onUpdated() }
    }

    init(user: UserData) {
        self.user = user
    }
        
    func fetchPosts() {
        FirestoreManager.getPost { posts in
            self.posts = posts
            self.posts.forEach { post in
                // 좋아요 누른 사용자 확인
                FirestoreManager.checkUserLikedPost(post: post) { didLike in
                    guard let index = posts.firstIndex(where: { $0.postId == post.postId }) else { return }
                    self.posts[index].didLike = didLike
                    // 댓글 갯수 확인
                    FirestoreManager.getCommentCount(postId: post.postId) { count in
                        self.posts[index].commentCount = count
                    }
                }
            }
        }
    }
    
    func toggleLike(post: PostData, completion: @escaping (Bool) -> ()) {
        if post.didLike {
            FirestoreManager.unlikePost(post: post) {
                guard let index = self.posts.firstIndex(where: { $0.postId == post.postId }) else { return }
                self.posts[index].didLike = false
                self.posts[index].likes -= 1
                completion(false)
            }
        } else {
            FirestoreManager.likePost(post: post) {
                guard let index = self.posts.firstIndex(where: { $0.postId == post.postId }) else { return }
                self.posts[index].didLike = true
                self.posts[index].likes += 1
                completion(true)
            }
        }
    }
    
    func getPost(at index: Int) -> PostData {
        return posts[index]
    }
}

