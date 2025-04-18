//
//  FirestoreTaskService..swift
//  Ojelabi_assign3
//
//  Created by sunny ojelabi on 2025-04-18.
//

import SwiftUI
import FirebaseFirestore

final class FirestoreTaskService: ObservableObject {
    private let firestoreDatabase = Firestore.firestore()

    func createTask(_ task: Task) {
        let data: [String: Any] = [
            "id": task.id,
            "title": task.title,
            "notes": task.notes ?? NSNull(),
            "dueDate": task.dueDate ?? NSNull(),
            "location": task.location ?? NSNull(),
            "category": task.category ?? NSNull(),
            "isDone": task.isDone,
            "userId": task.userId
        ]
        
        firestoreDatabase.collection("Users").document(task.userId).collection("tasks")
            .document(task.id)
            .setData(data) { error in
                if let error = error {
                    print("Error creating task: \(error.localizedDescription)")
                } else {
                    print("Task created successfully")
                }
            }
    }
    
    func updateTask(_ task: Task) {
        let data: [String: Any] = [
            "title": task.title,
            "notes": task.notes ?? NSNull(),
            "dueDate": task.dueDate ?? NSNull(),
            "location": task.location ?? NSNull(),
            "category": task.category ?? NSNull(),
            "isDone": task.isDone
        ]
        
        firestoreDatabase.collection("Users").document(task.userId).collection("tasks")
            .document(task.id)
            .updateData(data) { error in
                if let error = error {
                    print("Error updating task: \(error.localizedDescription)")
                } else {
                    print("Task updated successfully")
                }
            }
    }

    func deleteTask(_ task: Task) {
        firestoreDatabase.collection("Users").document(task.userId).collection("tasks")
            .document(task.id)
            .delete { error in
                if let error = error {
                    print("Error deleting task: \(error.localizedDescription)")
                } else {
                    print("Task deleted successfully")
                }
            }
    }
}
    

