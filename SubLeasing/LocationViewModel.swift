//
//  LocationViewModel.swift
//  FinalProject
//
//  Created by Kevin Ciardelli on 4/27/23.
//

import Foundation
import FirebaseFirestore
import Firebase
import CoreLocation
import FirebaseStorage


class LocationViewModel: ObservableObject {
    @Published var location = Location()
    
    func saveLocation(location: Location) async -> Bool {
        print("Here1")
        let db = Firestore.firestore()
        if let id = location.id {
            do {
                try await db.collection("Locations").document(id).setData(location.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                
                try await db.collection("Locations").addDocument(data: location.dictionary)
                print("🐣 Data added successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new place in 'Locations' \(error.localizedDescription)")
                return false
            }
        }
    }
    func deleteLocation(location: Location) async -> Bool {
        let db = Firestore.firestore()
        guard let locationID = location.id else {
            print("😡 ERROR: location.id = \(location.id ?? "nil"). This should not have happened.")
            return false
        }
        do {
            let _ = try await db.collection("Locations").document(locationID).delete()
            print("🗑 Document successfully deleted!")
            return true
        } catch {
            print("😡 ERROR: removing document \(error.localizedDescription)")
            return false
        }
        
    }
    

    func saveImage(location: Location, photo: Photo, image: UIImage) async -> Bool {
        let db = Firestore.firestore()
            guard let locationID = location.id else {
                print("😡 ERROR: location.id == nil")
                return false
            }
            
            var photoName = UUID().uuidString // This will be the name of the image file
            if photo.id != nil {
                photoName = photo.id! // I have a photo.id, so use this as the photoName. This happens if we're updating an existing Photo's descriptive info. It'll resave the photo, but that's OK. It'll just overwrite the existing one.
            }
            let storage = Storage.storage() // Create a Firebase Storage instance
            let storageRef = storage.reference().child("\(locationID)/\(photoName).jpeg")
            
            guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
                print("😡 ERROR: Could not resize image")
                return false
            }
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg" // Setting metadata allows you to see console image in the web browser. This seteting will work for png as well as jpeg
            var imageURLString = "" // We'll set this after the image is successfully saved
            do {
                let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
                print("📸 Image Saved!")
                do {
                    let imageURL = try await storageRef.downloadURL()
                    imageURLString = "\(imageURL)" // We'll save this to Cloud Firestore as part of document in 'photos' collection, below
                } catch {
                    print("😡 ERROR: Could not get imageURL after saving image \(error.localizedDescription)")
                    return false
                }
            } catch {
                print("😡 ERROR: uploading image to FirebaseStorage")
                return false
            }
            
            // Now save to the "photos" collection of the spot document "spotID"
            let collectionString = "Locations/\(locationID)/photos"
            
            do {
                var newPhoto = photo
                newPhoto.imageURLString = imageURLString
                try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'reviews' for locationID \(locationID)")
                return false
            }
        }
}
