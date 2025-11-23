# Phase 10: Leaderboards & Social Features - Integration Guide

## Overview
This guide explains how to integrate Phase 10 features with existing systems (GameViewModel, AchievementManager, ChallengeManager, etc.).

## Integration Points

### 1. GameViewModel Integration

Add leaderboard and personal best tracking to `GameViewModel.swift`:

```swift
// At top of file
@StateObject private var leaderboardManager = LeaderboardManager.shared
@StateObject private var progressionManager = ProgressionManager.shared

// After completing a hand
func completeHand() {
    // ... existing hand completion logic ...

    // Update personal bests
    progressionManager.updatePersonalBest(
        category: .winRate,
        score: sessionWinRate * 100
    )

    // Update win streak
    if didWin {
        currentWinStreak += 1
        progressionManager.updatePersonalBest(
            category: .longestWinStreak,
            score: Double(currentWinStreak)
        )
    }
}

// After session end
func endSession() {
    // ... existing session end logic ...

    // Update biggest profit if applicable
    if sessionProfit > 0 {
        progressionManager.profile?.updateBiggestSessionProfit(sessionProfit)
        progressionManager.saveProfile()
    }

    // Offer to share session highlights (if significant)
    if sessionProfit > 500 || sessionWinRate > 0.7 {
        SharingManager.shared.offerShareSessionHighlight(
            profit: sessionProfit,
            winRate: sessionWinRate * 100,
            handsPlayed: handsPlayed
        )
    }
}
```

### 2. AchievementManager Integration

Add social notifications to `AchievementManager.swift`:

```swift
// When unlocking an achievement
func unlockAchievement(_ achievement: Achievement) {
    // ... existing unlock logic ...

    // Notify social notification manager
    SocialNotificationManager.shared.notifyAchievementUnlocked(achievement)

    // Offer to share platinum achievements
    if achievement.tier == .platinum {
        SharingManager.shared.offerShareAchievement(achievement)
    }

    // Update personal best
    if let profile = ProgressionManager.shared.profile {
        ProgressionManager.shared.updatePersonalBest(
            category: .mostAchievements,
            score: Double(profile.achievementsUnlocked)
        )
    }
}
```

### 3. ProgressionManager Integration (Already Done)

The following methods are already added to ProgressionManager:

- `updateDisplayName(_ name: String)`
- `updateIconEmoji(_ emoji: String)`
- `toggleShareAchievements()`
- `toggleShareStats()`
- `toggleAnonymousMode()`
- `updatePersonalBest(category:score:)`
- `updateLoginStreak()`
- `recordDailyChallengeCompletion()`

Additional integration in existing methods:

```swift
// In addExperience method
func addExperience(_ amount: Int, source: String) {
    // ... existing XP logic ...

    // Update total XP personal best
    updatePersonalBest(category: .totalXP, score: Double(profile.totalXPEarned))

    // Check for level up
    if didLevelUp {
        let newLevel = profile.level

        // Notify social notification manager
        SocialNotificationManager.shared.notifyLevelUp(
            newLevel: newLevel,
            newRank: profile.rankTitle
        )

        // Offer to share milestone levels (every 10 levels)
        if newLevel % 10 == 0 {
            SharingManager.shared.offerShareLevelUp(newLevel)
        }

        // Update level personal best
        updatePersonalBest(category: .level, score: Double(newLevel))
    }
}
```

### 4. ChallengeManager Integration

Add to `ChallengeManager.swift`:

```swift
// When completing a challenge
func completeChallenge(_ challenge: Challenge) {
    // ... existing completion logic ...

    // Notify social notification manager
    SocialNotificationManager.shared.notifyChallengeComplete(challenge)

    // Record completion in progression manager
    ProgressionManager.shared.recordDailyChallengeCompletion()

    // Offer to share expert challenges
    if challenge.difficulty == .expert {
        SharingManager.shared.offerShareChallengeCompletion(challenge)
    }
}
```

### 5. App Launch Integration

Add to your App's `init()` or main view's `onAppear`:

```swift
struct BlackjackwhitejackApp: App {
    init() {
        // Update login streak on app launch
        Task { @MainActor in
            ProgressionManager.shared.updateLoginStreak()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .withSocialNotifications() // Add social notification overlay
        }
    }
}
```

### 6. ContentView/Main Menu Integration

Add leaderboards and profile navigation to `ContentView.swift`:

```swift
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                // ... existing menu items ...

                // Leaderboards button
                NavigationLink(destination: LeaderboardsView()) {
                    HStack {
                        Image(systemName: "trophy.fill")
                        Text("Leaderboards")
                    }
                }

                // Player Profile button
                NavigationLink(destination: PlayerProfileView()) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                        Text("Player Profile")
                    }
                }
            }
        }
        .withSocialNotifications() // Add this modifier
    }
}
```

### 7. SettingsView Integration

Add to `SettingsView.swift`:

```swift
// Add navigation links in settings
Section("Profile") {
    NavigationLink(destination: PlayerProfileView()) {
        Label("Player Profile", systemImage: "person.circle.fill")
    }

    NavigationLink(destination: LeaderboardsView()) {
        Label("Leaderboards", systemImage: "trophy.fill")
    }
}

Section("Privacy") {
    if let profile = ProgressionManager.shared.profile {
        Toggle("Share Achievements", isOn: Binding(
            get: { profile.shareAchievements },
            set: { _ in ProgressionManager.shared.toggleShareAchievements() }
        ))

        Toggle("Share Statistics", isOn: Binding(
            get: { profile.shareStats },
            set: { _ in ProgressionManager.shared.toggleShareStats() }
        ))

        Toggle("Anonymous Mode", isOn: Binding(
            get: { profile.isAnonymous },
            set: { _ in ProgressionManager.shared.toggleAnonymousMode() }
        ))
    }
}
```

### 8. Share Sheet Integration

When sharing manager presents share offers, display the ShareView:

```swift
// In your main game view or root view
@StateObject private var sharingManager = SharingManager.shared

var body: some View {
    // ... your content ...
        .sheet(isPresented: $sharingManager.isShowingShareView) {
            if let content = sharingManager.pendingShare {
                ShareView(content: content)
            }
        }
}
```

## Testing Checklist

- [ ] Leaderboards display correctly with AI players
- [ ] Personal bests track and update properly
- [ ] Social notifications appear for achievements/level ups
- [ ] Player profile customisation works (name, emoji)
- [ ] Privacy settings toggle correctly
- [ ] Share functionality generates images correctly
- [ ] Login streak tracks daily logins
- [ ] Personal bests view shows all records
- [ ] Rank improvements trigger notifications
- [ ] Integration with GameViewModel updates leaderboards

## Important Notes

1. **Mock Data**: All leaderboards use procedurally generated AI players. No real online connectivity.

2. **Privacy**: Make clear to users that leaderboards are "simulated" or "local challenges".

3. **Performance**: Leaderboard generation is fast, but refresh is throttled to once per hour.

4. **Persistence**: All personal bests and AI player data are stored in UserDefaults.

5. **Australian English**: Maintain consistency with "leaderboard", "customisation", etc.

## Phase 10 Complete When:

✅ All models created (Leaderboard, LeaderboardEntry, etc.)
✅ LeaderboardManager with mock data generation working
✅ All views created (LeaderboardsView, PersonalBestsView, PlayerProfileView, etc.)
✅ SharingManager with image generation working
✅ SocialNotificationManager with in-game notifications
✅ PlayerProfile model updated with social fields
✅ ProgressionManager extended with Phase 10 methods
✅ Integration points documented
✅ Privacy controls implemented
✅ Testing complete
✅ Committed and pushed to branch

## Next Steps After Phase 10

Phase 10 sets the foundation for future enhancements:
- Real multiplayer features
- Tournament system
- Friend challenges
- Global events
- Seasonal leaderboards

---

**Phase 10 Complete! 🏆🎯**
