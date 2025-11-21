//
//  SettingsView.swift
//  Natural - Modern Blackjack
//
//  Created by Claude Code
//  Part of Phase 5: Settings & Customisation
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                audioSection
                visualSection
                gameplaySection
                hapticSection
                actionsSection
            }
            .navigationTitle("⚙️ Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .alert("Reset Settings?", isPresented: $viewModel.showResetConfirmation) {
                Button("Reset", role: .destructive) {
                    viewModel.confirmReset()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will reset all settings to factory defaults.")
            }
        }
    }

    // Audio Section
    private var audioSection: some View {
        Section {
            Toggle("🔊 Sound Effects", isOn: Binding(
                get: { viewModel.settingsManager.userSettings.soundEffectsEnabled },
                set: { viewModel.settingsManager.userSettings.soundEffectsEnabled = $0 }
            ))

            if viewModel.settingsManager.userSettings.soundEffectsEnabled {
                VStack(alignment: .leading) {
                    Text("Volume: \(viewModel.soundVolumeDisplay)")
                        .font(.caption)
                    Slider(value: Binding(
                        get: { viewModel.settingsManager.userSettings.soundVolume },
                        set: { viewModel.settingsManager.userSettings.soundVolume = $0 }
                    ), in: 0...1)
                }

                Toggle("Card Deal Sound", isOn: Binding(
                    get: { viewModel.settingsManager.userSettings.cardDealSoundEnabled },
                    set: { viewModel.settingsManager.userSettings.cardDealSoundEnabled = $0 }
                ))

                Toggle("Win/Loss Sound", isOn: Binding(
                    get: { viewModel.settingsManager.userSettings.winLossSoundEnabled },
                    set: { viewModel.settingsManager.userSettings.winLossSoundEnabled = $0 }
                ))
            }
        } header: {
            Text("Audio")
        }
    }

    // Visual Section
    private var visualSection: some View {
        Section {
            Picker("Table Felt Colour", selection: Binding(
                get: { viewModel.settingsManager.userSettings.tableFeltColour },
                set: { viewModel.settingsManager.userSettings.tableFeltColour = $0 }
            )) {
                ForEach(TableFeltColour.allCases) { colour in
                    HStack {
                        Text(colour.icon)
                        Text(colour.displayName)
                    }
                    .tag(colour)
                }
            }

            Picker("Card Back Design", selection: Binding(
                get: { viewModel.settingsManager.userSettings.cardBackDesign },
                set: { viewModel.settingsManager.userSettings.cardBackDesign = $0 }
            )) {
                ForEach(CardBackDesign.allCases) { design in
                    HStack {
                        Text(design.icon)
                        Text(design.displayName)
                    }
                    .tag(design)
                }
            }

            Picker("Animation Speed", selection: Binding(
                get: { viewModel.settingsManager.userSettings.animationSpeed },
                set: { viewModel.settingsManager.userSettings.animationSpeed = $0 }
            )) {
                ForEach(AnimationSpeed.allCases) { speed in
                    HStack {
                        Text(speed.icon)
                        Text(speed.rawValue)
                    }
                    .tag(speed)
                }
            }
            .pickerStyle(.segmented)

            Toggle("Show Hand Total", isOn: Binding(
                get: { viewModel.settingsManager.userSettings.showHandTotal },
                set: { viewModel.settingsManager.userSettings.showHandTotal = $0 }
            ))
        } header: {
            Text("Visual")
        }
    }

    // Gameplay Section
    private var gameplaySection: some View {
        Section {
            Toggle("Auto-Stand on 21", isOn: Binding(
                get: { viewModel.settingsManager.userSettings.autoStandOn21 },
                set: { viewModel.settingsManager.userSettings.autoStandOn21 = $0 }
            ))

            Toggle("Confirm Surrender", isOn: Binding(
                get: { viewModel.settingsManager.userSettings.confirmSurrender },
                set: { viewModel.settingsManager.userSettings.confirmSurrender = $0 }
            ))

            Picker("Default Min Bet", selection: Binding(
                get: { viewModel.settingsManager.userSettings.defaultMinimumBet },
                set: { viewModel.settingsManager.userSettings.defaultMinimumBet = $0 }
            )) {
                Text("$5").tag(5.0)
                Text("$10").tag(10.0)
                Text("$25").tag(25.0)
                Text("$50").tag(50.0)
                Text("$100").tag(100.0)
            }
        } header: {
            Text("Gameplay")
        }
    }

    // Haptic Section
    private var hapticSection: some View {
        Section {
            Toggle("📳 Haptic Feedback", isOn: Binding(
                get: { viewModel.settingsManager.userSettings.hapticFeedbackEnabled },
                set: { viewModel.settingsManager.userSettings.hapticFeedbackEnabled = $0 }
            ))

            if viewModel.settingsManager.userSettings.hapticFeedbackEnabled {
                Toggle("Card Deal Haptic", isOn: Binding(
                    get: { viewModel.settingsManager.userSettings.cardDealHaptic },
                    set: { viewModel.settingsManager.userSettings.cardDealHaptic = $0 }
                ))

                Toggle("Win Haptic", isOn: Binding(
                    get: { viewModel.settingsManager.userSettings.winHaptic },
                    set: { viewModel.settingsManager.userSettings.winHaptic = $0 }
                ))

                Toggle("Loss Haptic", isOn: Binding(
                    get: { viewModel.settingsManager.userSettings.lossHaptic },
                    set: { viewModel.settingsManager.userSettings.lossHaptic = $0 }
                ))
            }
        } header: {
            Text("Haptic Feedback")
        }
    }

    // Actions Section
    private var actionsSection: some View {
        Section {
            Button(role: .destructive) {
                viewModel.requestReset()
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset to Defaults")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
