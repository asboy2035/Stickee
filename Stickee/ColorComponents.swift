//
//  ColorComponents.swift
//  Stickee
//
//  Created by ash on 2/5/25.
//


import SwiftUI

struct ColorComponents: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double
    
    init(color: Color) {
        let resolvedColor = NSColor(color).usingColorSpace(.sRGB) ?? .yellow
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var opacity: CGFloat = 0
        
        resolvedColor.getRed(&red, green: &green, blue: &blue, alpha: &opacity)
        
        self.red = Double(red)
        self.green = Double(green)
        self.blue = Double(blue)
        self.opacity = Double(opacity)
    }
    
    var color: Color {
        Color(nsColor: NSColor(srgbRed: CGFloat(red),
                             green: CGFloat(green),
                             blue: CGFloat(blue),
                             alpha: CGFloat(opacity)))
    }
}
