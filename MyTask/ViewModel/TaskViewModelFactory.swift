//
//  TaskViewModelFactory.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 21/06/2024.
//

import Foundation

final class TaskViewModelFactory {
    static func createTaskViewModel() -> TaskViewModel {
        return TaskViewModel(taskRepository: TaskRepositoryImplementation())
    }
}
