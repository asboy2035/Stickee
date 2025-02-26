//
//  NewNoteView.swift
//  Stickee
//
//  Created by ash on 2/5/25.
//

import SwiftUI

struct NewNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var content = ""
    let color: Color
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $content)
                    .font(.system(.body, design: .monospaced))
                    .frame(minHeight: 200)
            }
            .padding()
            .navigationTitle("newNoteLabel")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancelLabel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("saveLabel") {
                        let note = Note(content: content)
                        modelContext.insert(note)
                        try? modelContext.save()
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}
