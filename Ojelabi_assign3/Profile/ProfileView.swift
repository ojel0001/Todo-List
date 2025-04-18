//  ProfileView.swift
//  Ojelabi_assign3
//  Created by sunny ojelabi on 2025-04-13.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [Profile]
    
    var body : some View {
        NavigationStack {
            if let profile = profiles.first {
                Form {
                    Section("Personal Information") {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                            
                            VStack (alignment: .leading, spacing: 4) {
                                Text(profile.name)
                                    .font(.subheadline)
                                    .bold()
                                
                                Text(profile.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 8)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    Section ("Account") {
                        Text("User ID: \(profile.userId)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            deleteProfile(profile)
                        } label: {
                            Text("Delete Account")
                                .frame(maxWidth:. infinity)
                        }
                    }
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ContentUnavailableView("No Profile Found", systemImage: "person.crop.circle.badge.exclamationmark", description: Text("Please create a profile first")
                )
            }
        }
    }
    
    private func deleteProfile(_ profile: Profile) {
        modelContext.delete(profile)
    }
}


