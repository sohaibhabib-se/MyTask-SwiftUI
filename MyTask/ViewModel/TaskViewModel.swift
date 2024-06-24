//
//  TaskViewModel.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 20/06/2024.
//

import Foundation
final class TaskViewModel: ObservableObject {
    @Published var tasks : [Task] = []
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
//    private var tempTask = Task.createMockTask()
    
    private var taskRepository: TaskRepository
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    func getTasks(isComleted: Bool) {
//        self.tasks = taskRepository.get(isCompleted: !isComleted)
        let fetchOperationResult = taskRepository.get(isCompleted: !isComleted)
        switch fetchOperationResult {
        case .success(let fetchedTasks):
            self.errorMessage = ""
            self.tasks = fetchedTasks
        case .failure(let failure):
            processOperationError(failure)
        }
//        tasks = tempTask.filter({$0.isCompleted == !isActive})
    }
    
    func addTask(task: Task) -> Bool {
//        let taskId = Int.random(in: 4...100)
//        let taskToAdd = Task(id: taskId, name: task.name, description: task.description, isCompleted: task.isCompleted, finishDate: task.finishDate)
//        tempTask.append(taskToAdd)
        let addOperationResult = taskRepository.add(task: task)
        return processOperationResult(operationResult: addOperationResult)
    }
    
    func updateTask(task: Task) -> Bool {
//        if let index = tempTask.firstIndex(where: {$0.id == task.id}) {
//            tempTask[index].name = task.name
//            tempTask[index].description = task.description
//            tempTask[index].finishDate = task.finishDate
//            tempTask[index].isCompleted = task.isCompleted
//            return true
//        }
        let updateOperationResult = taskRepository.update(task: task)
        return processOperationResult(operationResult: updateOperationResult)
    }
    
    func deleteTask(task: Task) -> Bool {
//        if let index = tempTask.firstIndex(where: {$0.id == task.id}) {
//            tempTask.remove(at: index)
//            return true
//        }
        let deleteOperationResult = taskRepository.delete(task: task)
        return processOperationResult(operationResult: deleteOperationResult)
    }
    
    private func processOperationResult(operationResult: Result<Bool, TaskRepositoryError>) -> Bool {
        switch operationResult {
        case .success(let success):
            self.errorMessage = ""
            return success
        case .failure(let failure):
            processOperationError(failure)
            return false
        }
    }
    private func processOperationError(_ error: TaskRepositoryError) {
        switch error {
        case .operationFailure(let errorMessage):
            self.showError = true
            self.errorMessage = errorMessage
        }
    }
}
