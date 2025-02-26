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
                Button("newNoteLabel") {
                    NotificationCenter.default.post(name: Notification.Name("CreateNewNote"), object: nil)
                }
                .keyboardShortcut("n")
            }
            
            CommandGroup(replacing: .saveItem) { }  // Remove default save menu items
            
            CommandGroup(after: .newItem) {
                Button("importMarkdownLabel") {
                    NotificationCenter.default.post(name: Notification.Name("ImportMarkdown"), object: nil)
                }
                .keyboardShortcut("i")
            }
        }
        
        MenuBarExtra("appName", systemImage: "note.text") {
            Button("newNoteLabel") {
                NotificationCenter.default.post(name: Notification.Name("CreateNewNote"), object: nil)
            }
            Button("showAllNotesLabel") {
                NSApp.activate(ignoringOtherApps: true)
            }
            Divider()
            Button("quitLabel") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
