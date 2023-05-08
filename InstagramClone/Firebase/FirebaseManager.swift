//
//  FirebaseManager.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/05/08.
//

import Foundation
import Firebase

class FirestoreManager {
    
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    func getUser(uid: String, completion: @escaping (UserData) -> ()) {
        db.collection("user").document(uid).getDocument { (document, error) in
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
    
    // Firestore에 데이터 추가
    func addData(text: String, user: UserData, completion: @escaping () -> ()) {
        let data: [String: Any] = [
            "text": text,
            "date": Date(),
            "userName": user.userName,
            "profileImageUrl": user.profileImageUrl
        ]
        
        db.collection("messages").addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Success addDocument")
                completion()
            }
        }
    }
    
    // Firestore에서 데이터 가져오기
    func getData(completion: @escaping () -> ()) {
        db.collection("messages").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                //var messages = [MessageData]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let userName = data["userName"] as? String ?? ""
                    let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                    let text = data["text"] as? String ?? ""
                    let date = data["date"] as? Date ?? Date()
                    //let messageData = MessageData(id: document.documentID, userName: userName, profileImageUrl: profileImageUrl, text: text, date: date)
                    //messages.append(messageData)
                }
                completion()
            }
        }
    }
    
    // Firestore에서 데이터 삭제
    func deleteData(documentId: String, completion: @escaping () -> ()) {
        db.collection("messages").document(documentId).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Success delete")
                completion()
            }
        }
    }
}

