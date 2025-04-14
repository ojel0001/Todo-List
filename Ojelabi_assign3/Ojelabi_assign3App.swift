//
//  Ojelabi_assign3App.swift
//  Ojelabi_assign3
//
//  Created by sunny ojelabi on 2025-04-13.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application (_application: UIApplication,
                     didFinishLaunchWithOptions launchOptions:
                      [UIApplication.LaunchOptionsKey : Any]? = nil) ->Bool{
                     FirebaseApp.configure()
                     return true
    }
}


@main
struct Ojelabi_assign3App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
