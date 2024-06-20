//
//  Task.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 20/06/2024.
//

import Foundation
struct Task {
    let id: Int
    var name: String
    var description: String
    var isCompleted: Bool
    var finishDate: Date
    
    static func createMockTask() -> [Task] {
        return [
            Task(id: 1, name: "Go to Gym", description: "back workout", isCompleted: false, finishDate: Date()),
            Task(id: 2, name: "Car Wash", description: "Washing car for long drive", isCompleted: false, finishDate: Date()),
            Task(id: 3, name: "Office Work", description: "Fininsh the assigned module", isCompleted: true, finishDate: Date())
        ]
    }
}
