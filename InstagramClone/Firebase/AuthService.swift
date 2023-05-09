//
//  AuthService.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthServie {
    static func logUserin(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping (Error?) -> Void) {
        
        ImageUploader.imageUpload(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                if let error = error {
                    print("DEBUG: Failed to register user \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data: [String: Any] = ["email": credentials.email, "fullName": credentials.fullname,
                                           "userName": credentials.username, "profileImageUrl": imageUrl,
                                           "uid": uid]
                
                COLLECTION_user.document(uid).setData(data, completion: completion)
            }
        }
    }
}
