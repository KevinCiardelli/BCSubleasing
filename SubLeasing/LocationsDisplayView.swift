//
//  LocationsDetailView.swift
//  SubLeasing
//
//  Created by Kevin Ciardelli on 4/27/23.
//

import SwiftUI
import MapKit
import Firebase
import Firebase
import FirebaseFirestoreSwift
import MessageUI
import UIKit


struct MailView: UIViewControllerRepresentable {
    
    let recipient: String
    let subject: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.setToRecipients([recipient])
        mailComposeVC.setSubject(subject)
        mailComposeVC.mailComposeDelegate = context.coordinator
        return mailComposeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

struct LocationsDisplayView: View {
    
    struct Annotation: Identifiable {
        let id = UUID().uuidString
        var name: String
        var address: String
        var coordinate: CLLocationCoordinate2D
    }
    
    @Environment(\.dismiss) private var dismiss
    @State var location: Location
    @State private var mapRegion = MKCoordinateRegion()
    @State private var annotations: [Annotation] = []
    @State private var isShowingMailView = false
    @FirestoreQuery(collectionPath: "Locations") var photos: [Photo]
    var previewRunning = false
    
    
    let regionSize = 500.0
    var body: some View {
        ScrollView(showsIndicators: true) {
            ZStack(alignment: .leading){
                Color("BC")
                
                VStack(alignment: .center){
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
                    }
                    ForEach(photos) { photo in
                        let imageURL = URL(string: photo.imageURLString) ?? URL(string: "")
                        
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                            // Order is important here!
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(20)
                                .shadow(radius: 20)
                            
                                .clipped()
                            
                        } placeholder: {
                            ProgressView()
                                .frame(width: 80, height: 80)
                        }
                    }
                    .padding()
                    VStack(alignment: .center){
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
                        Text("Amenities: \(location.ammenities)")
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
                    Button("Contact Information"){
                        isShowingMailView.toggle()
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("BCGold"))
                    .font(.system(size: 30))
                    .bold()
                    .padding()
                    Spacer()
                    Spacer()
                    
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button("Back"){
                            dismiss()
                        }
                        .bold()
                        .foregroundColor(Color("BC"))
                    }
                }
                
            }
            .sheet(isPresented: $isShowingMailView) {
                if MFMailComposeViewController.canSendMail() {
                    MailView(recipient: location.email, subject: "Interest in \(location.address)")
                }else {
                    Text("Your Device Is Not Set Up For Emailing Services")
                    let alert = UIAlertController(title: "Cannot Send Email", message: "Your device is not configured for sending email.", preferredStyle: .alert)
                }
                
            }
            .onAppear{
                if !previewRunning {
                    $photos.path = "Locations/\(location.id ?? "")/photos"
                    print("photos.path = \($photos.path)")
                }
                
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

struct LocationsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsDisplayView(location: Location(), previewRunning: true)
    }
}


