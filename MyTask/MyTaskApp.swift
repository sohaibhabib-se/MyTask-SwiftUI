//
//  MyTaskApp.swift
//  MyTask
//
//  Created by Muhammad Sohaib on 20/06/2024.
//

import SwiftUI

@main
struct MyTaskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
