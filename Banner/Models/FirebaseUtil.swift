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

            let saveData = Restaurants(name: "test", businessHours: "8:00-21:00", address: "函館", latitude: 35.11, longitude: 135, comments: ["美味しい", "美味しい"])
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
                let businessHours = document.data()["businessHours"] as? String,
                let address = document.data()["address"] as? String,
                let latitude = document.data()["latitude"] as? Double,
                let longitude = document.data()["longitude"] as? Double,
                let comments = document.data()["comments"] as? [String]
            else {
                throw NSError(domain: "FirebaseUtilError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve document data"])
            }
            let docID = document.documentID

            restaurants.append(Restaurants(name: name, businessHours: businessHours, address: address, latitude: latitude, longitude: longitude, comments: comments))
        }

        return restaurants
    }
}
