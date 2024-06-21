//
//  TaskViewModel.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 20/06/2024.
//

import Foundation
final class TaskViewModel: ObservableObject {
    @Published var tasks : [Task] = []
//    private var tempTask = Task.createMockTask()
    
    private var taskRepository: TaskRepository
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func getTasks(isComleted: Bool) {
        self.tasks = taskRepository.get(isCompleted: !isComleted)
//        tasks = tempTask.filter({$0.isCompleted == !isActive})
    }
    
    func addTask(task: Task) -> Bool {
//        let taskId = Int.random(in: 4...100)
//        let taskToAdd = Task(id: taskId, name: task.name, description: task.description, isCompleted: task.isCompleted, finishDate: task.finishDate)
//        tempTask.append(taskToAdd)
        return taskRepository.add(task: task)
    }
    
    func updateTask(task: Task) -> Bool {
//        if let index = tempTask.firstIndex(where: {$0.id == task.id}) {
//            tempTask[index].name = task.name
//            tempTask[index].description = task.description
//            tempTask[index].finishDate = task.finishDate
//            tempTask[index].isCompleted = task.isCompleted
//            return true
//        }
        return taskRepository.update(task: task)
    }
    
    func deleteTask(task: Task) -> Bool {
//        if let index = tempTask.firstIndex(where: {$0.id == task.id}) {
//            tempTask.remove(at: index)
//            return true
//        }
        return taskRepository.delete(task: task)
    }
}
