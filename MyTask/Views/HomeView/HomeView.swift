//
//  HomeView.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 20/06/2024.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel = TaskViewModelFactory.createTaskViewModel()
//    @State private var pickerFilters: [String] = ["Active", "Closed"]
    @State private var defaultPickerSelectedItem: String = "Active"
    @State private var showAddTaskView: Bool = false
    @State private var showTaskDetailView: Bool = false
    @State private var selectedTask: Task = Task.createEmptyTask()
    @State private var refreshTaskList: Bool = false
    @State private var showErrorAlert: Bool = false
    
    
    var body: some View {
        NavigationStack {
            
            PickerComponent(defaultPickerSelectedItem: $defaultPickerSelectedItem).onChange(of: defaultPickerSelectedItem) { newValue in
                taskViewModel.getTasks(isComleted: defaultPickerSelectedItem == "Active")
            }
            
            List(taskViewModel.tasks, id: \.id) { task in
                VStack(alignment: .leading) {
                    Text(task.name).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    HStack{
                        Text(task.description).font(.subheadline)
                            .lineLimit(2)
                        Spacer()
                        Text(task.finishDate.toString()).font(.subheadline)
                    }
                    
    //                Text("\(task.finishDate)")
                }
                .onTapGesture {
                    selectedTask = task
                    showTaskDetailView.toggle()
                }
            }
            .onAppear{
                taskViewModel.getTasks(isComleted: true)
            }
            .onDisappear(perform: {
                taskViewModel.cancelSubscription()
            })
//            .onChange(of: refreshTaskList, perform: { newValue in
//                taskViewModel.getTasks(isComleted: defaultPickerSelectedItem == "Active")
//            })
            /*.onChange(of: taskViewModel.errorMessage, perform: { newValue in
                showErrorAlert.toggle()
             })*/.alert("Task Error", isPresented: $taskViewModel.showError, actions: {
                Button(action: {}) {
                    Text("Ok")
                }
            }, message: {
                Text(taskViewModel.errorMessage)
            })
            .listStyle(.plain)
                .navigationTitle("Home")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
//                            print("Add task view")
                            showAddTaskView = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showAddTaskView, content: {
                    AddTaskView(taskViewModel: taskViewModel, showAddTaskView: $showAddTaskView)
                })
                .sheet(isPresented: $showTaskDetailView, content: {
                    TaskDetailView(taskViewModel: taskViewModel, showTaskDetailView: $showTaskDetailView, selectedTask: $selectedTask)
                })
        }
    }
}

#Preview {
    HomeView()
}
