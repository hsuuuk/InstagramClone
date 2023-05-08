//
//  PostManager.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/08.
//

import UIKit
import Firebase

struct PostManager {
    static func uploadPost(caption: String, image: UIImage, user: UserData, completion: @escaping () -> ()) {
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
            
            COLLECTION_POSTS.addDocument(data: data) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    completion()
                }
            }
        }
    }
    
    // 시간별 포스트
    static func fetchPost(completion: @escaping ([PostData]) -> ()) {
        COLLECTION_POSTS.order(by: "date", descending: true).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            
            let posts = documents.map({ PostData(postId: $0.documentID, data: $0.data()) })
            completion(posts)
        }
    }
    
    // 유저별 포스트
    static func fetchPost(uid: String, completion: @escaping ([PostData]) -> ()) {
        COLLECTION_POSTS.whereField("uid", isEqualTo: uid).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            
            var posts = documents.map({ PostData(postId: $0.documentID, data: $0.data()) })
            completion(posts)
        }
    }
    
    // 특정 포스트
    static func fetchPost(postId: String, completion: @escaping (PostData) -> ()) {
        COLLECTION_POSTS.document(postId).getDocument { querySnapshot, error in
            guard let snapshot = querySnapshot else { return }
            guard let data = snapshot.data() else { return }
            
            let post = PostData(postId: snapshot.documentID, data: data)
            completion(post)
        }
    }
}
