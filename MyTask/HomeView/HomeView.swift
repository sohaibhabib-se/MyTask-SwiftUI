//
//  HomeView.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 20/06/2024.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel = TaskViewModel()
    @State private var pickerFilters: [String] = ["Active", "Closed"]
    @State private var defaultPickerSelectedItem: String = "Active"
    @State private var showAddTaskView: Bool = false
    @State private var showTaskDetailView: Bool = false
    @State private var selectedTask: Task = Task(id: 0, name: "", description: "", isCompleted: false, finishDate: Date())
    @State private var refreshTaskList: Bool = false
    
    
    var body: some View {
        NavigationStack {
            
            Picker("Picker filter", selection: $defaultPickerSelectedItem) {
                ForEach(pickerFilters, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.segmented).onChange(of: defaultPickerSelectedItem) { newValue in
                taskViewModel.getTasks(isActive: defaultPickerSelectedItem == "Active")
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
                taskViewModel.getTasks(isActive: true)
            }
            .onChange(of: refreshTaskList, perform: { newValue in
                taskViewModel.getTasks(isActive: defaultPickerSelectedItem == "Active")
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
                    AddTaskView(taskViewModel: taskViewModel, refreshTaskList: $refreshTaskList, showAddTaskView: $showAddTaskView)
                })
                .sheet(isPresented: $showTaskDetailView, content: {
                    TaskDetailView(taskViewModel: taskViewModel, showTaskDetailView: $showTaskDetailView, selectedTask: $selectedTask, refreshTaskList: $refreshTaskList)
                })
        }
    }
}

#Preview {
    HomeView()
}
