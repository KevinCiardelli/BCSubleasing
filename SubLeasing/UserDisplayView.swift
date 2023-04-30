//
//  UserDisplayView.swift
//  SubLeasing
//
//  Created by Kevin Ciardelli on 4/28/23.
//

import SwiftUI
import MapKit
import PhotosUI
import FirebaseStorage

struct UserDisplayView: View {
    struct Annotation: Identifiable {
        let id = UUID().uuidString
        var name: String
        var address: String
        var coordinate: CLLocationCoordinate2D
    }
    @State var location: Location
    @EnvironmentObject var locationVM: LocationViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var mapRegion = MKCoordinateRegion()
    @State private var annotations: [Annotation] = []
    let regionSize = 500.0
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    var photo: Photo
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            ZStack(alignment: .leading){
                Color("BC")
                
                VStack(alignment: .leading){
                    Rectangle()
                        .frame(width: 400, height: 90)
                        .foregroundColor(Color("BCGold"))
                        .ignoresSafeArea()
                    Text("Poster: \(location.name)")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .bold()
                        .padding()
                    
                    Text("\(location.address)")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .bold()
                        .padding()
                    VStack(alignment: .leading){
                        Text("From:  \(Int(location.numberValue)).00")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .bold()
                            .padding()
                        HStack(spacing: 0.4){
                            Text("Parking:   \(location.parking == false ? "None," : "Available,")")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .bold()
                                .padding()
                            
                            Text("\(location.number_of_bedrooms)  \(location.number_of_bedrooms >= 2 ? "Rooms" : "Room")")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .bold()
                                .padding()
                            
                        }
                        Text("Ammenities: \(location.ammenities)")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .bold()
                            .padding()
                        
                        Map(coordinateRegion: $mapRegion, annotationItems: annotations) { annotation in
                            MapMarker(coordinate: annotation.coordinate)
                        }
                        .frame(width: 350, height: 350)
                        .padding()
                    }
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        VStack {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 128, height: 128)
                                    .cornerRadius(64)
                            } else {
                                Image(systemName: "photo")
                                    .font(.system(size: 64))
                                    .padding()
                                    .foregroundColor(Color(.label))
                            }
                        }
                    }
                    Button("Contact Information"){
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("BCGold"))
                    .font(.system(size: 30))
                    .bold()
                    .padding()
                    Spacer()
                    Spacer()
                    
                }
                .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                    ImagePicker(image: $image)
                        .ignoresSafeArea()
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button("Back"){
                            dismiss()
                        }
                        .bold()
                        .foregroundColor(Color("BC"))
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            Task{
                                print(location.id)
                                let delete = await locationVM.deleteLocation(location: location)
                                print("Deleted")
                                if delete{
                                    dismiss()
                                } else {
                                    print("error saving")
                                }
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                        .foregroundColor(Color("BC"))
                        

                    }
                    ToolbarItem(placement: .automatic){
                        Button("Save"){
                            Task{
                                await locationVM.saveImage(location: location, photo: photo, image: image!)
                                dismiss()
                            }
                        }
                        .bold()
                        .foregroundColor(Color("BC"))
                    }
                }
                
            }
            .onAppear{
                if location.id != nil {
                    mapRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: regionSize, longitudinalMeters: regionSize)
                } else {
                    print("shouldn't be here")
                }
                annotations = [Annotation(name: location.name, address: location.address, coordinate: location.coordinate)]
            }
            .navigationBarBackButtonHidden()
        }
        .ignoresSafeArea()
    }

}

struct UserDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        UserDisplayView(location: Location(), photo: Photo())
            .environmentObject(LocationViewModel())
    }
}
