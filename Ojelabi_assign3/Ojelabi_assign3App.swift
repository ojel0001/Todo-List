//
//  Ojelabi_assign3App.swift
//  Ojelabi_assign3
//
//  Created by sunny ojelabi on 2025-04-13.
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
struct Ojelabi_assign3App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LoginView()
                .modelContainer(for: [Profile.self, Task.self])
        }
    }
}

