//
//  UserService.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import FirebaseAuth

struct UserService {
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
        COLLECTION_USER.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            
            //print("debug: \(dictionary)")
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(completion: @escaping ([User]) -> Void) {
        //        var users = [User]()
        //        COLLECTION_USER.getDocuments { snapshot, error in
        //            guard let snapshot = snapshot else { return }
        //
        //            snapshot.documents.forEach { document in
        //                let user = User(dictionary: document.data())
        //                users.append(user)
        //            }
        //            completion(users)
        //        }
        
        COLLECTION_USER.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let users = snapshot.documents.map { User(dictionary: $0.data()) }
            completion(users)
        }
    }
    
    static func follow(uid: String, completion: @escaping (FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following")
            .document(uid).setData([:]) { error in
                COLLECTION_FOLLOWERS.document(uid).collection("user-followers")
                    .document(currentUid).setData([:], completion: completion)
            }
    }
    
    //    static func follow(uid : String, completion : @escaping(FirestoreCompletion)) {
    //        guard let currentUid = Auth.auth().currentUser?.uid else { return }
    //        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { error in
    //            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
    //            // currentUid 의 following 에 uid 추가,
    //            // uid 의 follower 에 currentUid 추가.
    //        }
    //    }
    
    static func unfollow(uid: String, completion: @escaping (FirestoreCompletion)) {
        guard let currentid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentid).collection("user-following")
            .document(uid).delete { error in
                COLLECTION_FOLLOWERS.document(uid).collection("user-followers")
                    .document(uid).delete(completion: completion)
            }
    }
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping (Bool) -> Void) {
        guard let currentid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentid).collection("user-following")
            .document(uid).getDocument { snapshot, error in
                guard let isFollowed = snapshot?.exists else { return }
                completion(isFollowed)
            }
    }
    
    static func fetchUserStats(uid: String, completion: @escaping (UserStats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, _ in
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { snapshot, _ in
                let following = snapshot?.documents.count ?? 0
                
                COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { snapshot, error in
                    let posts = snapshot?.documents.count ?? 0
                    
                    completion(UserStats(followers: followers, following: following, posts: posts))
                }
            }
        }
    }
}
