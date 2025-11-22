//
//  SettingsView.swift
//  Natural - Modern Blackjack
//
//  Created by Claude Code
//  Part of Phase 6.5: Tutorial & Help System - View Layer
//

// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║ SettingsView.swift                                                            ║
// ║                                                                               ║
// ║ App settings and customisation screen.                                       ║
// ║                                                                               ║
// ║ BUSINESS CONTEXT:                                                             ║
// ║ • Provides access to all app customisation options                           ║
// ║ • Tutorial and Help access point                                             ║
// ║ • Visual, audio, and gameplay preferences                                    ║
// ║ • Follows iOS Settings app patterns                                          ║
// ║                                                                               ║
// ║ SECTIONS:                                                                     ║
// ║ 1. Tutorial & Help                                                            ║
// ║ 2. Visual Settings (planned for Phase 5)                                     ║
// ║ 3. Audio & Haptics (planned for Phase 5)                                     ║
// ║ 4. Gameplay                                                                   ║
// ║ 5. About                                                                      ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

import SwiftUI

// ┌──────────────────────────────────────────────────────────────────────────┐
// │ ⚙️ SETTINGS VIEW                                                          │
// │                                                                           │
// │ Main settings screen with grouped sections.                              │
// └──────────────────────────────────────────────────────────────────────────┘

struct SettingsView: View {

    // ┌──────────────────────────────────────────────────────────────────────┐
    // │ 🔗 DEPENDENCIES                                                       │
    // └──────────────────────────────────────────────────────────────────────┘

    @ObservedObject private var tutorialManager = TutorialManager.shared
    @Environment(\.dismiss) private var dismiss

    // ┌──────────────────────────────────────────────────────────────────────┐
    // │ 🎨 STATE                                                              │
    // └──────────────────────────────────────────────────────────────────────┘

    @State private var showHelp = false
    @State private var showReplayConfirmation = false
    @State private var tutorialHintsEnabled: Bool
    @State private var contextualHintsEnabled: Bool

    // ┌──────────────────────────────────────────────────────────────────────┐
    // │ 🏗️ INITIALISER                                                        │
    // └──────────────────────────────────────────────────────────────────────┘

    init() {
        let progress = TutorialProgress.load()
        _tutorialHintsEnabled = State(initialValue: progress.tutorialHintsEnabled)
        _contextualHintsEnabled = State(initialValue: progress.showContextualHints)
    }

    // ┌──────────────────────────────────────────────────────────────────────┐
    // │ 🎨 BODY                                                               │
    // └──────────────────────────────────────────────────────────────────────┘

    var body: some View {
        NavigationView {
            List {
                // Tutorial & Help section
                tutorialHelpSection

                // Gameplay section
                gameplaySection

                // About section
                aboutSection
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.appBackground)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.info)
                }
            }
        }
        .sheet(isPresented: $showHelp) {
            HelpView()
        }
        .alert("Replay Tutorial?", isPresented: $showReplayConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Start Tutorial") {
                replayTutorial()
            }
        } message: {
            Text("This will restart the tutorial from the beginning. Your game progress will not be affected.")
        }
    }

    // ┌──────────────────────────────────────────────────────────────────────┐
    // │ 🎓 TUTORIAL & HELP SECTION                                            │
    // └──────────────────────────────────────────────────────────────────────┘

    private var tutorialHelpSection: some View {
        Section {
            // Tutorial Hints toggle
            Toggle(isOn: Binding(
                get: { tutorialHintsEnabled },
                set: { newValue in
                    tutorialHintsEnabled = newValue
                    tutorialManager.setTutorialHintsEnabled(newValue)
                }
            )) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.warning)
                    Text("Tutorial Hints")
                }
            }
            .tint(.info)

            // Contextual Hints toggle
            Toggle(isOn: Binding(
                get: { contextualHintsEnabled },
                set: { newValue in
                    contextualHintsEnabled = newValue
                    tutorialManager.setContextualHintsEnabled(newValue)
                }
            )) {
                HStack {
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.warning)
                    Text("Strategy Hints")
                }
            }
            .tint(.info)

            // Replay Tutorial
            Button(action: {
                showReplayConfirmation = true
            }) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.info)
                    Text("Replay Tutorial")
                        .foregroundColor(.white)
                }
            }

            // Help & Rules
            Button(action: {
                showHelp = true
            }) {
                HStack {
                    Image(systemName: "book.fill")
                        .foregroundColor(.info)
                    Text("Help & Rules")
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.mediumGrey)
                }
            }
        } header: {
            Text("Tutorial & Help")
        } footer: {
            Text("Strategy hints provide tips during gameplay based on your hand.")
        }
    }

    // ┌──────────────────────────────────────────────────────────────────────┐
    // │ 🎮 GAMEPLAY SECTION                                                   │
    // └──────────────────────────────────────────────────────────────────────┘

    private var gameplaySection: some View {
        Section {
            // Tutorial completion status
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(tutorialManager.tutorialProgress.hasCompletedTutorial ? .success : .mediumGrey)
                Text("Tutorial Completed")
                Spacer()
                Text(tutorialManager.tutorialProgress.hasCompletedTutorial ? "Yes" : "No")
                    .foregroundColor(.mediumGrey)
            }

            // Hands played (placeholder for future statistics integration)
            HStack {
                Image(systemName: "hand.raised.fill")
                    .foregroundColor(.info)
                Text("Hands Played")
                Spacer()
                Text("--")
                    .foregroundColor(.mediumGrey)
            }
        } header: {
            Text("Gameplay")
        }
    }

    // ┌──────────────────────────────────────────────────────────────────────┐
    // │ ℹ️ ABOUT SECTION                                                      │
    // └──────────────────────────────────────────────────────────────────────┘

    private var aboutSection: some View {
        Section {
            // Version
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundColor(.mediumGrey)
            }

            // Developer
            HStack {
                Text("Developer")
                Spacer()
                Text("Natural Blackjack")
                    .foregroundColor(.mediumGrey)
            }
        } header: {
            Text("About")
        } footer: {
            Text("Natural - Premium Blackjack\nPhase 6.5: Tutorial & Help System")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
        }
    }

    // ┌──────────────────────────────────────────────────────────────────────┐
    // │ 🔄 REPLAY TUTORIAL                                                    │
    // └──────────────────────────────────────────────────────────────────────┘

    private func replayTutorial() {
        tutorialManager.resetTutorial()
        tutorialManager.startTutorial()
        dismiss()
    }
}

// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║ 👁️ PREVIEW                                                                    ║
// ╚══════════════════════════════════════════════════════════════════════════════╝

#Preview("Settings View") {
    SettingsView()
}

// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║ 📖 USAGE EXAMPLES                                                             ║
// ║                                                                               ║
// ║ In GameView:                                                                  ║
// ║   @State private var showSettings = false                                     ║
// ║                                                                               ║
// ║   Button(action: {                                                            ║
// ║       showSettings = true                                                     ║
// ║   }) {                                                                         ║
// ║       Image(systemName: "gearshape")                                          ║
// ║   }                                                                            ║
// ║   .sheet(isPresented: $showSettings) {                                        ║
// ║       SettingsView()                                                          ║
// ║   }                                                                            ║
// ╚══════════════════════════════════════════════════════════════════════════════╝
