//
//  RestaurantsModel.swift
//  Banner
//
//  Created by Keitaro Kawahara on 2023/05/27.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct Restaurants: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var businessHours: String
    var address: String
    var latitude: Double
    var longitude: Double
    var comments: [String]

    init(id: String? = nil, name: String, businessHours: String, address: String, latitude: Double, longitude: Double, comments: [String]) {
        self.id = id
        self.name = name
        self.businessHours = businessHours
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.comments = comments
    }
}
