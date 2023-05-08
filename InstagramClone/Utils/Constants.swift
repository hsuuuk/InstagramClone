//
//  Constants.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import FirebaseFirestore

let COLLECTION_USER = Firestore.firestore().collection("user")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")

