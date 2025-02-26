//
//  NoteListItem.swift
//  Stickee
//
//  Created by ash on 2/5/25.
//

import SwiftUI

struct NoteListItem: View {
    let note: Note
    let color: Color
    @State private var window: NSWindow?
    
    var body: some View {
        HStack {
            Text(note.content.prefix(50))
                .lineLimit(1)
            Spacer()
            Button("openButton") {
                openNewWindow()
            }
        }
    }
    
    private func openNewWindow() {
        // Close existing window if it exists
        window?.close()
        
        let newWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window = newWindow
        
        newWindow.backgroundColor = NSColor.clear
        newWindow.isMovableByWindowBackground = true
        newWindow.level = .floating
        newWindow.center()
        
        let hostingView = NSHostingView(
            rootView: NoteWindow(note: note, windowColor: color)
        )
        newWindow.contentView = hostingView
        newWindow.makeKeyAndOrderFront(nil)
    }
}

