//
//  UserSettings.swift
//  Natural - Modern Blackjack
//
//  Created by Claude Code
//  Part of Phase 5: Settings & Customisation
//

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ ⚙️ USER SETTINGS MODEL                                                     ║
// ║                                                                            ║
// ║ Purpose: Single source of truth for all user preferences and settings     ║
// ║ Business Context: Players want to customise their experience. Settings    ║
// ║                   must persist across app launches and apply immediately. ║
// ║                   This model encapsulates all customisable options.       ║
// ║                                                                            ║
// ║ Responsibilities:                                                          ║
// ║ • Store all user preferences (audio, visual, gameplay, haptics)           ║
// ║ • Provide sensible defaults for first-time users                          ║
// ║ • Support Codable for easy persistence                                    ║
// ║ • Validate settings values                                                ║
// ║                                                                            ║
// ║ Used By: SettingsManager (persistence), SettingsViewModel (UI binding)    ║
// ║          GameView, GameViewModel (apply settings)                         ║
// ║                                                                            ║
// ║ Related Spec: See "Settings & Customisation" section                      ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Foundation

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ ⚡ ANIMATION SPEED ENUM                                                     ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

enum AnimationSpeed: String, Codable, CaseIterable, Identifiable {
    case slow    = "Slow"
    case normal  = "Normal"
    case fast    = "Fast"
    case instant = "Instant"

    var id: String { rawValue }

    /// Animation duration in seconds
    var duration: Double {
        switch self {
        case .slow:    return 2.0
        case .normal:  return 1.0
        case .fast:    return 0.5
        case .instant: return 0.1
        }
    }

    /// Display description
    var description: String {
        switch self {
        case .slow:    return "Slow (2.0s) - For beginners"
        case .normal:  return "Normal (1.0s) - Recommended"
        case .fast:    return "Fast (0.5s) - Experienced players"
        case .instant: return "Instant (0.1s) - Speed demons"
        }
    }

    var icon: String {
        switch self {
        case .slow:    return "🐢"
        case .normal:  return "⚡"
        case .fast:    return "🚀"
        case .instant: return "⚡⚡"
        }
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ ⚙️ USER SETTINGS STRUCTURE                                                 ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

struct UserSettings: Codable, Equatable {

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🔊 AUDIO SETTINGS                                                │
    // └─────────────────────────────────────────────────────────────────┘

    /// Master toggle for all sound effects
    var soundEffectsEnabled: Bool = true

    /// Overall sound volume (0.0 to 1.0)
    var soundVolume: Double = 0.7

    /// Play sound when dealing cards
    var cardDealSoundEnabled: Bool = true

    /// Play sound on win/loss
    var winLossSoundEnabled: Bool = true

    /// Background music enabled
    var backgroundMusicEnabled: Bool = false

    /// Background music volume (0.0 to 1.0)
    var musicVolume: Double = 0.3

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🎨 VISUAL SETTINGS                                               │
    // └─────────────────────────────────────────────────────────────────┘

    /// Table felt background colour
    var tableFeltColour: TableFeltColour = .classicGreen

    /// Card back design for face-down cards
    var cardBackDesign: CardBackDesign = .classicRed

    /// Animation speed for card dealing and transitions
    var animationSpeed: AnimationSpeed = .normal

    /// Show numeric hand total above cards
    var showHandTotal: Bool = true

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🎮 GAMEPLAY SETTINGS                                             │
    // └─────────────────────────────────────────────────────────────────┘

    /// Default minimum bet when starting new session
    var defaultMinimumBet: Double = 10.0

    /// Automatically stand when hand reaches 21
    var autoStandOn21: Bool = false

    /// Show dealer bust probability (advanced feature)
    var showDealerProbabilities: Bool = false

    /// Require confirmation before surrendering
    var confirmSurrender: Bool = true

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 📳 HAPTIC FEEDBACK SETTINGS                                      │
    // └─────────────────────────────────────────────────────────────────┘

    /// Master toggle for all haptic feedback
    var hapticFeedbackEnabled: Bool = true

    /// Light haptic on each card deal
    var cardDealHaptic: Bool = true

    /// Success haptic on win
    var winHaptic: Bool = true

    /// Warning haptic on loss/bust
    var lossHaptic: Bool = true

    /// Selection haptic on button taps
    var buttonTapHaptic: Bool = true

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🏗️ INITIALISER                                                   │
    // │                                                                  │
    // │ Default values are set in property declarations above           │
    // │ This initialiser allows for custom values when needed           │
    // └─────────────────────────────────────────────────────────────────┘

    init(
        soundEffectsEnabled: Bool = true,
        soundVolume: Double = 0.7,
        cardDealSoundEnabled: Bool = true,
        winLossSoundEnabled: Bool = true,
        backgroundMusicEnabled: Bool = false,
        musicVolume: Double = 0.3,
        tableFeltColour: TableFeltColour = .classicGreen,
        cardBackDesign: CardBackDesign = .classicRed,
        animationSpeed: AnimationSpeed = .normal,
        showHandTotal: Bool = true,
        defaultMinimumBet: Double = 10.0,
        autoStandOn21: Bool = false,
        showDealerProbabilities: Bool = false,
        confirmSurrender: Bool = true,
        hapticFeedbackEnabled: Bool = true,
        cardDealHaptic: Bool = true,
        winHaptic: Bool = true,
        lossHaptic: Bool = true,
        buttonTapHaptic: Bool = true
    ) {
        self.soundEffectsEnabled = soundEffectsEnabled
        self.soundVolume = soundVolume
        self.cardDealSoundEnabled = cardDealSoundEnabled
        self.winLossSoundEnabled = winLossSoundEnabled
        self.backgroundMusicEnabled = backgroundMusicEnabled
        self.musicVolume = musicVolume
        self.tableFeltColour = tableFeltColour
        self.cardBackDesign = cardBackDesign
        self.animationSpeed = animationSpeed
        self.showHandTotal = showHandTotal
        self.defaultMinimumBet = defaultMinimumBet
        self.autoStandOn21 = autoStandOn21
        self.showDealerProbabilities = showDealerProbabilities
        self.confirmSurrender = confirmSurrender
        self.hapticFeedbackEnabled = hapticFeedbackEnabled
        self.cardDealHaptic = cardDealHaptic
        self.winHaptic = winHaptic
        self.lossHaptic = lossHaptic
        self.buttonTapHaptic = buttonTapHaptic
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ ✅ VALIDATION                                                    │
    // │                                                                  │
    // │ Ensures all settings values are within valid ranges             │
    // └─────────────────────────────────────────────────────────────────┘

    /// Validate and clamp settings values to acceptable ranges
    mutating func validate() {
        // Clamp volumes to 0.0-1.0
        soundVolume = max(0.0, min(1.0, soundVolume))
        musicVolume = max(0.0, min(1.0, musicVolume))

        // Clamp minimum bet to reasonable range
        defaultMinimumBet = max(1.0, min(1000.0, defaultMinimumBet))
    }

    /// Check if settings are valid
    var isValid: Bool {
        return soundVolume >= 0.0 && soundVolume <= 1.0 &&
               musicVolume >= 0.0 && musicVolume <= 1.0 &&
               defaultMinimumBet >= 1.0 && defaultMinimumBet <= 1000.0
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 🛠️ EXTENSIONS                                                              ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

extension UserSettings {

    /// Create default settings (factory method)
    static var `default`: UserSettings {
        return UserSettings()
    }

    /// Reset to factory defaults
    mutating func resetToDefaults() {
        self = .default
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📖 USAGE EXAMPLES                                                          ║
// ║                                                                            ║
// ║ Create with defaults:                                                      ║
// ║   var settings = UserSettings()                                            ║
// ║   print(settings.tableFeltColour) // .classicGreen                        ║
// ║                                                                            ║
// ║ Create with custom values:                                                 ║
// ║   var settings = UserSettings(                                             ║
// ║       soundVolume: 0.5,                                                   ║
// ║       tableFeltColour: .royalBlue,                                        ║
// ║       animationSpeed: .fast                                               ║
// ║   )                                                                        ║
// ║                                                                            ║
// ║ Modify settings:                                                           ║
// ║   settings.autoStandOn21 = true                                           ║
// ║   settings.validate() // Ensure values are in range                       ║
// ║                                                                            ║
// ║ Reset to defaults:                                                         ║
// ║   settings.resetToDefaults()                                              ║
// ║                                                                            ║
// ║ Persistence:                                                               ║
// ║   let data = try JSONEncoder().encode(settings)                           ║
// ║   UserDefaults.standard.set(data, forKey: "userSettings")                ║
// ║                                                                            ║
// ║   if let data = UserDefaults.standard.data(forKey: "userSettings") {     ║
// ║       let settings = try JSONDecoder().decode(UserSettings.self, from: data) ║
// ║   }                                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
