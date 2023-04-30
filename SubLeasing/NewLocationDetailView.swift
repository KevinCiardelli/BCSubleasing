//
//  NewLocationDetailView.swift
//  FinalProject
//
//  Created by Kevin Ciardelli on 4/26/23.
//

import SwiftUI
import FirebaseAuth
import CoreLocation
import PhotosUI
import FirebaseStorage
import Firebase
 

struct NewLocationDetailView: View {
    @EnvironmentObject var locationVM: LocationViewModel
    @State var location: Location
    @Environment(\.dismiss) private var dismiss
    let geocoder = CLGeocoder()
    
    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: true) {
                VStack{
                    VStack(spacing: 20){
                        VStack(alignment: .leading){
                            Text("Enter Name: ")
                            TextField("Name", text: $location.name)
                            
                                .textFieldStyle(.roundedBorder)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.gray, lineWidth: 2)
                                }
                        }
                        VStack(alignment: .leading){
                            Text("Enter Address: ")
                            
                            TextField("Street, City, Zipcode", text: $location.address)
                            
                                .textFieldStyle(.roundedBorder)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.gray, lineWidth: 2)
                                }
                        }
                        VStack(alignment: .leading) {
                            Text("Asking Price: \(Int(location.numberValue))")
                            
                            Slider(value: $location.numberValue, in: 500...4500, step: 10)
                        }
                        HStack{
                            Toggle(isOn: $location.negotiate){
                                Text("Willing to Negotiate")
                                
                            }
                        }
                        VStack {
                            Stepper("Rooms: \(location.number_of_bedrooms)", value: $location.number_of_bedrooms)
                        }
                        HStack{
                            Toggle(isOn: $location.parking){
                                Text("Parking Availability")
                                
                            }
                            
                        }
                        VStack(alignment: .leading){
                            Text("Contact Email: ")
                            
                            TextField("Email", text: $location.email)
                            
                                .textFieldStyle(.roundedBorder)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.gray, lineWidth: 2)
                                }
                        }
                        VStack(alignment: .leading){
                            Text("Contact Phone #: ")
                            
                            TextField("Phone #", text: $location.phone)
                                .textFieldStyle(.roundedBorder)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.gray, lineWidth: 2)
                                }
                        }
                        VStack(alignment: .leading){
                            Text("Amenities Notes:")
                            TextField("Laundry Service, Wifi, Other Notes", text: $location.ammenities)
                                .textFieldStyle(.roundedBorder)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.gray, lineWidth: 2)
                                }
                                .font(.system(size: 20))
                        }
                        .padding(.top)
                        .padding(.bottom)
                        

 
                    }
                    .font(.custom("HelveticaNeue-Bold", size: 25))
                    .padding(.horizontal)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading){
                            Button ("Back"){
                                dismiss()
                            }
                            .foregroundColor(Color("BC"))
                            .bold()
                        }
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button("Save") {
                                Task{
                                    guard let userID = Auth.auth().currentUser?.uid else { return }
                                    location.userID = userID
                                    
                                    print("\(location.userID)")
                                    try await location.latitude = geocoder.geocodeAddressString(location.address)[0].location!.coordinate.latitude
                                    try await location.longitude = geocoder.geocodeAddressString(location.address)[0].location!.coordinate.longitude
                                    print(location.longitude)
                                    print(location.name)

                                    let success = await locationVM.saveLocation(location: location)
                                    
                                    if success{
                                        dismiss()
                                    } else {
                                        print("error saving")
                                    }
                                }
                            }
                            .foregroundColor(Color("BC"))
                            .bold()
                        }
                    }
                }
                .padding(.top)
                .background(Color("BCGold"))
                .frame(height: 850)
            }
            .navigationBarBackButtonHidden()
        }
    }

}

struct NewLocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NewLocationDetailView(location: Location())
            .environmentObject(LocationViewModel())
    }
}
