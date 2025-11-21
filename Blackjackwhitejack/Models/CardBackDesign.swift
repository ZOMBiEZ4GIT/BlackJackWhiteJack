//
//  CardBackDesign.swift
//  Natural - Modern Blackjack
//
//  Created by Claude Code
//  Part of Phase 5: Settings & Customisation
//

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 🎴 CARD BACK DESIGN ENUMERATION                                            ║
// ║                                                                            ║
// ║ Purpose: Defines available card back design options                       ║
// ║ Business Context: Card back design is a personal preference that affects  ║
// ║                   the visual experience. Classic designs feel traditional, ║
// ║                   while modern designs appeal to younger players.         ║
// ║                                                                            ║
// ║ Design Styles:                                                             ║
// ║ • Classic Red: Traditional casino playing card back                       ║
// ║ • Classic Blue: Alternative classic style                                 ║
// ║ • Gold Pattern: Luxurious, high-roller feel                               ║
// ║ • Modern Geometric: Contemporary, minimalist design                       ║
// ║                                                                            ║
// ║ Used By: CardView (for face-down cards), SettingsManager                  ║
// ║ Related Spec: See "Settings & Customisation" section                      ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import SwiftUI

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 🎴 CARD BACK DESIGN ENUM                                                   ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

enum CardBackDesign: String, Codable, CaseIterable, Identifiable {

    case classicRed      = "Classic Red"
    case classicBlue     = "Classic Blue"
    case goldPattern     = "Gold Pattern"
    case modernGeometric = "Modern Geometric"

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🔑 IDENTIFIABLE CONFORMANCE                                      │
    // └─────────────────────────────────────────────────────────────────┘

    var id: String { rawValue }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🎨 DESIGN COLOURS                                                │
    // │                                                                  │
    // │ Primary and accent colours for each card back design            │
    // └─────────────────────────────────────────────────────────────────┘

    /// Primary colour for this card back
    var primaryColor: Color {
        switch self {
        case .classicRed:
            return Color(hex: "B91C1C") // Deep red
        case .classicBlue:
            return Color(hex: "1E40AF") // Royal blue
        case .goldPattern:
            return Color(hex: "D97706") // Rich gold
        case .modernGeometric:
            return Color(hex: "6366F1") // Indigo
        }
    }

    /// Secondary/accent colour for pattern details
    var accentColor: Color {
        switch self {
        case .classicRed:
            return Color(hex: "7F1D1D") // Darker red
        case .classicBlue:
            return Color(hex: "1E3A8A") // Darker blue
        case .goldPattern:
            return Color(hex: "92400E") // Darker gold
        case .modernGeometric:
            return Color(hex: "4F46E5") // Darker indigo
        }
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 📝 DISPLAY PROPERTIES                                            │
    // └─────────────────────────────────────────────────────────────────┘

    /// Display name for UI
    var displayName: String {
        return rawValue
    }

    /// Emoji icon for visual representation
    var icon: String {
        switch self {
        case .classicRed:      return "🔴"
        case .classicBlue:     return "🔵"
        case .goldPattern:     return "🟡"
        case .modernGeometric: return "🟣"
        }
    }

    /// Description for settings UI
    var description: String {
        switch self {
        case .classicRed:
            return "Traditional red card back - timeless casino style"
        case .classicBlue:
            return "Classic blue card back - elegant alternative"
        case .goldPattern:
            return "Luxurious gold pattern - for high rollers"
        case .modernGeometric:
            return "Modern geometric design - contemporary style"
        }
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🎨 PATTERN STYLE                                                 │
    // │                                                                  │
    // │ Describes the visual pattern used for each design               │
    // └─────────────────────────────────────────────────────────────────┘

    /// Pattern style description (for rendering)
    var patternStyle: String {
        switch self {
        case .classicRed, .classicBlue:
            return "ornate" // Traditional ornate pattern
        case .goldPattern:
            return "damask" // Damask fabric-like pattern
        case .modernGeometric:
            return "geometric" // Clean geometric shapes
        }
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📖 USAGE EXAMPLES                                                          ║
// ║                                                                            ║
// ║ Apply to card back:                                                        ║
// ║   struct CardBackView: View {                                              ║
// ║       let design: CardBackDesign                                           ║
// ║                                                                            ║
// ║       var body: some View {                                                ║
// ║           RoundedRectangle(cornerRadius: 8)                                ║
// ║               .fill(design.primaryColor)                                   ║
// ║               .overlay(                                                    ║
// ║                   // Pattern overlay using design.accentColor              ║
// ║               )                                                            ║
// ║       }                                                                    ║
// ║   }                                                                        ║
// ║                                                                            ║
// ║ Display in picker:                                                         ║
// ║   Picker("Card Back", selection: $selectedDesign) {                        ║
// ║       ForEach(CardBackDesign.allCases) { design in                         ║
// ║           HStack {                                                         ║
// ║               Text(design.icon)                                            ║
// ║               Text(design.displayName)                                     ║
// ║           }                                                                ║
// ║           .tag(design)                                                     ║
// ║       }                                                                    ║
// ║   }                                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
