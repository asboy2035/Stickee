//
//  ContentView.swift
//  Stickee
//
//  Created by ash on 2/5/25.
//

import SwiftUI
import SwiftData
import MarkdownUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [Note]
    @State private var selectedColor: Color = Color(nsColor: .systemYellow)
    @State private var isShowingNewNoteSheet = false
    @AppStorage("windowColorComponents") private var savedColorComponents: Data = try! JSONEncoder().encode(ColorComponents(color: Color(nsColor: .systemYellow)))
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack {
                    Text("What's on your mind?")
                        .font(.system(size: 24, weight: .bold, design: .serif))
                    
                    HStack {
                        Button("Create New Note") {
                            isShowingNewNoteSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                        
                        ColorPicker("Window Color", selection: $selectedColor)
                            .onChange(of: selectedColor) {
                                if let encodedData = try? JSONEncoder().encode(ColorComponents(color: selectedColor)) {
                                    savedColorComponents = encodedData
                                }
                            }
                    }
                }
                
                List {
                    Section("Your Notes") {
                        ForEach(notes) { note in
                            NoteListItem(note: note, color: selectedColor)
                        }
                        .onDelete(perform: deleteNotes)
                    }
                }
                .background(.background.opacity(0.4))
                .cornerRadius(8)
            }
            .frame(minWidth: 350, maxWidth: 500, minHeight: 400)
            .padding()
            .scrollContentBackground(.hidden)
            .background(VisualEffectView(material: .sidebar, blendingMode: .behindWindow).edgesIgnoringSafeArea(.all))
            
            .navigationTitle("Stickee")
            .sheet(isPresented: $isShowingNewNoteSheet) {
                NewNoteView(color: selectedColor)
            }
            .onAppear {
                if let colorComponents = try? JSONDecoder().decode(ColorComponents.self, from: savedColorComponents) {
                    selectedColor = colorComponents.color
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("CreateNewNote"))) { _ in
                isShowingNewNoteSheet = true
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ImportMarkdown"))) { _ in
                importMarkdown()
            }
        }
    }
    
    private func deleteNotes(_ indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(notes[index])
        }
        try? modelContext.save()
    }
    
    private func importMarkdown() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.text]
        
        if panel.runModal() == .OK {
            guard let url = panel.url else { return }
            do {
                let content = try String(contentsOf: url)
                let note = Note(content: content)
                modelContext.insert(note)
                try modelContext.save()
            } catch {
                print("Error importing markdown: \(error)")
            }
        }
    }
}

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = .active
        return visualEffectView
    }
    
    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}

#Preview {
    ContentView()
}
