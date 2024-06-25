//
//  TaskRepository.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 21/06/2024.
//

import Foundation
import CoreData
import Combine

protocol TaskRepository {
    func get(isCompleted: Bool) -> AnyPublisher<Result<[Task], TaskRepositoryError>, Never>
    func update(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never>
    func add(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never>
    func delete(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never>
}

final class TaskRepositoryImplementation: TaskRepository {
    
    private let managedObjectContext: NSManagedObjectContext = PersistenceController.shared.viewContext
    
    func get(isCompleted: Bool) -> AnyPublisher<Result<[Task], TaskRepositoryError>, Never> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isCompleted = %@", NSNumber(value: isCompleted))
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            if(!result.isEmpty) {
                let clientContract = result.map({Task(id: $0.id!, name: $0.name ?? "", description: $0.taskDescription ?? "", isCompleted: $0.isCompleted, finishDate: $0.finishDate ?? Date())})
                
                return Just(.success(clientContract)).eraseToAnyPublisher()
            }
            
            return Just(.success([])).eraseToAnyPublisher()
//            return .failure(.operationFailure("Unable to fetch"))
        } catch {
            return Just(.failure(.operationFailure("Unable to fetch the records, please try again later or contact support."))).eraseToAnyPublisher()
        }
    }
    
    func update(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", task.id as CVarArg)
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                existingTask.name = task.name
                existingTask.taskDescription = task.description
                existingTask.finishDate = task.finishDate
                existingTask.isCompleted = task.isCompleted
                
                try managedObjectContext.save()
                return Just(.success(true)).eraseToAnyPublisher()
            } else {
                print("No task found with \(task.id)")
                return Just(.failure(.operationFailure("No task found with id \(task.id)"))).eraseToAnyPublisher()
            }
//            if(existingTask != nil) {
//               
//            }
        } catch {
            managedObjectContext.rollback()
            return Just(.failure(.operationFailure("Unable to fetch update record, please try again or contact support."))).eraseToAnyPublisher()
        }
    }
    
    func add(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never> {
        let taskEntity = TaskEntity(context: managedObjectContext)
        taskEntity.id = UUID()
        taskEntity.isCompleted = false
        taskEntity.name = task.name
        taskEntity.taskDescription = task.description
        taskEntity.finishDate = task.finishDate
        
        do {
            try managedObjectContext.save()
            return Just(.success(true)).eraseToAnyPublisher()
        }
        catch {
            return Just(.failure(.operationFailure("Unable to add task, please try again or contact suport."))).eraseToAnyPublisher()
        }
    }
    
    func delete(task: Task) -> AnyPublisher<Result<Bool, TaskRepositoryError>, Never> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", task.id as CVarArg)
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                managedObjectContext.delete(existingTask)
                try managedObjectContext.save()
                return Just(.success(true)).eraseToAnyPublisher()
            } else {
                print("No task found to delete with id: \(task.id)")
                return Just(.failure(.operationFailure("Unable to delete record, please try again or contact support."))).eraseToAnyPublisher()
            }
        } catch {
            managedObjectContext.rollback()
            return Just(.failure(.operationFailure("Unable to delete record, please try again or contact support."))).eraseToAnyPublisher()
        }
    }
    
    
}
