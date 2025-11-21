//
//  SettingsManager.swift
//  Natural - Modern Blackjack
//
//  Created by Claude Code
//  Part of Phase 5: Settings & Customisation
//

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ ⚙️ SETTINGS MANAGER SERVICE                                                ║
// ║                                                                            ║
// ║ Purpose: Central manager for all user preferences and settings            ║
// ║ Business Context: Players want their preferences to persist across app    ║
// ║                   launches and apply immediately when changed. This       ║
// ║                   manager is the single source of truth for all settings. ║
// ║                                                                            ║
// ║ Responsibilities:                                                          ║
// ║ • Load settings from UserDefaults on app launch                           ║
// ║ • Save settings automatically when changed                                ║
// ║ • Provide @Published property for SwiftUI binding                         ║
// ║ • Validate settings values                                                ║
// ║ • Export/import settings as JSON                                          ║
// ║ • Reset to factory defaults                                               ║
// ║                                                                            ║
// ║ Architecture Pattern: Singleton with ObservableObject                     ║
// ║ Used By: SettingsViewModel, GameView, GameViewModel, AudioManager         ║
// ║                                                                            ║
// ║ Related Spec: See "Settings & Customisation" section                      ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Foundation
import Combine

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ ⚙️ SETTINGS MANAGER CLASS                                                  ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

class SettingsManager: ObservableObject {

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🔑 SINGLETON PATTERN                                             │
    // └─────────────────────────────────────────────────────────────────┘

    static let shared = SettingsManager()

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 📊 PUBLISHED STATE                                               │
    // │                                                                  │
    // │ This property triggers UI updates when settings change          │
    // │ Auto-saves to UserDefaults on every change                      │
    // └─────────────────────────────────────────────────────────────────┘

    @Published var userSettings: UserSettings {
        didSet {
            saveSettings()
        }
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🔧 INTERNAL PROPERTIES                                           │
    // └─────────────────────────────────────────────────────────────────┘

    /// UserDefaults key for settings storage
    private let settingsKey = "userSettings"

    /// JSON encoder for settings export
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()

    /// JSON decoder for settings import
    private let decoder = JSONDecoder()

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🏗️ INITIALISER                                                   │
    // │                                                                  │
    // │ Private to enforce singleton pattern                            │
    // │ Loads settings from UserDefaults on creation                    │
    // └─────────────────────────────────────────────────────────────────┘

    private init() {
        print("⚙️ SettingsManager initialising...")
        self.userSettings = Self.loadSettings()
        print("⚙️ SettingsManager ready")
    }

    // ╔═══════════════════════════════════════════════════════════════════╗
    // ║ 💾 PERSISTENCE OPERATIONS                                          ║
    // ╚═══════════════════════════════════════════════════════════════════╝

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 📂 LOAD SETTINGS                                                 │
    // │                                                                  │
    // │ Business Logic: Load saved settings from UserDefaults           │
    // │ Called by: init() on app launch                                 │
    // │                                                                  │
    // │ Returns: Saved settings if available, otherwise defaults        │
    // └─────────────────────────────────────────────────────────────────┘

    private static func loadSettings() -> UserSettings {
        guard let data = UserDefaults.standard.data(forKey: "userSettings") else {
            print("ℹ️ No saved settings found - using defaults")
            return .default
        }

        do {
            let decoder = JSONDecoder()
            var settings = try decoder.decode(UserSettings.self, from: data)

            // Validate loaded settings
            settings.validate()

            print("📂 Loaded user settings from UserDefaults")
            return settings

        } catch {
            print("❌ Failed to decode settings: \(error.localizedDescription)")
            print("   Using default settings")
            return .default
        }
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 💾 SAVE SETTINGS                                                 │
    // │                                                                  │
    // │ Business Logic: Save current settings to UserDefaults           │
    // │ Called by: Property didSet observer (automatic on every change) │
    // │                                                                  │
    // │ Side Effects: Validates settings before saving                  │
    // └─────────────────────────────────────────────────────────────────┘

    private func saveSettings() {
        do {
            // Validate before saving
            var validatedSettings = userSettings
            validatedSettings.validate()

            let data = try encoder.encode(validatedSettings)
            UserDefaults.standard.set(data, forKey: settingsKey)

            print("💾 Settings saved to UserDefaults")

        } catch {
            print("❌ Failed to save settings: \(error.localizedDescription)")
        }
    }

    // ╔═══════════════════════════════════════════════════════════════════╗
    // ║ 🔄 SETTINGS MANAGEMENT                                             ║
    // ╚═══════════════════════════════════════════════════════════════════╝

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🔄 RESET TO DEFAULTS                                             │
    // │                                                                  │
    // │ Business Logic: Reset all settings to factory defaults          │
    // │ Called by: SettingsView "Reset to Defaults" button              │
    // └─────────────────────────────────────────────────────────────────┘

    func resetToDefaults() {
        userSettings = .default
        print("🔄 Settings reset to defaults")
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 📤 EXPORT SETTINGS                                               │
    // │                                                                  │
    // │ Business Logic: Export settings as JSON string                  │
    // │ Called by: SettingsView "Export" button                         │
    // │                                                                  │
    // │ Returns: Pretty-printed JSON string or nil if encoding fails    │
    // └─────────────────────────────────────────────────────────────────┘

    func exportSettings() -> String? {
        do {
            let data = try encoder.encode(userSettings)
            let jsonString = String(data: data, encoding: .utf8)
            print("📤 Exported settings to JSON string")
            return jsonString
        } catch {
            print("❌ Failed to export settings: \(error.localizedDescription)")
            return nil
        }
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 📥 IMPORT SETTINGS                                               │
    // │                                                                  │
    // │ Business Logic: Import settings from JSON string                │
    // │ Called by: SettingsView "Import" button                         │
    // │                                                                  │
    // │ Parameters:                                                      │
    // │ • jsonString: JSON data to import                               │
    // │                                                                  │
    // │ Returns: true if successful, false otherwise                    │
    // └─────────────────────────────────────────────────────────────────┘

    func importSettings(from jsonString: String) -> Bool {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("❌ Invalid JSON string format")
            return false
        }

        do {
            var importedSettings = try decoder.decode(UserSettings.self, from: jsonData)
            importedSettings.validate()

            userSettings = importedSettings
            print("📥 Imported settings from JSON string")
            return true

        } catch {
            print("❌ Failed to import settings: \(error.localizedDescription)")
            return false
        }
    }

    // ╔═══════════════════════════════════════════════════════════════════╗
    // ║ 🎯 CONVENIENCE ACCESSORS                                           ║
    // ╚═══════════════════════════════════════════════════════════════════╝

    // These provide quick access to commonly used settings
    // Useful for components that don't need to observe all settings

    /// Quick access to sound effects enabled
    var soundEffectsEnabled: Bool {
        return userSettings.soundEffectsEnabled
    }

    /// Quick access to haptic feedback enabled
    var hapticFeedbackEnabled: Bool {
        return userSettings.hapticFeedbackEnabled
    }

    /// Quick access to animation speed duration
    var animationDuration: Double {
        return userSettings.animationSpeed.duration
    }

    /// Quick access to table felt colour
    var tableFeltColour: TableFeltColour {
        return userSettings.tableFeltColour
    }

    /// Quick access to card back design
    var cardBackDesign: CardBackDesign {
        return userSettings.cardBackDesign
    }

    /// Quick access to auto-stand preference
    var autoStandOn21: Bool {
        return userSettings.autoStandOn21
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📖 USAGE EXAMPLES                                                          ║
// ║                                                                            ║
// ║ Access settings:                                                           ║
// ║   let settings = SettingsManager.shared                                   ║
// ║   print(settings.tableFeltColour) // .classicGreen                        ║
// ║                                                                            ║
// ║ Modify settings:                                                           ║
// ║   settings.userSettings.soundVolume = 0.5                                 ║
// ║   // Automatically saved to UserDefaults                                  ║
// ║                                                                            ║
// ║ In SwiftUI View:                                                           ║
// ║   @StateObject private var settingsManager = SettingsManager.shared       ║
// ║                                                                            ║
// ║   var body: some View {                                                    ║
// ║       ZStack {                                                             ║
// ║           settingsManager.tableFeltColour.color                           ║
// ║               .ignoresSafeArea()                                          ║
// ║       }                                                                    ║
// ║   }                                                                        ║
// ║                                                                            ║
// ║ Reset to defaults:                                                         ║
// ║   settingsManager.resetToDefaults()                                       ║
// ║                                                                            ║
// ║ Export/Import:                                                             ║
// ║   if let json = settingsManager.exportSettings() {                        ║
// ║       // Share or save JSON                                               ║
// ║   }                                                                        ║
// ║                                                                            ║
// ║   if settingsManager.importSettings(from: jsonString) {                   ║
// ║       print("Settings imported successfully")                             ║
// ║   }                                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
