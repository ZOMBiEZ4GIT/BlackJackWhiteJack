//
//  SettingsViewModel.swift
//  Natural - Modern Blackjack
//
//  Created by Claude Code
//  Part of Phase 5: Settings & Customisation
//

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ ⚙️ SETTINGS VIEW MODEL                                                     ║
// ║                                                                            ║
// ║ Purpose: Provides settings data and actions to SettingsView               ║
// ║ Business Context: This ViewModel bridges SettingsManager and the UI,      ║
// ║                   providing convenience methods for common operations.    ║
// ║                                                                            ║
// ║ Responsibilities:                                                          ║
// ║ • Expose settings manager to SwiftUI views                                ║
// ║ • Handle user actions (reset, export, import)                             ║
// ║ • Provide formatted display strings                                       ║
// ║ • Manage confirmation alerts                                              ║
// ║                                                                            ║
// ║ Used By: SettingsView                                                      ║
// ║ Uses: SettingsManager                                                      ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Foundation
import SwiftUI

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ ⚙️ SETTINGS VIEW MODEL CLASS                                               ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

class SettingsViewModel: ObservableObject {

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 📊 PUBLISHED STATE                                               │
    // └─────────────────────────────────────────────────────────────────┘

    /// Reference to settings manager (published for observation)
    @Published var settingsManager = SettingsManager.shared

    /// Show reset confirmation alert
    @Published var showResetConfirmation = false

    /// Show export sheet
    @Published var showExportSheet = false

    /// Show import sheet
    @Published var showImportSheet = false

    /// Export result message
    @Published var exportMessage: String?

    /// Import result message
    @Published var importMessage: String?

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🏗️ INITIALISER                                                   │
    // └─────────────────────────────────────────────────────────────────┘

    init() {
        print("⚙️ SettingsViewModel initialized")
    }

    // ╔═══════════════════════════════════════════════════════════════════╗
    // ║ 🎬 USER ACTIONS                                                    ║
    // ╚═══════════════════════════════════════════════════════════════════╝

    /// Request reset to defaults (shows confirmation)
    func requestReset() {
        showResetConfirmation = true
    }

    /// Confirm and execute reset to defaults
    func confirmReset() {
        settingsManager.resetToDefaults()
        showResetConfirmation = false
        print("✅ Settings reset to defaults")
    }

    /// Export settings as JSON
    func exportSettings() -> String {
        if let jsonString = settingsManager.exportSettings() {
            exportMessage = "Settings exported successfully"
            return jsonString
        } else {
            exportMessage = "Failed to export settings"
            return ""
        }
    }

    /// Import settings from JSON
    func importSettings(_ jsonString: String) {
        if settingsManager.importSettings(from: jsonString) {
            importMessage = "Settings imported successfully"
        } else {
            importMessage = "Failed to import settings - invalid format"
        }
    }

    // ╔═══════════════════════════════════════════════════════════════════╗
    // ║ 📊 COMPUTED PROPERTIES                                             ║
    // ╚═══════════════════════════════════════════════════════════════════╝

    /// Current settings object (for binding)
    var settings: Binding<UserSettings> {
        Binding(
            get: { self.settingsManager.userSettings },
            set: { self.settingsManager.userSettings = $0 }
        )
    }

    /// Formatted sound volume for display
    var soundVolumeDisplay: String {
        return "\(Int(settingsManager.userSettings.soundVolume * 100))%"
    }

    /// Formatted music volume for display
    var musicVolumeDisplay: String {
        return "\(Int(settingsManager.userSettings.musicVolume * 100))%"
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📖 USAGE EXAMPLES                                                          ║
// ║                                                                            ║
// ║ In SwiftUI View:                                                           ║
// ║   @StateObject private var viewModel = SettingsViewModel()                ║
// ║                                                                            ║
// ║   var body: some View {                                                    ║
// ║       List {                                                               ║
// ║           Toggle("Sound Effects", isOn: viewModel.settings.soundEffectsEnabled) ║
// ║                                                                            ║
// ║           Button("Reset to Defaults") {                                    ║
// ║               viewModel.requestReset()                                    ║
// ║           }                                                                ║
// ║       }                                                                    ║
// ║       .alert("Reset Settings?", isPresented: $viewModel.showResetConfirmation) { ║
// ║           Button("Reset", role: .destructive) {                           ║
// ║               viewModel.confirmReset()                                    ║
// ║           }                                                                ║
// ║           Button("Cancel", role: .cancel) {}                              ║
// ║       }                                                                    ║
// ║   }                                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
