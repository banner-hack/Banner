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

    init() {}

    func addDocument() async throws {
        do {
            let now = Date()

            let saveData = Restaurants(id: nil, name: "test", businessHours: now, address: "aaa")
            try await db.collection("Restaurants").addDocument(from: saveData)
        } catch {
            print("Error adding document: \(error)")
        }
    }
}
