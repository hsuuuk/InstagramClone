//
//  Constants.swift
//  InstagramClone
//
//  Created by 심현석 on 2023/04/17.
//

import FirebaseFirestore

let COLLECTION_user = Firestore.firestore().collection("user")
let COLLECTION_post = Firestore.firestore().collection("post")
let COLLECTION_following = Firestore.firestore().collection("following")
let COLLECTION_followers = Firestore.firestore().collection("followers")
let COLLECTION_notification = Firestore.firestore().collection("notification")

