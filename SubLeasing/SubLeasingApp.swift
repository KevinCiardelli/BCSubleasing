//
//  SubLeasingApp.swift
//  SubLeasing
//
//  Created by Kevin Ciardelli on 4/27/23.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct SubLeasingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var locationVM = LocationViewModel()
    var body: some Scene {
        WindowGroup {
            LoginView()
              .environmentObject(locationVM)
        }
    }
}

