//
//  PlayerProfile.swift
//  Natural - Modern Blackjack
//
//  Created by Claude Code
//  Part of Phase 8: Achievements & Progression System
//

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 👤 PLAYER PROFILE MODEL                                                    ║
// ║                                                                            ║
// ║ Purpose: Tracks player progression, achievements, and lifetime stats      ║
// ║ Business Context: Players want to see their overall progress and          ║
// ║                   accomplishments across all sessions. The profile        ║
// ║                   provides a persistent record of their journey.          ║
// ║                                                                            ║
// ║ Responsibilities:                                                          ║
// ║ • Track total achievements unlocked                                       ║
// ║ • Store achievement progress dictionary                                   ║
// ║ • Manage player level and XP                                              ║
// ║ • Record lifetime statistics                                              ║
// ║ • Persist player preferences                                              ║
// ║                                                                            ║
// ║ Used By: AchievementManager (loads and updates profile)                   ║
// ║          ProgressionManager (manages XP and levels)                       ║
// ║          AchievementsView (displays profile stats)                        ║
// ║                                                                            ║
// ║ Related Spec: See "Achievements & Progression System" Phase 8             ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Foundation

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 👤 PLAYER PROFILE STRUCTURE                                                ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

struct PlayerProfile: Codable {

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🔑 IDENTIFICATION                                                │
    // └─────────────────────────────────────────────────────────────────┘

    /// Unique player ID
    let playerID: UUID

    /// Profile creation date
    let createdDate: Date

    /// Last updated date
    var lastUpdatedDate: Date

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🏆 ACHIEVEMENT TRACKING                                          │
    // └─────────────────────────────────────────────────────────────────┘

    /// Total achievements unlocked
    var achievementsUnlocked: Int

    /// Achievement progress dictionary (achievementID -> current progress)
    /// Stores progress for all achievements (locked and unlocked)
    var achievementProgress: [String: Int]

    /// Achievement unlock dates (achievementID -> unlock date)
    var achievementUnlockDates: [String: Date]

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 📊 PROGRESSION SYSTEM                                            │
    // └─────────────────────────────────────────────────────────────────┘

    /// Current player level
    var level: Int

    /// Current experience points
    var experiencePoints: Int

    /// Total XP earned all-time (never decreases)
    var totalXPEarned: Int

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 📈 LIFETIME STATISTICS                                           │
    // │                                                                  │
    // │ These stats track cumulative performance across all time        │
    // │ Separate from session-based statistics                          │
    // └─────────────────────────────────────────────────────────────────┘

    /// Total hands played across all sessions
    var lifetimeHandsPlayed: Int

    /// Total hands won
    var lifetimeHandsWon: Int

    /// Total blackjacks hit
    var lifetimeBlackjacks: Int

    /// Total money won (net profit)
    var lifetimeNetProfit: Double

    /// Longest win streak ever achieved
    var longestWinStreak: Int

    /// Total sessions completed
    var totalSessions: Int

    /// Total play time in seconds
    var totalPlayTime: TimeInterval

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🎯 PREFERENCES                                                   │
    // └─────────────────────────────────────────────────────────────────┘

    /// Favourite dealer name
    var favouriteDealer: String?

    /// Achievement notification enabled
    var achievementNotificationsEnabled: Bool

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🏗️ INITIALISER                                                   │
    // └─────────────────────────────────────────────────────────────────┘

    init(
        playerID: UUID = UUID(),
        createdDate: Date = Date(),
        lastUpdatedDate: Date = Date(),
        achievementsUnlocked: Int = 0,
        achievementProgress: [String: Int] = [:],
        achievementUnlockDates: [String: Date] = [:],
        level: Int = 1,
        experiencePoints: Int = 0,
        totalXPEarned: Int = 0,
        lifetimeHandsPlayed: Int = 0,
        lifetimeHandsWon: Int = 0,
        lifetimeBlackjacks: Int = 0,
        lifetimeNetProfit: Double = 0,
        longestWinStreak: Int = 0,
        totalSessions: Int = 0,
        totalPlayTime: TimeInterval = 0,
        favouriteDealer: String? = nil,
        achievementNotificationsEnabled: Bool = true
    ) {
        self.playerID = playerID
        self.createdDate = createdDate
        self.lastUpdatedDate = lastUpdatedDate
        self.achievementsUnlocked = achievementsUnlocked
        self.achievementProgress = achievementProgress
        self.achievementUnlockDates = achievementUnlockDates
        self.level = level
        self.experiencePoints = experiencePoints
        self.totalXPEarned = totalXPEarned
        self.lifetimeHandsPlayed = lifetimeHandsPlayed
        self.lifetimeHandsWon = lifetimeHandsWon
        self.lifetimeBlackjacks = lifetimeBlackjacks
        self.lifetimeNetProfit = lifetimeNetProfit
        self.longestWinStreak = longestWinStreak
        self.totalSessions = totalSessions
        self.totalPlayTime = totalPlayTime
        self.favouriteDealer = favouriteDealer
        self.achievementNotificationsEnabled = achievementNotificationsEnabled
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📊 COMPUTED PROPERTIES                                                     ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

extension PlayerProfile {

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🏆 ACHIEVEMENT STATISTICS                                        │
    // └─────────────────────────────────────────────────────────────────┘

    /// Total number of achievements being tracked
    var totalAchievements: Int {
        // This will be populated by AchievementManager
        return achievementProgress.count
    }

    /// Achievement completion percentage
    var achievementCompletionPercentage: Double {
        guard totalAchievements > 0 else { return 0 }
        return Double(achievementsUnlocked) / Double(totalAchievements) * 100
    }

    /// Formatted achievement completion
    var formattedAchievementCompletion: String {
        return "\(achievementsUnlocked)/\(totalAchievements) (\(String(format: "%.1f", achievementCompletionPercentage))%)"
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 📈 PROGRESSION STATISTICS                                        │
    // └─────────────────────────────────────────────────────────────────┘

    /// Lifetime win rate (0.0 to 1.0)
    var lifetimeWinRate: Double {
        guard lifetimeHandsPlayed > 0 else { return 0 }
        return Double(lifetimeHandsWon) / Double(lifetimeHandsPlayed)
    }

    /// Formatted lifetime win rate
    var formattedLifetimeWinRate: String {
        return String(format: "%.1f%%", lifetimeWinRate * 100)
    }

    /// Formatted lifetime net profit
    var formattedLifetimeNetProfit: String {
        let prefix = lifetimeNetProfit >= 0 ? "+" : ""
        return "\(prefix)$\(String(format: "%.2f", lifetimeNetProfit))"
    }

    /// Formatted total play time
    var formattedTotalPlayTime: String {
        let totalMinutes = Int(totalPlayTime / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    /// Player rank/title based on level
    var rankTitle: String {
        switch level {
        case 1...5:
            return "Novice"
        case 6...10:
            return "Amateur"
        case 11...20:
            return "Intermediate"
        case 21...30:
            return "Advanced"
        case 31...40:
            return "Expert"
        case 41...50:
            return "Master"
        case 51...75:
            return "Grandmaster"
        case 76...99:
            return "Legend"
        case 100...:
            return "Immortal"
        default:
            return "Player"
        }
    }

    /// Rank emoji
    var rankEmoji: String {
        switch level {
        case 1...5:
            return "🌱"
        case 6...10:
            return "🎯"
        case 11...20:
            return "⚔️"
        case 21...30:
            return "🏅"
        case 31...40:
            return "🥇"
        case 41...50:
            return "👑"
        case 51...75:
            return "💎"
        case 76...99:
            return "🌟"
        case 100...:
            return "🔥"
        default:
            return "🎴"
        }
    }

    /// Full rank display (e.g., "🥇 Expert")
    var fullRank: String {
        return "\(rankEmoji) \(rankTitle)"
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ ⏱️ TIME TRACKING                                                  │
    // └─────────────────────────────────────────────────────────────────┘

    /// Days since profile creation
    var daysSinceCreation: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: createdDate, to: Date())
        return components.day ?? 0
    }

    /// Formatted creation date
    var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: createdDate)
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 🛠️ MUTATING METHODS                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

extension PlayerProfile {

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🏆 ACHIEVEMENT METHODS                                           │
    // └─────────────────────────────────────────────────────────────────┘

    /// Update progress for an achievement
    mutating func updateAchievementProgress(achievementID: String, progress: Int) {
        achievementProgress[achievementID] = progress
        lastUpdatedDate = Date()
    }

    /// Mark achievement as unlocked
    mutating func unlockAchievement(achievementID: String, xpReward: Int) {
        guard achievementUnlockDates[achievementID] == nil else {
            // Already unlocked
            return
        }

        achievementUnlockDates[achievementID] = Date()
        achievementsUnlocked += 1

        // Award XP
        addExperience(xpReward)

        lastUpdatedDate = Date()
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 📊 PROGRESSION METHODS                                           │
    // └─────────────────────────────────────────────────────────────────┘

    /// Add experience points
    /// Returns true if player leveled up
    mutating func addExperience(_ amount: Int) -> Bool {
        experiencePoints += amount
        totalXPEarned += amount
        lastUpdatedDate = Date()

        // Check for level up (handled by ProgressionManager)
        return false
    }

    /// Level up the player
    mutating func levelUp() {
        level += 1
        lastUpdatedDate = Date()
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 📈 LIFETIME STATISTICS METHODS                                   │
    // └─────────────────────────────────────────────────────────────────┘

    /// Record a hand result
    mutating func recordHand(won: Bool, wasBlackjack: Bool, netProfit: Double) {
        lifetimeHandsPlayed += 1
        if won {
            lifetimeHandsWon += 1
        }
        if wasBlackjack {
            lifetimeBlackjacks += 1
        }
        lifetimeNetProfit += netProfit
        lastUpdatedDate = Date()
    }

    /// Update longest win streak if current streak is higher
    mutating func updateLongestStreak(_ currentStreak: Int) {
        if currentStreak > longestWinStreak {
            longestWinStreak = currentStreak
            lastUpdatedDate = Date()
        }
    }

    /// Record session completion
    mutating func recordSession(duration: TimeInterval) {
        totalSessions += 1
        totalPlayTime += duration
        lastUpdatedDate = Date()
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🎯 PREFERENCE METHODS                                            │
    // └─────────────────────────────────────────────────────────────────┘

    /// Set favourite dealer
    mutating func setFavouriteDealer(_ dealerName: String) {
        favouriteDealer = dealerName
        lastUpdatedDate = Date()
    }

    /// Toggle achievement notifications
    mutating func toggleAchievementNotifications() {
        achievementNotificationsEnabled.toggle()
        lastUpdatedDate = Date()
    }

    // ┌─────────────────────────────────────────────────────────────────┐
    // │ 🔄 RESET METHODS                                                 │
    // └─────────────────────────────────────────────────────────────────┘

    /// Reset all progress (for testing/debugging)
    mutating func resetProgress() {
        achievementsUnlocked = 0
        achievementProgress = [:]
        achievementUnlockDates = [:]
        level = 1
        experiencePoints = 0
        totalXPEarned = 0
        lifetimeHandsPlayed = 0
        lifetimeHandsWon = 0
        lifetimeBlackjacks = 0
        lifetimeNetProfit = 0
        longestWinStreak = 0
        totalSessions = 0
        totalPlayTime = 0
        lastUpdatedDate = Date()
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📖 USAGE EXAMPLES                                                          ║
// ║                                                                            ║
// ║ Create a new profile:                                                      ║
// ║   var profile = PlayerProfile()                                           ║
// ║                                                                            ║
// ║ Update achievement progress:                                               ║
// ║   profile.updateAchievementProgress(                                      ║
// ║       achievementID: "first_hand",                                        ║
// ║       progress: 1                                                         ║
// ║   )                                                                        ║
// ║                                                                            ║
// ║ Unlock achievement:                                                        ║
// ║   profile.unlockAchievement(                                              ║
// ║       achievementID: "first_hand",                                        ║
// ║       xpReward: 100                                                       ║
// ║   )                                                                        ║
// ║                                                                            ║
// ║ Add experience:                                                            ║
// ║   if profile.addExperience(50) {                                          ║
// ║       print("Level up!")                                                  ║
// ║   }                                                                        ║
// ║                                                                            ║
// ║ Display stats:                                                             ║
// ║   Text("Level: \(profile.level) - \(profile.fullRank)")                  ║
// ║   Text("Achievements: \(profile.formattedAchievementCompletion)")        ║
// ║   Text("Win Rate: \(profile.formattedLifetimeWinRate)")                  ║
// ║   Text("Total Profit: \(profile.formattedLifetimeNetProfit)")            ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
