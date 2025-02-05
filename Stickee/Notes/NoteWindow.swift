//
//  NoteWindow.swift
//  Stickee
//
//  Created by ash on 2/5/25.
//

import SwiftUI
import MarkdownUI

struct NoteWindow: View {
    @Bindable var note: Note
    @Environment(\.modelContext) private var modelContext
    @State private var isEditing = false
    let windowColor: Color
    
    var body: some View {
        VStack {
            HStack {
                Button(isEditing ? "View" : "Edit") {
                    isEditing.toggle()
                }
                Spacer()
                ShareLink(item: note.content)
            }
            .padding(.horizontal)
            
            if isEditing {
                TextEditor(text: $note.content)
                    .font(.system(.body, design: .monospaced))
                    .onChange(of: note.content) {
                        try? modelContext.save()
                    }
            } else {
                ScrollView {
                    Markdown(note.content)
                        .padding()
                }
            }
        }
        .frame(minWidth: 300, minHeight: 200)
        .background(windowColor.opacity(0.1))
        .background(VisualEffectView(material: .sidebar, blendingMode: .behindWindow).edgesIgnoringSafeArea(.all))
        .onAppear() {
            DispatchQueue.main.async {
                if let window = NSApp.keyWindow {
                    window.titlebarAppearsTransparent = true
                    window.styleMask.insert(.fullSizeContentView)
                    window.level = .floating
                    window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
                }
            }
        }
    }
}
