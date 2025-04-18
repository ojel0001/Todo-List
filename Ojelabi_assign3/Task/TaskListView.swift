//
//  TaskListView.swift
//  Ojelabi_assign3
//
//  Created by sunny ojelabi on 2025-04-13.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    @Query(sort: \Task.dueDate, order: .forward) private var tasks: [Task]
    @Environment(\.modelContext) private var modelContext
    let userId: String
    
    
    private var incompleteTasks: [Task] {
        tasks.filter { !$0.isDone && ($0.dueDate == nil || $0.dueDate! > Date()) }
    }
    
    private var completedTasks: [Task] {
        tasks.filter { $0.isDone }
    }
    
    private var overdueTasks: [Task] {
        tasks.filter { !$0.isDone && $0.dueDate != nil && $0.dueDate! <= Date() }
    }

    var body: some View {
        NavigationStack {
            List {
                if !overdueTasks.isEmpty {
                    Section {
                        ForEach(overdueTasks) { task in
                            NavigationLink {
                                TaskDetailView(task: task)
                            } label: {
                                TaskRow(task: task)
                            }
                        }
                        .onDelete { indices in
                            indices.forEach { modelContext.delete(overdueTasks[$0]) }
                        }
                    } header: {
                        Text("Overdue (\(overdueTasks.count))")
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    ForEach(incompleteTasks) { task in
                        NavigationLink {
                            TaskDetailView(task: task)
                        } label: {
                            TaskRow(task: task)
                        }
                    }
                    .onDelete { indices in
                        indices.forEach { modelContext.delete(incompleteTasks[$0]) }
                    }
                } header: {
                    Text("To Do (\(incompleteTasks.count))")
                }
                
                if !completedTasks.isEmpty {
                    Section {
                        ForEach(completedTasks) { task in
                            NavigationLink {
                                TaskDetailView(task: task)
                            } label: {
                                TaskRow(task: task)
                            }
                        }
                        .onDelete { indices in
                            indices.forEach { modelContext.delete(completedTasks[$0]) }
                        }
                    } header: {
                        Text("Completed (\(completedTasks.count))")
                            .foregroundStyle(.green)
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        AddTaskView(userId: userId)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct TaskRow: View {
    let task: Task
    
    var body: some View {
        HStack {
            Button {
                task.isDone.toggle()
            } label: {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .primary)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isDone)
                
                if let dueDate = task.dueDate {
                    Label(dueDate.formatted(date: .abbreviated, time: .shortened),
                          systemImage: "calendar")
                        .font(.subheadline)
                }
                
                if let location = task.location {
                    Label(location, systemImage: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            if let category = task.category, !category.isEmpty {
                Text(category)
                    .font(.caption)
                    .padding(4)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Rectangle())
            }
        }
    }
}
