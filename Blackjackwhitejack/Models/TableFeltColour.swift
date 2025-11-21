//
//  TableFeltColour.swift
//  Natural - Modern Blackjack
//
//  Created by Claude Code
//  Part of Phase 5: Settings & Customisation
//

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 🎨 TABLE FELT COLOUR ENUMERATION                                           ║
// ║                                                                            ║
// ║ Purpose: Defines available table felt colour options                      ║
// ║ Business Context: Players have different visual preferences. Some prefer  ║
// ║                   the classic casino green, while others like darker or   ║
// ║                   more vibrant colours. Offering customisation makes the  ║
// ║                   app feel personal and increases player satisfaction.    ║
// ║                                                                            ║
// ║ Colour Psychology:                                                         ║
// ║ • Classic Green: Traditional casino feel, calming                         ║
// ║ • Royal Blue: Sophisticated, professional                                 ║
// ║ • Burgundy Red: Bold, energetic                                           ║
// ║ • Midnight Black: Modern, sleek                                           ║
// ║ • Emerald Green: Rich, luxurious                                          ║
// ║ • Navy Blue: Deep, elegant                                                ║
// ║                                                                            ║
// ║ Used By: SettingsManager, GameView (background colour)                    ║
// ║ Related Spec: See "Settings & Customisation" section                      ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import SwiftUI

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 🎨 TABLE FELT COLOUR ENUM                                                  ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

enum TableFeltColour: String, Codable, CaseIterable, Identifiable {

    case classicGreen   = "Classic Green"
    case royalBlue      = "Royal Blue"
    case burgundyRed    = "Burgundy Red"
    case midnightBlack  = "Midnight Black"
    case emeraldGreen   = "Emerald Green"
    case navyBlue       = "Navy Blue"

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🔑 IDENTIFIABLE CONFORMANCE                                      │
    // └─────────────────────────────────────────────────────────────────┘

    var id: String { rawValue }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🎨 COLOUR VALUES                                                 │
    // │                                                                  │
    // │ Carefully selected hex colours for optimal visual appearance    │
    // │ All colours tested for contrast with white cards and text       │
    // └─────────────────────────────────────────────────────────────────┘

    /// SwiftUI Color for this felt colour
    var color: Color {
        switch self {
        case .classicGreen:
            return Color(hex: "0D5D28") // Traditional casino green
        case .royalBlue:
            return Color(hex: "1E3A8A") // Deep royal blue
        case .burgundyRed:
            return Color(hex: "7C2D12") // Rich burgundy
        case .midnightBlack:
            return Color(hex: "0F172A") // Almost black with slight blue
        case .emeraldGreen:
            return Color(hex: "047857") // Vibrant emerald
        case .navyBlue:
            return Color(hex: "1E40AF") // Classic navy
        }
    }

    /// UIColor version for UIKit compatibility
    var uiColor: UIColor {
        return UIColor(color)
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 📝 DISPLAY PROPERTIES                                            │
    // └─────────────────────────────────────────────────────────────────┘

    /// Display name for UI (same as raw value)
    var displayName: String {
        return rawValue
    }

    /// Emoji icon for visual representation
    var icon: String {
        switch self {
        case .classicGreen:   return "🟢"
        case .royalBlue:      return "🔵"
        case .burgundyRed:    return "🔴"
        case .midnightBlack:  return "⚫"
        case .emeraldGreen:   return "💚"
        case .navyBlue:       return "🫐"
        }
    }

    /// Description for settings UI
    var description: String {
        switch self {
        case .classicGreen:
            return "Traditional casino green - the authentic experience"
        case .royalBlue:
            return "Sophisticated royal blue - professional elegance"
        case .burgundyRed:
            return "Bold burgundy red - energetic and dramatic"
        case .midnightBlack:
            return "Modern midnight black - sleek and contemporary"
        case .emeraldGreen:
            return "Rich emerald green - luxurious and vibrant"
        case .navyBlue:
            return "Classic navy blue - deep and elegant"
        }
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 🎨 COLOR EXTENSION FOR HEX SUPPORT                                         ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

extension Color {
    /// Initialize Color from hex string
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

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📖 USAGE EXAMPLES                                                          ║
// ║                                                                            ║
// ║ Get colour for UI:                                                         ║
// ║   let feltColour = TableFeltColour.classicGreen                           ║
// ║   ZStack {                                                                 ║
// ║       feltColour.color.ignoresSafeArea()                                  ║
// ║       // Game content                                                      ║
// ║   }                                                                        ║
// ║                                                                            ║
// ║ Display in picker:                                                         ║
// ║   Picker("Table Colour", selection: $selectedColour) {                    ║
// ║       ForEach(TableFeltColour.allCases) { colour in                       ║
// ║           HStack {                                                         ║
// ║               Text(colour.icon)                                            ║
// ║               Text(colour.displayName)                                     ║
// ║           }                                                                ║
// ║           .tag(colour)                                                     ║
// ║       }                                                                    ║
// ║   }                                                                        ║
// ║                                                                            ║
// ║ Persistence:                                                               ║
// ║   let encoded = try JSONEncoder().encode(TableFeltColour.classicGreen)    ║
// ║   let decoded = try JSONDecoder().decode(TableFeltColour.self, from: encoded) ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
