//
//  Color+Design.swift
//  Anchor_iOS
//
//  Design system color tokens
//

import SwiftUI

extension Color {
    // Background colors
    static let primaryBg = Color(hex: "#0A0E14")
    static let secondaryBg = Color(hex: "#0F1419")
    static let tertiaryBg = Color(hex: "#1C2128")
    static let elevatedBg = Color(hex: "#161B22")
    
    // Accent colors
    static let emerald = Color(hex: "#10B981")
    static let emeraldLight = Color(hex: "#34D399")
    static let emeraldDark = Color(hex: "#059669")
    static let coralAlert = Color(hex: "#FF6B35")
    
    // Semantic colors
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "#9CA3AF")
    static let textTertiary = Color(hex: "#6B7280")
    static let warning = Color(hex: "#F59E0B")
    static let error = Color(hex: "#EF4444")
    static let neutral = Color(hex: "#6B7280")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

