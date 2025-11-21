//
//  HapticManager.swift
//  Natural - Modern Blackjack
//
//  Created by Claude Code
//  Part of Phase 5: Settings & Customisation
//

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📳 HAPTIC MANAGER SERVICE                                                  ║
// ║                                                                            ║
// ║ Purpose: Manages all haptic feedback throughout the app                   ║
// ║ Business Context: Haptic feedback provides tactile confirmation of        ║
// ║                   actions and outcomes, enhancing the physical feel of    ║
// ║                   the game. Players can customise which haptics trigger.  ║
// ║                                                                            ║
// ║ Responsibilities:                                                          ║
// ║ • Trigger appropriate haptics for game events                             ║
// ║ • Respect user's haptic settings                                          ║
// ║ • Use correct haptic patterns for different events                        ║
// ║                                                                            ║
// ║ Architecture Pattern: Singleton service                                    ║
// ║ Used By: GameViewModel, GameView, SettingsView                            ║
// ║                                                                            ║
// ║ Related Spec: See "Settings & Customisation" - Haptic Settings            ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import UIKit

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📳 HAPTIC TYPE ENUMERATION                                                 ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

enum HapticType {
    case cardDeal      // Light impact
    case win           // Success notification
    case loss          // Warning notification
    case blackjack     // Heavy success notification
    case buttonTap     // Selection feedback
    case error         // Error notification
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📳 HAPTIC MANAGER CLASS                                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

class HapticManager {

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🔑 SINGLETON PATTERN                                             │
    // └─────────────────────────────────────────────────────────────────┘

    static let shared = HapticManager()

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🔧 INTERNAL PROPERTIES                                           │
    // └─────────────────────────────────────────────────────────────────┘

    /// Reference to settings manager
    private let settingsManager = SettingsManager.shared

    /// Haptic generators
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🏗️ INITIALISER                                                   │
    // └─────────────────────────────────────────────────────────────────┘

    private init() {
        print("📳 HapticManager initialising...")
        prepareGenerators()
        print("📳 HapticManager ready")
    }

    // ╔═══════════════════════════════════════════════════════════════════╗
    // ║ 🔧 SETUP                                                           ║
    // ╚═══════════════════════════════════════════════════════════════════╝

    private func prepareGenerators() {
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        notificationGenerator.prepare()
        selectionGenerator.prepare()
    }

    // ╔═══════════════════════════════════════════════════════════════════╗
    // ║ 📳 HAPTIC PLAYBACK                                                 ║
    // ╚═══════════════════════════════════════════════════════════════════╝

    /// Trigger a haptic feedback
    func trigger(_ hapticType: HapticType) {
        // Check if haptics are enabled
        guard settingsManager.hapticFeedbackEnabled else { return }

        // Check specific haptic settings
        let settings = settingsManager.userSettings
        let shouldTrigger: Bool

        switch hapticType {
        case .cardDeal:
            shouldTrigger = settings.cardDealHaptic
        case .win, .blackjack:
            shouldTrigger = settings.winHaptic
        case .loss, .error:
            shouldTrigger = settings.lossHaptic
        case .buttonTap:
            shouldTrigger = settings.buttonTapHaptic
        }

        guard shouldTrigger else { return }

        // Trigger appropriate haptic
        switch hapticType {
        case .cardDeal:
            impactLight.impactOccurred()
        case .win:
            notificationGenerator.notificationOccurred(.success)
        case .loss:
            notificationGenerator.notificationOccurred(.warning)
        case .blackjack:
            impactHeavy.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.notificationGenerator.notificationOccurred(.success)
            }
        case .buttonTap:
            selectionGenerator.selectionChanged()
        case .error:
            notificationGenerator.notificationOccurred(.error)
        }

        print("📳 Haptic triggered: \(hapticType)")
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📖 USAGE EXAMPLES                                                          ║
// ║                                                                            ║
// ║ Trigger haptic feedback:                                                   ║
// ║   HapticManager.shared.trigger(.cardDeal)                                 ║
// ║   HapticManager.shared.trigger(.win)                                      ║
// ║   HapticManager.shared.trigger(.blackjack)                                ║
// ║                                                                            ║
// ║ In GameViewModel:                                                          ║
// ║   func hit() {                                                             ║
// ║       HapticManager.shared.trigger(.cardDeal)                             ║
// ║       // Deal card logic                                                   ║
// ║   }                                                                        ║
// ║                                                                            ║
// ║   func evaluateResults() {                                                 ║
// ║       if playerWins {                                                      ║
// ║           HapticManager.shared.trigger(.win)                              ║
// ║       } else {                                                             ║
// ║           HapticManager.shared.trigger(.loss)                             ║
// ║       }                                                                    ║
// ║   }                                                                        ║
// ║                                                                            ║
// ║ In SwiftUI Button:                                                         ║
// ║   Button("Hit") {                                                          ║
// ║       HapticManager.shared.trigger(.buttonTap)                            ║
// ║       gameViewModel.hit()                                                  ║
// ║   }                                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
