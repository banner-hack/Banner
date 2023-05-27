//
//  FirebaseUtil.swift
//  Banner
//
//  Created by Keitaro Kawahara on 2023/05/27.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct FirebaseUtil {
    var db = Firestore.firestore()

    lazy var docRef = db.collection("Restaurants")

    func addDocument() {
//        try await db.collection("Users").addDocument(from: )

    }
}
