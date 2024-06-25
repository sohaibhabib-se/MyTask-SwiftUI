//
//  AddTaskView.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 20/06/2024.
//

import SwiftUI

struct AddTaskView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var taskToAdd: Task = Task.createEmptyTask()
//    @Binding var refreshTaskList: Bool
    @Binding var showAddTaskView: Bool
    @State var showDirtyCheckAlert: Bool = false
    
    var pickerDateRange: ClosedRange<Date> {
        let calender = Calendar.current
        let currentDateComponenet = calender.dateComponents([.day, .month, .year, .hour, .minute], from: Date())
        let startingDate = DateComponents(year: currentDateComponenet.year, month: currentDateComponenet.month, day: currentDateComponenet.day, hour: currentDateComponenet.hour, minute: currentDateComponenet.minute)
        let endingDateComponent = DateComponents(year: 2024, month: 12, day: 31)
        
        return calender.date(from: startingDate)! ... calender.date(from: endingDateComponent)!
    }
    
    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("Task Detail")) {
                    TextField("Task Name", text: $taskToAdd.name)
                    TextEditor(text: $taskToAdd.description)
                }
                
                Section(header: Text("Task date/time")) {
                    DatePicker("Task date", selection: $taskToAdd.finishDate, in: pickerDateRange)
                }
            }.onReceive(taskViewModel.shouldDismiss, perform: { shouldDismiss in
                if shouldDismiss {
                    showAddTaskView.toggle()
                }
            })
            .navigationTitle("Add Task")
            .alert("Task Error", isPresented: $taskViewModel.showError, actions: {
               Button(action: {}) {
                   Text("Ok")
               }
           }, message: {
               Text(taskViewModel.errorMessage)
           }).onDisappear(perform: {
               taskViewModel.cancelSubscription()
           })
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        if(!taskToAdd.name.isEmpty) {
                            showDirtyCheckAlert.toggle()
                        } else {
                            showAddTaskView.toggle()
                        }
                    } label: {
                        Text("Cancel")
                    }.alert("Save Task", isPresented: $showDirtyCheckAlert) {
                        Button{
                            showAddTaskView.toggle()
                        } label: {
                            Text("Cancel")
                        }
                        
                        Button{
                            addTask()
                        } label: {
                            Text("Save")
                        }
                    } message: {
                        Text("Would you like to save the task?")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        addTask()
                    } label: {
                        Text("Add")
                    }.disabled(taskToAdd.name.isEmpty)
                }

            }
        }
        
    }
    
    private func addTask() {
        taskViewModel.addTask(task: taskToAdd)
    }
}

#Preview {
    AddTaskView(taskViewModel: TaskViewModelFactory.createTaskViewModel(), showAddTaskView: .constant(false))
}
