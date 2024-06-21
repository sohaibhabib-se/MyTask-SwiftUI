//
//  Task.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 20/06/2024.
//

import Foundation
struct Task {
    let id: UUID
    var name: String
    var description: String
    var isCompleted: Bool
    var finishDate: Date
    
//    static func createMockTask() -> [Task] {
//        return [
//            Task(id: UUID(), name: "Go to Gym", description: "back workout", isCompleted: false, finishDate: Date()),
//            Task(id: UUID(), name: "Car Wash", description: "Washing car for long drive", isCompleted: false, finishDate: Date()),
//            Task(id: UUID(), name: "Office Work", description: "Fininsh the assigned module", isCompleted: true, finishDate: Date())
//        ]
//    }
    static func createEmptyTask() -> Task {
        return
            Task(id: UUID(), name: "", description: "", isCompleted: false, finishDate: Date())
        
    }

}
