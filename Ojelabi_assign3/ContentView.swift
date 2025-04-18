//
//  ContentView.swift
//  Ojelabi_assign3
//
//  Created by sunny ojelabi on 2025-04-13.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var profiles: [Profile]
    
    var body: some View {
        if profiles.first != nil {
            MainTabView(userId: profiles.first?.userId ?? "")
        } else {
            ProgressView("loading...")
                .onAppear{
            }
        }
    }
}
