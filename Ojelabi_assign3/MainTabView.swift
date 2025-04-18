//
//  MainTabView.swift
//  Ojelabi_assign3
//
//  Created by sunny ojelabi on 2025-04-13.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    let userId: String
    
    var body: some View{
        TabView{
            TaskListView(userId: userId)
                .tabItem {
                    Label ("Tasks", systemImage: "checkList")
                    
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                    
            }
        }
    }
}

