//
//  AddTaskView.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 20/06/2024.
//

import SwiftUI

struct AddTaskView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var taskToAdd: Task = Task(id: 0, name: "", description: "", isCompleted: false, finishDate: Date())
    @Binding var refreshTaskList: Bool
    
    @Binding var showAddTaskView: Bool
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Task Detail")) {
                    TextField("Task Name", text: $taskToAdd.name)
                    TextEditor(text: $taskToAdd.description)
                }
                
                Section(header: Text("Task date/time")) {
                    DatePicker("Task date", selection: $taskToAdd.finishDate)
                }
            }
            .navigationTitle("Add Task")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
//                        print("Cancel Preessed")
                        showAddTaskView.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        if(taskViewModel.addTask(task: taskToAdd)) {
                            showAddTaskView.toggle()
                            refreshTaskList.toggle()
                        }
                    } label: {
                        Text("Add")
                    }
                }

            }
        }
        
    }
}

#Preview {
    AddTaskView(taskViewModel: TaskViewModel(), refreshTaskList: .constant(false), showAddTaskView: .constant(false))
}
