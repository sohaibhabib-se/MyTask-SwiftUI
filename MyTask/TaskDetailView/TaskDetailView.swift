//
//  TaskDetailView.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 20/06/2024.
//

import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var taskViewModel: TaskViewModel
    @Binding var showTaskDetailView: Bool
    @Binding var selectedTask: Task
    @Binding var refreshTaskList: Bool
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Task Detail")) {
                    TextField("Task Name", text: $selectedTask.name)
                    TextEditor(text: $selectedTask.description)
                    Toggle("Mark Complete", isOn: $selectedTask.isCompleted)
                }
                
                Section(header: Text("Task date/time")) {
                    DatePicker("Task date", selection: $selectedTask.finishDate)
                }
                
                Section(header: Text("Task date/time")) {
                    Button{
                        if(taskViewModel.deleteTask(task: selectedTask)) {
                            showTaskDetailView.toggle()
                            refreshTaskList.toggle()
                        }
                    } label: {
                        Text("Delete")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                        
                    }
                }
            }
            .navigationTitle("Task Detail")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
//                        print("Cancel Preessed")
                        showTaskDetailView.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        if(taskViewModel.updateTask(task: selectedTask)) {
                            showTaskDetailView.toggle()
                            refreshTaskList.toggle()
                        }
                    } label: {
                        Text("Update")
                    }
                }

            }
        }
    }
}

#Preview {
    TaskDetailView(taskViewModel: TaskViewModel(), showTaskDetailView: .constant(false), selectedTask: .constant(Task.createMockTask().first!), refreshTaskList: .constant(false))
}
