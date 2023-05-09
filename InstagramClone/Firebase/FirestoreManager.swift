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
 
}

