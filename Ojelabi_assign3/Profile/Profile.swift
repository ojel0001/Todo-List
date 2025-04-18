//
//  Profile.swift
//  Ojelabi_assign3
//
//  Created by sunny ojelabi on 2025-04-13.
//

import SwiftUI
import SwiftData

@Model
 final class Profile {
    var name: String
    var email: String
    var userId: String
    
    init(name: String,
         email: String,
         userId: String
    
    ) {
         self.name = name
         self.email = email
         self.userId = userId
     }
}

