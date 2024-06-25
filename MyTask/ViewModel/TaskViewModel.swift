//
//  TaskViewModel.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 20/06/2024.
//

import Foundation
import Combine

final class TaskViewModel: ObservableObject {
    @Published var tasks : [Task] = []
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    private var cancellable = Set<AnyCancellable>()
//    private var tempTask = Task.createMockTask()
    private var _isCompleted: Bool = false
    
    private var taskRepository: TaskRepository
    
    
    var shouldDismiss = PassthroughSubject<Bool, Never>()
    
    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }
    
    deinit {
        cancelSubscription()
    }
    
    func cancelSubscription() {
        cancellable.forEach { $0.cancel() }
    }
    
    func getTasks(isComleted: Bool) {
        _isCompleted = isComleted
//        self.tasks = taskRepository.get(isCompleted: !isComleted)
        taskRepository.get(isCompleted: !isComleted)
            .sink {[weak self] fetchOperationResult in
                switch fetchOperationResult {
                case .success(let fetchedTasks):
                    self?.errorMessage = ""
                    self?.tasks = fetchedTasks
                case .failure(let failure):
                    self?.processOperationError(failure)
                }
            }.store(in: &cancellable)
        
//        tasks = tempTask.filter({$0.isCompleted == !isActive})
    }
    
    func addTask(task: Task) {
//        let taskId = Int.random(in: 4...100)
//        let taskToAdd = Task(id: taskId, name: task.name, description: task.description, isCompleted: task.isCompleted, finishDate: task.finishDate)
//        tempTask.append(taskToAdd)
        taskRepository.add(task: task).sink {[weak self] addOperationResult in
            self?.processOperationResult(operationResult: addOperationResult)
        }.store(in: &cancellable)
    }
    
    func updateTask(task: Task){
//        if let index = tempTask.firstIndex(where: {$0.id == task.id}) {
//            tempTask[index].name = task.name
//            tempTask[index].description = task.description
//            tempTask[index].finishDate = task.finishDate
//            tempTask[index].isCompleted = task.isCompleted
//            return true
//        }
        taskRepository.update(task: task).sink {[weak self] updateOperationResult in
            self?.processOperationResult(operationResult: updateOperationResult)
        }.store(in: &cancellable)
    }
    
    func deleteTask(task: Task) {
//        if let index = tempTask.firstIndex(where: {$0.id == task.id}) {
//            tempTask.remove(at: index)
//            return true
//        }
        taskRepository.delete(task: task).sink {[weak self] deleteOperationResult in
            self?.processOperationResult(operationResult: deleteOperationResult)
        }.store(in: &cancellable)
    }
    
    private func processOperationResult(operationResult: Result<Bool, TaskRepositoryError>) {
        switch operationResult {
        case .success(_):
            self.errorMessage = ""
            self.getTasks(isComleted: _isCompleted)
            shouldDismiss.send(true)
//            return success
        case .failure(let failure):
            processOperationError(failure)
//            return false
        }
    }
    private func processOperationError(_ error: TaskRepositoryError) {
        switch error {
        case .operationFailure(let errorMessage):
            self.showError = true
            self.errorMessage = errorMessage
            shouldDismiss.send(false)
        }
    }
}
