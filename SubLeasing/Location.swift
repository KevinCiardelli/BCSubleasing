//
//  Location.swift
//  FinalProject
//
//  Created by Kevin Ciardelli on 4/26/23.
//

import Foundation
import FirebaseFirestoreSwift
import CoreLocation
import SwiftUI
import PhotosUI


struct Location: Identifiable, Codable {

    @DocumentID var id: String?
    var userID = ""
    var name = ""
    var address = ""
    var email = ""
    var phone = ""
    var numberValue = 500.0
    var negotiate = false
    var parking = false
    var number_of_bedrooms = 0
    var ammenities = ""
    var latitude = 0.0
    var longitude = 0.0
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    

    var dictionary: [String: Any] {
        return ["name": name, "address": address, "email": email, "phone": phone, "numberValue": numberValue, "negotiate": negotiate, "parking": parking, "number_of_bedrooms": number_of_bedrooms, "ammenities": ammenities, "userID": userID, "latitude": latitude, "longitude": longitude]
    }
}
