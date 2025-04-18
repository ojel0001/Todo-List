//
//  AddTaskView.swift
//  Ojelabi_assign3
//
//  Created by sunny ojelabi on 2025-04-14.
//

import SwiftUI
import SwiftData
import FirebaseFirestore

  
struct AddTaskView : View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var firestoreService = FirestoreTaskService()
    let userId: String
    
    @State private var title = ""
    @State private var notes = ""
    @State private var dueDate: Date?
    @State private var location = ""
    @State private var category = ""
    @State private var showDatePicker = false
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Task Details") {
                    TextField ("Title", text: $title)
                    TextField("Notes", text: $notes, axis: .vertical)
                    TextField("Location", text: $location)
                    TextField("Category", text: $category)
                    Toggle("Add due Date", isOn: $showDatePicker)
                    if showDatePicker {
                        DatePicker(
                            "Due Date",
                            selection:Binding<Date>(
                                get: {dueDate ??
                                    Date().addingTimeInterval(85400)},
                                set: {dueDate = $0}
                            ),
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        
                    }
                    Section {
                        Button("Create Task") {
                            let task = Task(
                                id: UUID().uuidString,
                                title: title,
                                notes: notes.isEmpty ? nil : notes,
                                dueDate: showDatePicker ? dueDate : nil,
                                location: location.isEmpty ? nil : location,
                                category: category.isEmpty ? nil : category,
                                isDone: false,
                                userId: userId
                            )
                            modelContext.insert(task)
                            firestoreService.createTask(task)
                            dismiss()
                        }
                        .disabled(title.isEmpty)
                    }
                }
                .navigationTitle("New Task")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        
    }
}


