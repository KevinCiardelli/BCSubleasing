//
//  UserListingViews.swift
//  SubLeasing
//
//  Created by Kevin Ciardelli on 4/28/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

struct UserListingViews: View {
    @FirestoreQuery(collectionPath: "Locations") var locations: [Location]
    @Environment (\.dismiss) private var dismiss
    let userID = Auth.auth().currentUser!.uid
    var previewRunning = false
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path){
            List(locations.filter {$0.userID ==  userID}){ location in
                NavigationLink(destination: UserDisplayView(location: location, photo: Photo())) {
                        Text(location.address)
                            .font(.title2)
                    }
            }
            .listStyle(.plain)
            .navigationBarBackButtonHidden()
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct UserListingViews_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            UserListingViews()
        }
    }
}
