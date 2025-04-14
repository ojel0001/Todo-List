//
//  Task.swift
//  Ojelabi_assign3
//
//  Created by sunny ojelabi on 2025-04-13.
//

import SwiftUI
import SwiftData

@Model
final class Task {
    var id: String
    var title: String
    var notes: String?
    var dueDate: Date?
    var location: String?
    var category: String?
    var isDone: Bool
    var userId: String
    
    init(
        id: String,
        title: String,
        notes: String? = nil,
        dueDate: Date? = nil,
        location: String? = nil,
        category: String? = nil,
        isDone: Bool = false,
        userId: String
    ){
        
        self.id = id
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.location = location
        self.category = category
        self.isDone = isDone
        self.userId = userId
    }
}

