//
//  TaskRepository.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 21/06/2024.
//

import Foundation
import CoreData

protocol TaskRepository {
    func get(isCompleted: Bool) -> Result<[Task], TaskRepositoryError>
    func update(task: Task) -> Result<Bool, TaskRepositoryError>
    func add(task: Task) -> Result<Bool, TaskRepositoryError>
    func delete(task: Task) -> Result<Bool, TaskRepositoryError>
}

final class TaskRepositoryImplementation: TaskRepository {
    
    private let managedObjectContext: NSManagedObjectContext = PersistenceController.shared.viewContext
    
    func get(isCompleted: Bool) -> Result<[Task], TaskRepositoryError> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isCompleted = %@", NSNumber(value: isCompleted))
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            if(!result.isEmpty) {
                return .success(result.map({Task(id: $0.id!, name: $0.name ?? "", description: $0.taskDescription ?? "", isCompleted: $0.isCompleted, finishDate: $0.finishDate ?? Date())}))
            }
            
//            return .success([])
            return .failure(.operationFailure("Unable to fetch"))
        } catch {
            return .failure(.operationFailure("Unable to fetch the records, please try again later or contact support."))
        }
    }
    
    func update(task: Task) -> Result<Bool, TaskRepositoryError> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", task.id as CVarArg)
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                existingTask.name = task.name
                existingTask.taskDescription = task.description
                existingTask.finishDate = task.finishDate
                existingTask.isCompleted = task.isCompleted
                
                try managedObjectContext.save()
                return .success(true)
            } else {
                print("No task found with \(task.id)")
                return .failure(.operationFailure("No task found with id \(task.id)"))
            }
//            if(existingTask != nil) {
//               
//            }
        } catch {
            managedObjectContext.rollback()
            return .failure(.operationFailure("Unable to fetch update record, please try again or contact support."))
        }
    }
    
    func add(task: Task) -> Result<Bool, TaskRepositoryError> {
        let taskEntity = TaskEntity(context: managedObjectContext)
        taskEntity.id = UUID()
        taskEntity.isCompleted = false
        taskEntity.name = task.name
        taskEntity.taskDescription = task.description
        taskEntity.finishDate = task.finishDate
        
        do {
            try managedObjectContext.save()
            return .success(true)
        }
        catch {
            return .failure(.operationFailure("Unable to add task, please try again or contact suport."))
        }
    }
    
    func delete(task: Task) -> Result<Bool, TaskRepositoryError> {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", task.id as CVarArg)
        do {
            if let existingTask = try managedObjectContext.fetch(fetchRequest).first {
                managedObjectContext.delete(existingTask)
                try managedObjectContext.save()
                return .success(true)
            } else {
                print("No task found to delete with id: \(task.id)")
                return .failure(.operationFailure("Unable to delete record, please try again or contact support."))
            }
        } catch {
            managedObjectContext.rollback()
            return .failure(.operationFailure("Unable to delete record, please try again or contact support."))
        }
    }
    
    
}
