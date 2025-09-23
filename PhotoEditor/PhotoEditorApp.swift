//
//  PhotoEditorApp.swift
//  PhotoEditor
//
//  Created by Begench on 23.09.2025.
//

import SwiftUI

@main
struct PhotoEditorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
