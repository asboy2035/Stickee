//
//  StickeeApp.swift
//  Stickee
//
//  Created by ash on 2/5/25.
//

import SwiftUI
import SwiftData

@main
struct StickeeApp: App {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([Note.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Note") {
                    NotificationCenter.default.post(name: Notification.Name("CreateNewNote"), object: nil)
                }
                .keyboardShortcut("n")
            }
            
            CommandGroup(replacing: .saveItem) { }  // Remove default save menu items
            
            CommandGroup(after: .newItem) {
                Button("Import Markdown") {
                    NotificationCenter.default.post(name: Notification.Name("ImportMarkdown"), object: nil)
                }
                .keyboardShortcut("i")
            }
        }
        
        MenuBarExtra("Stickee", systemImage: "note.text") {
            Button("New Note") {
                NotificationCenter.default.post(name: Notification.Name("CreateNewNote"), object: nil)
            }
            Button("Show All Notes") {
                NSApp.activate(ignoringOtherApps: true)
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
