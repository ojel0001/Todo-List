//
//  LoginView.swift
//  Ojelabi_assign3
//
//  Created by sunny ojelabi on 2025-04-17.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseAuth

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var userLoggedIn: Bool = false
    @State private var errorMessage = ""
    @State private var isRegistering = false
    
    var body: some View {
        if userLoggedIn {
            ContentView()
        } else {
            content
        }
    }
    
    var content: some View {
        VStack(spacing: 20) {
            Text(isRegistering ? "Create Account" : "Welcome Back ")
                .font(.title)
                .bold()
            
            if isRegistering {
                TextField("Name", text: $name)
                    .foregroundStyle(.black)
                    .textFieldStyle(.plain)
                    .placeholder(when: name.isEmpty) {
                        Text("Name")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            
            TextField("Email", text: $email)
                .foregroundStyle(.black)
                .textFieldStyle(.plain)
                .placeholder(when: email.isEmpty) {
                    Text("Email")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            SecureField("Password", text: $password)
                .foregroundStyle(.black)
                .textFieldStyle(.plain)
                .placeholder(when: password.isEmpty) {
                    Text("Password")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button {
                isRegistering ? register() : login()
            } label: {
                Text(isRegistering ? "Sign Up" : "Login")
                    .bold()
                    .frame(width: 200, height: 40)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            Button {
                isRegistering.toggle()
                errorMessage = ""
            } label: {
                Text(isRegistering ? "Already have an account? Login" : "Need an account? Register")
                    .foregroundColor(.blue)
            }
        }
        .frame(width: 350)
        .padding()
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                checkAndCreateProfile()
            }
        }
    }
    func register() {
        guard !name.isEmpty else {
            errorMessage = "Please enter your name"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let user = result?.user {
                createProfile(uid: user.uid)
                saveUserProfile(uid: user.uid, name: name, email: email)
                userLoggedIn = true
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            let taskDescriptor = FetchDescriptor<Task>()
            let tasks = (try? modelContext.fetch(taskDescriptor)) ?? []
            for task in tasks {
                modelContext.delete(task)
            }
            
            let profileDescriptor = FetchDescriptor<Profile>()
            let profiles = (try? modelContext.fetch(profileDescriptor)) ?? []
            for profile in profiles {
                modelContext.delete(profile)
            }
            
            try? modelContext.save()
            userLoggedIn = false
        } catch {
            print("Error signing out: \(error)")
        }
    }
    
    private func checkAndCreateProfile() {
        let descriptor = FetchDescriptor<Profile>(predicate: #Predicate { $0.email == email })
        do {
            let existingProfiles = try modelContext.fetch(descriptor)
            if existingProfiles.isEmpty {
                if let user = Auth.auth().currentUser {
                    createProfile(uid: user.uid)
                }
            }
            userLoggedIn = true
        } catch {
            errorMessage = "Failed to check profile: \(error.localizedDescription)"
        }
    }
    
    private func createProfile(uid: String) {
        let profile = Profile(
            name: name.isEmpty ? email.components(separatedBy: "@").first ?? "User" : name,
            email: email,
            userId: uid
        )
        modelContext.insert(profile)
        try? modelContext.save()
    }
    
    func saveUserProfile(uid: String, name: String, email: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData([
            "name": name,
            "email": email,
            "createdAt": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error saving user profile: \(error.localizedDescription)")
            }
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

