//
//  TaskDetailView.swift
//  Ojelabi_assign3
//
//  Created by sunny ojelabi on 2025-04-14.
//

import SwiftUI
import SwiftData
import FirebaseFirestore

struct TaskDetailView: View {
    @Bindable var task: Task
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var firestoreService = FirestoreTaskService()
    @State private var showDeleteConfirmation = false
    @State private var isEditing = false
    @State private var editTitle = ""
    @State private var editNotes = ""
    @State private var editDueDate: Date?
    @State private var editLocation = ""
    @State private var editCategory = ""
    @State private var showDatePicker = false
    
    
    var body: some View{
        List {
            Section {
                if isEditing {
                    taskEditingFields
                } else {
                    taskDisplayFields
                }
            }
            
            Section {
                Toggle("Mark as Completed", isOn: $task.isDone)
                    .tint(task.isDone ? .green: .blue)
                    .onChange(of: task.isDone) { _ in
                        firestoreService.updateTask(task)
                    }
            }
        }
        .navigationTitle(isEditing ? "Editing Task" : "Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if isEditing {
                    Button("Done") {
                        task.title = editTitle
                        task.notes = editNotes.isEmpty ? nil : editNotes
                        task.dueDate = editDueDate
                        task.location = editLocation.isEmpty ? nil : editLocation
                        task.category = editCategory.isEmpty ? nil : editCategory
                        firestoreService.updateTask(task)
                        isEditing = false
                    }
                } else {
                    Menu {
                        Button {
                            prepareForEditing()
                        } label: {
                            Label ("Edit Task", systemImage: "pencil")
                        }
                        Button(role: .destructive) {
                            showDeleteConfirmation = true
                        } label: {
                            Label ("Delete Task", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            
            if isEditing {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Cancel") {
                        discardChanges()
                    }
                }
            }
        }
        
        .confirmationDialog("Delete Task", isPresented: $showDeleteConfirmation) {
            Button ("Delete Task", role: .destructive) {
                firestoreService.deleteTask(task)
                modelContext.delete(task)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this task? This action cannot be undone.")
        }
    }
    
    private var taskEditingFields: some View {
        Group {
            TextField("Title", text: $editTitle)
                .font(.title3.weight(.semibold))
            
            TextField("Notes", text: $editNotes, axis: .vertical)
            
            TextField("Location", text: $editLocation)
                .textContentType(.location)
            
            TextField("Category", text: $editCategory)
            
            Toggle("Add Due Date", isOn: $showDatePicker)
                .onChange(of: showDatePicker) { _, newValue in
                    editDueDate = newValue ? (task.dueDate ?? Date().addingTimeInterval(86400)) : nil
                }
                
            if showDatePicker {
                DatePicker(
                    "Due Date",
                    selection: Binding(
                        get: { editDueDate ?? Date().addingTimeInterval(86400) },
                        set: { editDueDate = $0 }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
            }
        }
    }
    
    private var taskDisplayFields: some View {
        Group {
            Text(task.title)
                .font(.title3.weight(.semibold))
                .strikethrough(task.isDone)
                .foregroundColor(task.isDone ? Color.secondary : Color.primary)
            
            if let notes = task.notes, !notes.isEmpty {
                Text(notes)
                    .padding(.vertical, 4)
                    .foregroundColor(Color.secondary)
            }
            
            if let dueDate = task.dueDate {
                HStack {
                    Image(systemName: "calendar")
                    Text(dueDate.formatted(date: .abbreviated, time: .shortened))
                }
                .foregroundStyle(task.isDone ? Color.secondary : dueDate < Date() ? Color.red : Color.secondary)
            }
            
            if let location = task.location {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text(location)
                }
                .foregroundStyle(Color.secondary)
            }
            
            if let category = task.category {
                HStack {
                    Image(systemName: "tag")
                    Text(category)
                }
                .foregroundStyle(Color.secondary)
            }
        }
    }
    
    private func prepareForEditing() {
        editTitle = task.title
        editNotes = task.notes ?? ""
        editDueDate = task.dueDate
        editLocation = task.location ?? ""
        editCategory = task.category ?? ""
        showDatePicker = task.dueDate != nil
        isEditing = true
    }
    
    private func saveChanges() {
        task.title = editTitle
        task.notes = editNotes.isEmpty ? nil : editNotes
        task.dueDate = editDueDate
        task.location = editLocation.isEmpty ? nil : editLocation
        task.category = editCategory.isEmpty ? nil : editCategory
        isEditing = false
    }
    
    private func discardChanges() {
        isEditing = false
    }
}


