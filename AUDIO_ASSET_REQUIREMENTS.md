# Audio Asset Requirements - Natural Blackjack

## 📊 Overview

Phase 7 implementation is complete, but **14 audio files need to be added** to enable full sound effects functionality. The AudioManager is designed to gracefully handle missing files (no crashes), but adding these files will complete the premium audio experience.

---

## 🎵 Required Sound Effect Files

All files should be in **MP3 format** with the following specifications:
- **Bitrate:** 128kbps (good balance of quality and file size)
- **Sample Rate:** 44.1kHz
- **Channels:** Stereo
- **Total Size:** Approximately 1-2MB for all files

---

## 📋 Complete File List

### 1. Card Sounds (3 files)

#### `card_shuffle.mp3`
- **Duration:** 2-3 seconds
- **Description:** Full deck shuffling sound
- **Vibe:** Professional casino atmosphere, cards riffling together
- **Volume:** Moderate (0.7 default in SoundEffect enum)
- **When Used:** Before dealing when deck needs reshuffle

#### `card_deal.mp3`
- **Duration:** 0.2 seconds
- **Description:** Quick card sliding/whoosh sound
- **Vibe:** Crisp, clean card movement
- **Volume:** Moderate (0.8 default)
- **When Used:** Each time a card is dealt to player or dealer

#### `card_flip.mp3`
- **Duration:** 0.2 seconds
- **Description:** Card flipping over (snap sound)
- **Vibe:** Sharp, clean flip
- **Volume:** Moderate (0.8 default)
- **When Used:** Dealer revealing hole card

---

### 2. Chip/Betting Sounds (2 files)

#### `chip_clink.mp3`
- **Duration:** 0.3 seconds
- **Description:** Ceramic chips clinking together
- **Vibe:** Satisfying casino chip sound
- **Volume:** Moderate (0.7 default)
- **When Used:** Placing bets, adjusting bet amounts

#### `chip_slide.mp3`
- **Duration:** 0.3 seconds
- **Description:** Chips sliding across felt
- **Vibe:** Smooth sliding on casino felt
- **Volume:** Moderate (0.7 default)
- **When Used:** Collecting wins, paying out, dealer collecting losses

---

### 3. Result Sounds (5 files)

#### `win.mp3`
- **Duration:** 1.0 second
- **Description:** Celebratory chime (positive, uplifting)
- **Vibe:** Winner! Satisfying reward sound
- **Volume:** Moderate-High (0.9 default)
- **When Used:** Player wins hand (including dealer bust)

#### `loss.mp3`
- **Duration:** 0.5 seconds
- **Description:** Subtle negative tone (not harsh)
- **Vibe:** Gentle disappointment, not devastating
- **Volume:** Low (0.6 default)
- **When Used:** Player loses hand

#### `blackjack.mp3`
- **Duration:** 1.5 seconds
- **Description:** **SPECIAL PREMIUM SOUND** - distinctive, exciting
- **Vibe:** Jackpot feel, special celebration
- **Volume:** High (1.0 default)
- **When Used:** Player gets natural blackjack (21 with first two cards)
- **Note:** This should be the most exciting sound in the app!

#### `push.mp3`
- **Duration:** 0.5 seconds
- **Description:** Neutral tone (neither positive nor negative)
- **Vibe:** "Meh, break even"
- **Volume:** Low (0.6 default)
- **When Used:** Player and dealer tie (push)

#### `bust.mp3`
- **Duration:** 0.5 seconds
- **Description:** Alert/negative tone
- **Vibe:** "Oops, over 21"
- **Volume:** Moderate (0.7 default)
- **When Used:** Player busts (goes over 21)

---

### 4. Interface Sounds (4 files)

#### `button_tap.mp3`
- **Duration:** 0.1 seconds
- **Description:** Subtle click/tap sound
- **Vibe:** Clean, minimal UI feedback
- **Volume:** Low (0.5 default)
- **When Used:** All button taps (Hit, Stand, Double, Split, etc.)

#### `dealer_select.mp3`
- **Duration:** 0.3 seconds
- **Description:** Card slide or selection sound
- **Vibe:** Smooth selection confirmation
- **Volume:** Moderate (0.7 default)
- **When Used:** Selecting/switching dealers

#### `confirm.mp3`
- **Duration:** 0.3 seconds
- **Description:** Positive confirmation tone
- **Vibe:** "Yes, confirmed"
- **Volume:** Moderate (0.8 default)
- **When Used:** Confirming bet placement, important actions

#### `warning.mp3`
- **Duration:** 0.4 seconds
- **Description:** Alert/attention sound (not harsh)
- **Vibe:** "Hey, pay attention to this"
- **Volume:** Moderate (0.7 default)
- **When Used:** Bankruptcy warning, invalid action attempts

---

## 📁 Adding Files to Xcode Project

### Step 1: Create Sounds Folder

In Xcode, create a new group called `Sounds` at the project root:
```
Blackjackwhitejack/
├── Sounds/           ← Create this folder
│   ├── card_shuffle.mp3
│   ├── card_deal.mp3
│   ├── card_flip.mp3
│   └── ... (all 14 files)
```

### Step 2: Add Files to Project

1. Drag all 14 MP3 files into the `Sounds/` group in Xcode
2. In the dialog that appears:
   - ✅ Check "Copy items if needed"
   - ✅ Ensure "Blackjackwhitejack" is selected under "Add to targets"
3. Click "Finish"

### Step 3: Verify Target Membership

For each file, check in File Inspector:
- ✅ Target Membership: Blackjackwhitejack (checked)

### Step 4: Test Audio System

Run the app and test each sound via Settings → Audio Settings. The AudioManager will automatically load files by name.

---

## 🎨 Royalty-Free Sound Sources

### Recommended Sources

#### 1. **Freesound.org** (Free, Attribution)
- Community-uploaded sounds
- Search for: "casino chips", "card shuffle", "card flip", "win chime"
- License: Creative Commons (check individual files)
- Quality: Variable (preview before downloading)

#### 2. **Zapsplat.com** (Free with Attribution)
- Professional quality sound effects
- Search categories: Casino, Cards, Chips, UI Sounds
- License: Free with attribution
- Quality: High

#### 3. **Mixkit.co** (Free, No Attribution Required)
- Curated sound effects library
- Search: Casino sounds, UI sounds, Game sounds
- License: Free for commercial use
- Quality: Very High

#### 4. **YouTube Audio Library** (Free, Royalty-Free)
- Google's audio library
- Filter by sound effects
- License: Royalty-free
- Quality: High

#### 5. **Epidemic Sound** (Paid Subscription)
- Professional casino sound packs
- Commercial license included
- Quality: Premium

---

## 🎛️ Sound Design Guidelines

### Volume Balancing

The default volumes in `SoundEffect.swift` have been carefully calibrated:

- **Blackjack:** 1.0 (loudest - it's special!)
- **Win:** 0.9 (celebratory)
- **Card Deal/Flip:** 0.8 (prominent but not overwhelming)
- **Confirm:** 0.8 (important actions)
- **Chip/Bust/Dealer/Warning:** 0.7 (moderate)
- **Loss/Push:** 0.6 (subtle)
- **Button Tap:** 0.5 (background UI feedback)

These can be adjusted by the user via the Master Volume slider (0-100%) in Settings.

### Sound Characteristics

**DO:**
- ✅ Use clean, professional casino sounds
- ✅ Keep files under 200KB each (except shuffle)
- ✅ Normalize audio levels across all files
- ✅ Use warm, inviting tones for wins
- ✅ Make blackjack sound SPECIAL and exciting

**DON'T:**
- ❌ Use harsh, jarring sounds
- ❌ Use copyrighted casino sounds without license
- ❌ Use sounds with background noise
- ❌ Make loss/bust sounds overly negative (keep it classy)
- ❌ Use sounds longer than specified durations

---

## 🧪 Testing Checklist

After adding audio files, test:

- [ ] Card shuffle plays when deck is reshuffled
- [ ] Card deal plays for each dealt card
- [ ] Card flip plays when dealer reveals hole card
- [ ] Chip clink plays when placing/adjusting bets
- [ ] Chip slide plays when collecting wins/losses
- [ ] Win sound plays on player win
- [ ] Loss sound plays on player loss
- [ ] **Blackjack sound plays on natural blackjack (test this!)** 🎰
- [ ] Push sound plays on tie
- [ ] Bust sound plays when going over 21
- [ ] Button tap plays on all buttons (Hit, Stand, etc.)
- [ ] Dealer select plays when changing dealers
- [ ] Confirm plays on bet confirmation
- [ ] Warning plays on invalid actions
- [ ] Master volume slider affects all sounds
- [ ] Mute toggle silences all sounds
- [ ] No crashes if audio files are missing (graceful fallback)

---

## 📊 Current Status

| Status | Count | Percentage |
|--------|-------|------------|
| ✅ AudioManager Implementation | 1 | 100% |
| ✅ SoundEffect Enum Defined | 14 | 100% |
| ✅ Audio Integration in GameViewModel | ✓ | 100% |
| ✅ Settings UI for Audio Control | ✓ | 100% |
| ⏳ **Audio Files Added to Project** | **0/14** | **0%** |

**To complete Phase 7 audio system: Add 14 MP3 files to `Blackjackwhitejack/Sounds/` folder.**

---

## 🔗 Integration Details

### How AudioManager Finds Files

The `AudioManager.swift` loads sounds using this pattern:

```swift
if let soundURL = Bundle.main.url(forResource: "card_deal", withExtension: "mp3") {
    let player = try AVAudioPlayer(contentsOf: soundURL)
    player.prepareToPlay()
    soundPlayers[.cardDeal] = player
}
```

**File name must exactly match:**
- `card_shuffle.mp3`
- `card_deal.mp3`
- `card_flip.mp3`
- etc.

**Case sensitive!** Use lowercase with underscores.

---

## 🎯 Next Steps

1. **Source or create 14 sound files** (use recommended sources above)
2. **Add files to Xcode project** (follow steps in "Adding Files" section)
3. **Test all sounds** (use testing checklist above)
4. **Adjust volumes if needed** (modify `SoundEffect.swift` default volumes)
5. **🎉 Enjoy premium audio experience!**

---

## 💡 Pro Tips

### Quick Testing

Add test buttons in Settings (optional):
```swift
Button("Test All Sounds") {
    SoundEffect.allCases.forEach { effect in
        audioManager.playSoundEffect(effect)
        Thread.sleep(forTimeInterval: 0.5) // Stagger playback
    }
}
```

### Custom Sounds

Want to replace a sound later?
1. Keep the same filename (e.g., `blackjack.mp3`)
2. Replace the file in Xcode
3. Clean build folder (⇧⌘K)
4. Rebuild and run

---

**Phase 7 Audio Status:** Waiting for sound files ⏳
**Everything else:** ✅ Complete and ready!
