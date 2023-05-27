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
    var businessHours: Date
    var address: String

     init(id: String?, name: String, businessHours: Date, address: String) {
         self.id = id
         self.name = name
         self.businessHours = businessHours
         self.address = address
     }
 }
