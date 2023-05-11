//
//  FirebaseManager.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/08.
//

import Foundation
import Firebase

class FirestoreManager {
        
    static func getUser(uid: String, completion: @escaping (UserData) -> ()) {
        COLLECTION_user.document(uid).getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                guard let document = document, document.exists else { return }
                guard let data = document.data() else { return }
                let user = UserData(data: data)
                completion(user)
            }
        }
    }
    
    static func addPost(caption: String, image: UIImage, user: UserData, completion: @escaping () -> ()) {
        ImageUploader.imageUpload(image: image) { imageUrl in
            let data: [String: Any] = [
                "caption": caption,
                "date": Date(),
                "likes": 0,
                "imageUrl": imageUrl,
                "uid": user.uid,
                "profileImageUrl": user.profileImageUrl,
                "userName": user.userName
            ]
            
            COLLECTION_post.addDocument(data: data) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    completion()
                }
            }
        }
    }
    
    // 시간별 포스트
    static func getPost(completion: @escaping ([PostData]) -> ()) {
        COLLECTION_post.order(by: "date", descending: true).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            
            let posts = documents.map({ PostData(postId: $0.documentID, data: $0.data()) })
            completion(posts)
        }
    }
    
    // 유저별 포스트
    static func getPost(uid: String, completion: @escaping ([PostData]) -> ()) {
        COLLECTION_post.whereField("uid", isEqualTo: uid).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            
            var posts = documents.map({ PostData(postId: $0.documentID, data: $0.data()) })
            completion(posts)
        }
    }
    
    // 특정 포스트
    static func getPost(postId: String, completion: @escaping (PostData) -> ()) {
        COLLECTION_post.document(postId).getDocument { querySnapshot, error in
            guard let snapshot = querySnapshot else { return }
            guard let data = snapshot.data() else { return }
            
            let post = PostData(postId: snapshot.documentID, data: data)
            completion(post)
        }
    }
 
    // 좋아요
    static func likePost(post: PostData, completion: @escaping () -> ()) {
        COLLECTION_post.document(post.postId).updateData(["likes": post.likes + 1])
        
        COLLECTION_post.document(post.postId).collection("who-likes").document(post.uid).setData([:]) { error in
            COLLECTION_user.document(post.uid).collection("which-likes").document(post.postId).setData([:]) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    completion()
                }
            }
        }
    }
    
    // 좋아요 취소
    static func unlikePost(post: PostData, completion: @escaping () -> ()) {
        guard post.likes > 0 else { return }
        
        COLLECTION_post.document(post.postId).updateData(["likes": post.likes - 1])
        
        COLLECTION_post.document(post.postId).collection("who-likes").document(post.uid).delete { error in
            COLLECTION_user.document(post.uid).collection("which-likes").document(post.postId).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    completion()
                }
            }
        }
    }
    
    // 좋아요 확인
    static func checkUserLikedPost(post: PostData, completion: @escaping (Bool) -> ()) {
        COLLECTION_user.document(post.uid).collection("which-likes").document(post.postId)
            .getDocument { querySnapshot, error in
            guard let didLike = querySnapshot?.exists else { return }
            completion(didLike)
        }
    }
    
    // 코멘트 추가
    static func addComment(comment: String, postID: String, user: UserData, completion : @escaping () -> ()) {
        let data : [String : Any] = [
            "uid" : user.uid,
            "comment" : comment,
            "date" : Date(),
            "userName" : user.userName,
            "profileImageUrl" : user.profileImageUrl
        ]
        
        COLLECTION_post.document(postID).collection("comments").addDocument(data: data) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                completion()
            }
        }
    }
    
    static func deleteComment(postId: String, commentId: String, completion: @escaping () -> ()) {
        COLLECTION_post.document(postId).collection("comments").document(commentId).delete{ error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                completion()
            }
        }
    }
    
    // 코멘트 패치
    static func getComment(postId: String, completion: @escaping ([CommentData]) -> ()) {
        COLLECTION_post.document(postId).collection("comments").order(by: "date", descending: true)
            .getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                guard let documents = querySnapshot?.documents else { return }
                var comments = documents.map { CommentData(commentId: $0.documentID, data: $0.data()) }
                completion(comments)
            }
        }
    }
    
    static func getCommentCount(postId: String, completion: @escaping (Int) -> ()) {
        COLLECTION_post.document(postId).collection("comments")
            .getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                let count = querySnapshot?.documents.count ?? 0
                completion(count)
            }
        }
    }
    
    // 코멘트 실시간 업데이트⭐️
//    static func getCommentLive(postId: String, completion: @escaping ([CommentData]) -> ()) {
//        COLLECTION_post.document(postId).collection("comments").order(by: "date", descending: true)
//            .addSnapshotListener { snapshot, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                } else {
//                    guard let documents = snapshot?.documentChanges else { return }
//                    let comments = documents.compactMap { change -> CommentData? in
//                        guard change.type == .added else { return nil }
//                        let data = change.document.data()
//                        return CommentData(data: data)
//                    }
//                    completion(comments)
//                }
//            }
//    }
    
    static func follow(uid: String, completion: @escaping () -> ()) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_following.document(currentUid).collection("follwing-who").document(uid)
            .setData([:]) { error in
                COLLECTION_followers.document(uid).collection("who-follower").document(currentUid)
                    .setData([:]) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("Success follow")
                            completion()
                        }
                    }
            }
    }
    
    static func unfollow(uid: String, completion: @escaping () -> ()) {
        guard let currentid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_following.document(currentid).collection("follwing-who").document(uid)
            .delete { error in
                COLLECTION_followers.document(uid).collection("who-follower").document(currentid)
                    .delete { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("Success unfollow")
                            completion()
                        }
                        
                    }
            }
    }
    
    static func checkUserIsFollowed(uid: String, completion: @escaping (Bool) -> ()) {
        guard let currentid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_following.document(currentid).collection("follwing-who").document(uid)
            .getDocument { querySnapshot, error in
                guard let isFollowed = querySnapshot?.exists else { return }
                completion(isFollowed)
            }
    }
    
    static func getUserStats(uid: String, completion: @escaping (UserStats) -> Void) {
        COLLECTION_followers.document(uid).collection("who-follower").getDocuments { snapshot, error in
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_following.document(uid).collection("follwing-who").getDocuments { snapshot, error in
                let following = snapshot?.documents.count ?? 0
                
                COLLECTION_post.whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
                    let posts = snapshot?.documents.count ?? 0
                    
                    completion(UserStats(followers: followers, following: following, posts: posts))
                }
            }
        }
    }
}

