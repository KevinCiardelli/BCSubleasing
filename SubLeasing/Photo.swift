//
//  Photo.swift
//  SubLeasing
//
//  Created by Kevin Ciardelli on 4/29/23.
//
import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Photo: Identifiable, Codable {
    @DocumentID var id: String?
    var imageURLString = "" // This will hold the URL for loading the image

    
    var dictionary: [String: Any] {
        return ["imageURLString": imageURLString]
    }
}
