//
//  ListView.swift
//  FinalProject
//
//  Created by Kevin Ciardelli on 4/26/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ListView: View {
    @FirestoreQuery(collectionPath: "Locations") var locations: [Location]

    @Environment (\.dismiss) private var dismiss
    @State private var sheetIsPresented = false
    @State private var myListingSheetIsPresented = false
    @State private var path = NavigationPath()
    var body: some View {
        ZStack{
            NavigationStack(path: $path){
                List(locations){ location in
                    NavigationLink {
                        LocationsDisplayView(location: location)
                    } label: {
                        HStack{
                            Image(systemName: "house")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("BC"))
                                .padding()
                            
                            VStack(alignment: .leading, spacing: 3.0){
                                Text(location.address)
                                    .font(.title2)
                                    .padding(.top)
                                Spacer()
                                Text("Asking: \(Int(location.numberValue)).00")
                                    .font(.title2)
                                Text("\(location.number_of_bedrooms) Rooms")
                                    .font(.title2)
                                    .padding(.bottom)
                            }
                            .font(.system(size: 20))
                            .cornerRadius(10)
                            .font(.title2)
                            .foregroundColor(Color("BC"))
                        }
                    }
                    .padding(.bottom)
                }
                .listStyle(.plain)
                .navigationBarBackButtonHidden()
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button("Sign Out") {
                            do {
                                try Auth.auth().signOut()
                                print("Log Out")
                                dismiss()
                            } catch {
                                print("Could not log out")
                            }
                        }
                        .bold()
                        .foregroundColor(Color("BC"))
                    }
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button {
                            sheetIsPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .bold()
                        .foregroundColor(Color("BC"))
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            myListingSheetIsPresented.toggle()
                            
                        } label: {
                            Text("View Your Listings")
                                .bold()
                                .foregroundColor(Color("BC"))
                        }
                    }
                }
                .fullScreenCover(isPresented: $sheetIsPresented) {
                    NavigationStack {
                        NewLocationDetailView(location: Location())
                    }
                }
               .fullScreenCover(isPresented: $myListingSheetIsPresented) {
                   NavigationStack {
                        UserListingViews()
                  }
               }
//               .onAppear {
//                   if !previewRunning && location.id != nil { // This is to prevent PreviewProvider error
//                       $photos.path = "Locations/\(location.id ?? "")/photos"
//                       print("photos.path = \($photos.path)")
//                   }
//               }
                .navigationTitle("Subleases for BC")
                .foregroundColor(Color("BC"))
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ListView()
        }
    }
}
