//
//  Note.swift
//  Stickee
//
//  Created by ash on 2/5/25.
//


import SwiftUI
import SwiftData

@Model
final class Note {
    var content: String
    var dateCreated: Date
    var id: UUID
    
    init(content: String = "") {
        self.content = content
        self.dateCreated = Date()
        self.id = UUID()
    }
}
