//
//  AudioManager.swift
//  Natural - Modern Blackjack
//
//  Created by Claude Code
//  Part of Phase 5: Settings & Customisation
//

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 🔊 AUDIO MANAGER SERVICE                                                   ║
// ║                                                                            ║
// ║ Purpose: Manages all sound effects and audio playback                     ║
// ║ Business Context: Sound effects enhance the gaming experience, providing  ║
// ║                   audio feedback for actions and outcomes. Players can    ║
// ║                   customise which sounds play and at what volume.         ║
// ║                                                                            ║
// ║ Responsibilities:                                                          ║
// ║ • Play sound effects based on game events                                 ║
// ║ • Respect user's sound settings                                           ║
// ║ • Manage audio session and interruptions                                  ║
// ║ • Preload sounds for smooth playback                                      ║
// ║                                                                            ║
// ║ Architecture Pattern: Singleton service                                    ║
// ║ Used By: GameViewModel, GameView (for game events)                        ║
// ║                                                                            ║
// ║ Related Spec: See "Settings & Customisation" - Audio Settings             ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import AVFoundation
import Foundation

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 🎵 SOUND TYPE ENUMERATION                                                  ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

enum SoundType: String {
    case cardDeal    = "card_deal"
    case cardFlip    = "card_flip"
    case chipPlace   = "chip_place"
    case win         = "win"
    case loss        = "loss"
    case blackjack   = "blackjack"
    case shuffle     = "shuffle"
    case buttonTap   = "button_tap"

    /// Filename for this sound (would be actual audio files in production)
    var filename: String {
        return rawValue
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 🔊 AUDIO MANAGER CLASS                                                     ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

class AudioManager {

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🔑 SINGLETON PATTERN                                             │
    // └─────────────────────────────────────────────────────────────────┘

    static let shared = AudioManager()

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🔧 INTERNAL PROPERTIES                                           │
    // └─────────────────────────────────────────────────────────────────┘

    /// Reference to settings manager
    private let settingsManager = SettingsManager.shared

    /// Dictionary of preloaded audio players
    private var audioPlayers: [SoundType: AVAudioPlayer] = [:]

    /// Background music player
    private var musicPlayer: AVAudioPlayer?

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🏗️ INITIALISER                                                   │
    // └─────────────────────────────────────────────────────────────────┘

    private init() {
        print("🔊 AudioManager initialising...")
        setupAudioSession()
        // Note: In production, would preload actual audio files here
        print("🔊 AudioManager ready")
    }

    // ╔═══════════════════════════════════════════════════════════════════╗
    // ║ 🔧 SETUP                                                           ║
    // ╚═══════════════════════════════════════════════════════════════════╝

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            print("✅ Audio session configured")
        } catch {
            print("❌ Failed to setup audio session: \(error.localizedDescription)")
        }
    }

    // ╔═══════════════════════════════════════════════════════════════════╗
    // ║ 🔊 SOUND PLAYBACK                                                  ║
    // ╚═══════════════════════════════════════════════════════════════════╝

    /// Play a sound effect
    func playSound(_ soundType: SoundType) {
        // Check if sound effects are enabled
        guard settingsManager.soundEffectsEnabled else { return }

        // Check specific sound settings
        switch soundType {
        case .cardDeal, .cardFlip, .shuffle:
            guard settingsManager.userSettings.cardDealSoundEnabled else { return }
        case .win, .loss, .blackjack:
            guard settingsManager.userSettings.winLossSoundEnabled else { return }
        case .chipPlace, .buttonTap:
            break // Always play if sound effects enabled
        }

        // In production, would actually play the sound file here
        print("🔊 Playing sound: \(soundType.rawValue) at volume \(settingsManager.userSettings.soundVolume)")
    }

    /// Play background music
    func playBackgroundMusic() {
        guard settingsManager.userSettings.backgroundMusicEnabled else { return }
        // In production, would start background music loop
        print("🎵 Background music started at volume \(settingsManager.userSettings.musicVolume)")
    }

    /// Stop background music
    func stopBackgroundMusic() {
        musicPlayer?.stop()
        print("🎵 Background music stopped")
    }

    /// Update volume for all sounds
    func updateVolume() {
        let volume = Float(settingsManager.userSettings.soundVolume)
        audioPlayers.values.forEach { $0.volume = volume }
        print("🔊 Sound volume updated to \(volume)")
    }

    /// Update music volume
    func updateMusicVolume() {
        let volume = Float(settingsManager.userSettings.musicVolume)
        musicPlayer?.volume = volume
        print("🎵 Music volume updated to \(volume)")
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📖 USAGE EXAMPLES                                                          ║
// ║                                                                            ║
// ║ Play sound effect:                                                         ║
// ║   AudioManager.shared.playSound(.cardDeal)                                ║
// ║   AudioManager.shared.playSound(.win)                                     ║
// ║                                                                            ║
// ║ Control music:                                                             ║
// ║   AudioManager.shared.playBackgroundMusic()                               ║
// ║   AudioManager.shared.stopBackgroundMusic()                               ║
// ║                                                                            ║
// ║ In GameViewModel:                                                          ║
// ║   func hit() {                                                             ║
// ║       AudioManager.shared.playSound(.cardDeal)                            ║
// ║       // Deal card logic                                                   ║
// ║   }                                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
