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

    func getDocuments() async throws -> [Restaurants] {
        var restaurants: [Restaurants] = []
        let querySnapshot = try await db.collection("Restaurants").getDocuments()

        for document in querySnapshot.documents {
            guard
                let name = document.data()["name"] as? String,
                let businessHours = document.data()["businessHours"] as? Timestamp,
                let address = document.data()["address"] as? String
            else {
                throw NSError(domain: "FirebaseUtilError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve document data"])
            }
            let docID = document.documentID

            restaurants.append(Restaurants(id: docID, name: name, businessHours: businessHours.dateValue(), address: address))
        }

        return restaurants
    }
}
