//
//  FirebaseUtil.swift
//  Banner
//
//  Created by Keitaro Kawahara on 2023/05/27.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

struct FirebaseUtil {
    var db = Firestore.firestore()

    var docRef = db.collection("Restaurants")

    func addDocument() {
//        try await db.collection("Users").addDocument(from: )

    }
}
