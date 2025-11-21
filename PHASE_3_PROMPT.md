# 🎰 Phase 3: Dealer Personalities & Rule Variations - Development Prompt

## 📋 Project Context

You're continuing development on "Natural" - Modern Blackjack, a clean, minimal iOS blackjack app. This is Phase 3 of an 8-phase project following a detailed specification.

**Repository**: BlackJackWhiteJack
**Current Branch**: `claude/core-gameplay-mechanics-01ReCmfQzM6mcC21tKhMUzQu`
**Specification**: `blackjack_app_spec.md` (complete project requirements)
**Phase Timeline**: Week 5-6 of 13-week development plan

---

## ✅ What's Already Built

### Phase 1 Complete (Foundation)
- ✅ Complete card system (Card, Deck, Hand models)
- ✅ DeckManager with multi-deck shoe support
- ✅ Hand evaluation with soft/hard ace handling
- ✅ Beautiful card rendering with CardView
- ✅ Dark theme colour palette
- ✅ Comprehensive unit tests (20+ tests)

### Phase 2 Complete (Core Gameplay)
- ✅ GameViewModel with full state machine
- ✅ Complete betting system with slider and presets
- ✅ All player actions (Hit, Stand, Double, Split, Surrender)
- ✅ Dealer AI (hits on 16, stands on 17)
- ✅ Accurate payout calculations (Blackjack 3:2, Win 1:1, Push)
- ✅ Multi-hand support (splits up to 4 hands)
- ✅ Bankruptcy handling with reset
- ✅ State-driven UI with dynamic action buttons
- ✅ Full playable game loop

**Current Status**: The game is fully playable but uses default rules (6-deck shoe, dealer stands on soft 17, standard blackjack rules). All players get the same experience.

---

## 🎯 Your Mission: Phase 3 - Dealer Personalities (Week 5-6)

**Goal**: Transform the game from a single rule set to 6 unique dealer personalities, each with distinct rules, visual identity, and character. This makes rule selection intuitive and engaging rather than navigating complex settings menus.

**The Big Idea**: Instead of asking "Do you want the dealer to hit soft 17?", we ask "Do you want to play against Ruby (classic Vegas) or Shark (high roller)?" Much more fun and memorable!

By the end of Phase 3, a user should be able to:
- Choose from 6 distinct dealer personalities
- See each dealer's avatar and tagline
- Understand the rules through the dealer's personality
- Switch dealers mid-session
- Experience different house edges and strategies
- See dealer-specific UI theming (accent colours)

---

## 👥 The Six Dealer Personalities

### 1. **Ruby** - The Vegas Classic ♦️
**Personality**: Professional, by-the-book, classic Vegas energy
**Theme Colour**: `#FF3B30` (red)
**Tagline**: "Let's keep it traditional"

**Rules**:
- 6 decks
- Dealer stands on soft 17 ✅
- Double on any two cards ✅
- Double after split allowed ✅
- Split up to 3 times (4 hands total) ✅
- Aces can be split once, one card each 🆕
- No surrender ✅
- Blackjack pays 3:2 ✅
- **House edge**: ~0.55%

**Character Notes**: Ruby is the default dealer. She's professional, reliable, and fair. Think classic Las Vegas - glamorous but serious about the game. She doesn't offer any special deals, but she doesn't try to take advantage either. Perfect for players who want authentic casino blackjack.

---

### 2. **Lucky** - The Player's Friend 🍀
**Personality**: Generous, laid-back, rooting for you
**Theme Colour**: `#FFD700` (gold)
**Tagline**: "I'm on your side!"

**Rules**:
- Single deck 🆕
- Dealer stands on soft 17 ✅
- Double on any two cards ✅
- **Free doubles**: Double down costs nothing (still get one card) 🆕
- **Free splits**: Split costs nothing, cards dealt as normal 🆕
- Re-split aces allowed 🆕
- Late surrender allowed 🆕
- Blackjack pays 3:2 ✅
- **House edge**: Slightly player-favoured (~-0.5%)

**Character Notes**: Lucky is the most player-friendly dealer. He actually wants you to win! Free doubles and splits mean you can make aggressive strategic moves without risking extra money. This is the dealer for players who want to feel like the house is on their side. Perfect for learning or building confidence.

**Implementation Note**: Free doubles/splits are a unique mechanic. When player doubles/splits, don't deduct additional bet from bankroll, but still pay out as if they bet normally.

---

### 3. **Shark** - The High Roller 🦈
**Personality**: Aggressive, confident, high stakes
**Theme Colour**: `#0A84FF` (sharp blue)
**Tagline**: "Big risks, big rewards"

**Rules**:
- 8 decks 🆕
- Dealer hits soft 17 🆕
- Double on 9, 10, 11 only 🆕
- No double after split 🆕
- Split once only (2 hands max) 🆕
- No re-splitting aces 🆕
- No surrender ✅
- Blackjack pays 6:5 🆕
- **Minimum bet**: 5x normal (e.g., $50 instead of $10) 🆕
- **House edge**: ~2%

**Character Notes**: Shark is for high rollers who want intense action. The rules are tougher and the house edge is higher, but the minimum bet forces you to play big. Every hand matters. This dealer appeals to experienced players who want to feel the pressure and excitement of high-stakes gambling. The 6:5 blackjack payout is controversial in real casinos (many players hate it), but it's part of Shark's tough-guy persona.

**Implementation Note**: Shark's 5x minimum bet means if normal min is $10, Shark's min is $50. Payouts are scaled accordingly (winning $50 bet pays $100, not $20).

---

### 4. **Zen** - The Teacher 🧘
**Personality**: Calm, patient, educational
**Theme Colour**: `#AF52DE` (purple/zen)
**Tagline**: "Learn the way"

**Rules**:
- 2 decks 🆕
- Dealer stands on soft 17 ✅
- Double on any two cards ✅
- Double after split allowed ✅
- Re-split up to 4 hands ✅
- Re-split aces allowed 🆕
- Early surrender allowed 🆕
- Blackjack pays 3:2 ✅
- **Special**: Basic strategy hints always enabled 🆕 (Phase 8)
- **Special**: Hand probabilities shown on request 🆕 (Phase 8)
- **House edge**: ~0.35%

**Character Notes**: Zen is the teacher. She's patient, never rushes you, and actively helps you learn optimal strategy. The hints are always on (not optional), and players can tap for detailed probability breakdowns. Her rules are player-friendly (early surrender, re-split aces), making her perfect for beginners or players who want to improve their game. She's calm and encouraging, never judgmental.

**Implementation Note**: Hints and probabilities are Phase 8 features. For Phase 3, just implement her favourable rule set and make note in code that hint features will be added later. Focus on early surrender (surrender before any action) vs late surrender (after dealer checks for blackjack).

---

### 5. **Blitz** - The Speed Demon ⚡
**Personality**: Fast-paced, energetic, quick decisions
**Theme Colour**: `#FF9500` (orange/lightning)
**Tagline**: "Let's go! No time to waste!"

**Rules**:
- 6 decks ✅
- Dealer stands on soft 17 ✅
- Standard blackjack rules (similar to Ruby) ✅
- **Special**: 5-second decision timer on each action 🆕 (Phase 7)
- **Special**: Speed multiplier - faster wins = bigger bonuses 🆕 (Phase 7)
- **Special**: Streak bonuses for consecutive quick wins 🆕 (Phase 7)
- **House edge**: ~0.55%

**Character Notes**: Blitz is for players who want rapid-fire action. No time to overthink - trust your instincts! The 5-second timer adds pressure but also excitement. Quick decisions lead to bonus payouts, encouraging fast play. Perfect for experienced players who find normal blackjack too slow. Blitz has high energy and constantly encourages you to go faster.

**Implementation Note**: Timer and bonuses are Phase 7 features. For Phase 3, implement Blitz with Ruby's rules, but add code comments indicating where timer logic will go. The personality and theme are what matter now.

---

### 6. **Maverick** - The Wild Card 🎲
**Personality**: Unpredictable, fun, experimental
**Theme Colour**: Rainbow gradient or multi-colour
**Tagline**: "Expect the unexpected"

**Rules**:
- **Rules randomise each shoe** from a pool of fair variations 🆕
- Displays current rules clearly at start of shoe 🆕
- Always between 0.4% - 0.8% house edge (fair range) 🆕
- Can include wild rules like:
  - 5-card charlie (automatic win with 5 cards) 🆕
  - Suited blackjack pays 2:1 🆕
  - 777 bonus pays 3:1 🆕
  - Late surrender on any hand total 🆕
- **Special**: Mystery bonus rounds 🆕 (Phase 6)

**Character Notes**: Maverick is chaos incarnate - in a fun way! You never know what rules you'll get each shoe. One shoe might have super favourable rules, the next might be tougher. Keeps gameplay fresh and surprising. Perfect for players who get bored with standard blackjack. Maverick has a playful, mischievous personality - always mixing things up.

**Implementation Note**: This is the most complex dealer. For Phase 3, create a system where Maverick's rules are randomly selected from predefined rule sets at the start of each shoe. Store 5-6 different rule combinations that fall within the target house edge range. Display the active rules prominently when playing against Maverick. Bonus rules (5-card charlie, suited BJ) can be Phase 6 enhancements.

---

## 📝 Phase 3 Master Checklist

Use the TodoWrite tool to track these tasks:

### 3.1 Dealer Model & Rules System
- [ ] Create `Dealer.swift` model with properties:
  - `id: UUID`
  - `name: String` (e.g., "Ruby")
  - `tagline: String`
  - `themeColor: Color`
  - `personality: String` (description)
  - `rules: GameRules`
  - `avatarName: String` (for SF Symbol or custom image)
- [ ] Create `GameRules.swift` struct with all rule variations:
  - `numberOfDecks: Int`
  - `dealerHitsSoft17: Bool`
  - `doubleAfterSplit: Bool`
  - `resplitAces: Bool`
  - `splitAcesOneCardOnly: Bool`
  - `maxSplitHands: Int`
  - `surrenderAllowed: Bool`
  - `earlySurrender: Bool` (before dealer checks BJ)
  - `blackjackPayout: Double` (1.5 for 3:2, 1.2 for 6:5)
  - `doubleOnlyOn: [Int]?` (nil = any, else specific totals like [9,10,11])
  - `minimumBetMultiplier: Double` (1.0 = normal, 5.0 = Shark)
  - `freeDoubles: Bool` (Lucky only)
  - `freeSplits: Bool` (Lucky only)
- [ ] Create factory methods for each dealer (e.g., `Dealer.ruby()`, `Dealer.lucky()`)
- [ ] Add computed property `houseEdge: Double` (approximation for display)
- **Git**: `"feat: implement Dealer and GameRules models"`

### 3.2 Integrate Rules into GameViewModel
- [ ] Add `@Published var currentDealer: Dealer` to GameViewModel
- [ ] Add `var rules: GameRules` computed property (returns currentDealer.rules)
- [ ] Update `DeckManager` initialization to use `rules.numberOfDecks`
- [ ] Modify dealer AI to check `rules.dealerHitsSoft17`:
  - If false: Stand on all 17s (including soft 17)
  - If true: Hit on soft 17, stand on hard 17
- [ ] Update `canDoubleDown` to check `rules.doubleOnlyOn`:
  - If nil: Allow double on any two cards
  - If specified: Only allow if hand total matches
- [ ] Update `canDoubleDown` to check `rules.doubleAfterSplit`
- [ ] Update `split()` to check `rules.maxSplitHands`
- [ ] Update `split()` to check `rules.resplitAces` and `rules.splitAcesOneCardOnly`
- [ ] Update `canSurrender` to check `rules.surrenderAllowed`
- [ ] Implement early vs late surrender:
  - Early: Can surrender before dealer checks for blackjack
  - Late: Can only surrender after dealer checks (current implementation)
- [ ] Update payout calculation to use `rules.blackjackPayout`:
  - 3:2: `bet * (1 + 1.5)` = `bet * 2.5`
  - 6:5: `bet * (1 + 1.2)` = `bet * 2.2`
- [ ] Update minimum bet validation to use `rules.minimumBetMultiplier`
- [ ] Implement Lucky's free doubles:
  - When doubling, if `rules.freeDoubles == true`, don't deduct extra bet
  - Still calculate payout as if full bet was placed
- [ ] Implement Lucky's free splits:
  - When splitting, if `rules.freeSplits == true`, don't deduct second bet
  - Still track bets normally for payout calculation
- **Git**: `"feat: integrate rule variations into game logic"`

### 3.3 Dealer Selection Screen
- [ ] Create `DealerSelectionView.swift` with carousel/grid layout
- [ ] Display all 6 dealers with:
  - Avatar (SF Symbol or custom image placeholder)
  - Name
  - Tagline
  - Theme colour accent
  - Brief personality description
- [ ] Tappable cards that show detailed view:
  - Full rule list
  - House edge percentage
  - Minimum bet
  - Special features
- [ ] "Select Dealer" button to confirm choice
- [ ] Warning if switching dealers mid-session (clears current shoe)
- [ ] Smooth transition animation (0.5s fade)
- **Git**: `"feat: create dealer selection screen with carousel"`

### 3.4 Integrate Dealer Selection into Game Flow
- [ ] Add dealer selection on first launch (after welcome screen)
- [ ] Add "Change Dealer" button in settings or dealer info area
- [ ] Update GameView to show current dealer:
  - Display dealer avatar in top bar or dealer area
  - Apply dealer theme colour to accents (bet slider, buttons, etc.)
  - Show dealer name and tagline somewhere prominent
- [ ] Create `DealerInfoView` (swipeable panel or modal):
  - Current dealer's personality
  - Active rules list
  - House edge
  - "Change Dealer" button
- [ ] Handle dealer switching:
  - Confirm with user if mid-shoe
  - Reset deck/shoe with new dealer's deck count
  - Clear current hand
  - Return to betting state
  - Update theme colours
- **Git**: `"feat: integrate dealer selection into game flow"`

### 3.5 Maverick's Random Rule System
- [ ] Create `MaverickRuleGenerator.swift` utility
- [ ] Define 5-6 predefined rule combinations:
  - Each combination has balanced house edge (0.4%-0.8%)
  - Mix of favourable and unfavourable rules
  - Examples:
    - "Lucky streak": 2 decks, stand soft 17, surrender, resplit aces
    - "High risk": 8 decks, hit soft 17, no surrender, 6:5 BJ
    - "Balanced chaos": 4 decks, stand soft 17, no resplit, split 2x only
- [ ] Randomise rules when Maverick shoe starts (75% penetration reached)
- [ ] Display active rules prominently in UI (modal or banner)
- [ ] Store current Maverick rules in GameViewModel
- [ ] Add "Current Rules" button for Maverick in dealer info
- **Git**: `"feat: implement Maverick random rule system"`

### 3.6 Advanced Rule Mechanics
- [ ] Implement split aces special handling:
  - If `splitAcesOneCardOnly == true`: Deal one card to each ace, auto-stand
  - If `resplitAces == false`: Cannot split again if dealt another ace
  - If `resplitAces == true`: Can re-split aces like any other pair
- [ ] Implement soft 17 dealer logic:
  - Detect when dealer has soft 17 (Ace counted as 11, total = 17)
  - If `dealerHitsSoft17 == true`: Dealer takes another card
  - If `dealerHitsSoft17 == false`: Dealer stands
- [ ] Implement double restrictions (Shark):
  - Check hand total against `rules.doubleOnlyOn`
  - Only show "Double" button if total matches allowed values
  - Display message if player tries to double on invalid total
- [ ] Implement split restrictions (Shark):
  - `maxSplitHands = 2` means only one split (2 total hands)
  - Disable "Split" button after first split
- [ ] Test Lucky's free mechanics thoroughly:
  - Ensure bankroll doesn't decrease on free double
  - Ensure bankroll doesn't decrease on free split
  - Verify payouts are calculated correctly (as if full bet)
- **Git**: `"feat: implement advanced rule mechanics (soft 17, split aces, restrictions)"`

### 3.7 UI Theming per Dealer
- [ ] Create `DealerTheme.swift` with colour schemes
- [ ] Update GameView to apply current dealer's theme:
  - Bet slider accent colour
  - Action button highlights
  - Dealer area border/glow
  - Result screen accent
- [ ] Add dealer avatar to GameView:
  - Top bar next to bankroll, OR
  - In dealer area above cards
- [ ] Show dealer name/tagline in betting screen:
  - "Playing against Ruby - Let's keep it traditional"
- [ ] For Maverick: Rainbow gradient or shifting colours
- [ ] Smooth theme transitions when switching dealers (0.5s fade)
- **Git**: `"feat: add dealer-specific UI theming and avatars"`

### 3.8 Testing
- [ ] Write unit tests for `Dealer` and `GameRules` models
- [ ] Write tests for rule enforcement:
  - Soft 17 dealer behaviour (hits vs stands)
  - Double restrictions (9/10/11 only for Shark)
  - Split restrictions (max hands, aces)
  - Blackjack payout variations (3:2 vs 6:5)
  - Minimum bet multiplier (Shark's 5x)
- [ ] Write tests for Lucky's free mechanics:
  - Free double doesn't deduct bankroll
  - Free split doesn't deduct bankroll
  - Payouts still calculated correctly
- [ ] Write tests for Maverick rule generation:
  - Rules randomise on shoe reshuffle
  - Rules always within target house edge
- [ ] Manual testing with each dealer:
  - Play 20+ hands with Ruby (standard experience)
  - Play 20+ hands with Lucky (test free mechanics)
  - Play 20+ hands with Shark (test restrictions, 6:5 BJ)
  - Play 10+ hands with Zen (test early surrender, resplit aces)
  - Play 10+ hands with Blitz (same as Ruby for now)
  - Play 20+ hands with Maverick (verify rule changes each shoe)
- [ ] Test dealer switching:
  - Switch mid-shoe (confirm warning appears)
  - Switch after hand completes (smooth transition)
  - Verify theme updates correctly
  - Verify deck count updates (1 deck vs 6 vs 8)
- **Git**: `"test: comprehensive testing for dealer personalities and rule variations"`

### 3.9 Documentation & Polish
- [ ] Add inline comments explaining each rule variation
- [ ] Document house edge calculations (formulas or references)
- [ ] Create usage examples in code for each dealer
- [ ] Update `PHASE_3_COMPLETE.md` with:
  - Implementation summary
  - Each dealer's details
  - Rule variations implemented
  - Known issues or future enhancements
- [ ] Code review: Ensure Phase 1/2 style consistency
- [ ] Verify Australian English throughout
- [ ] Check all heavy commenting is present
- **Git**: `"docs: Phase 3 completion summary and documentation"`

### 3.10 Final Commit & Push
- [ ] Final code review
- [ ] Verify all 6 dealers are playable
- [ ] Test switching between all dealers
- [ ] Performance check on older devices (if possible)
- [ ] Final commit: `"feat: Phase 3 complete - 6 dealer personalities with rule variations"`
- [ ] Push to branch

---

## 🎨 Code Style Requirements (CRITICAL - Must Follow)

### 1. Heavy Commenting with Business Context
Every file needs the standard header with purpose and business context:

```swift
// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 👥 DEALER MODEL                                                            ║
// ║                                                                            ║
// ║ Purpose: Represents a blackjack dealer with unique personality and rules  ║
// ║ Business Context: Each dealer is a themed avatar that encapsulates a      ║
// ║                   rule set. Instead of complex settings menus, players    ║
// ║                   choose their experience by choosing their dealer.       ║
// ║                                                                            ║
// ║ Used By: GameViewModel (tracks current dealer)                            ║
// ║          DealerSelectionView (displays available dealers)                 ║
// ║                                                                            ║
// ║ Related Spec: See "Dealer Personalities" section, lines 17-127            ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
```

Every function/method needs context:

```swift
// ┌─────────────────────────────────────────────────────────────────────┐
// │ 🦈 CREATE SHARK DEALER                                               │
// │                                                                      │
// │ Business Logic: Creates the "Shark" dealer with high-roller rules   │
// │ Personality: Aggressive, tough rules, high minimum bets             │
// │ House Edge: ~2% (highest of all dealers)                            │
// │                                                                      │
// │ Key Features:                                                        │
// │ • 8-deck shoe for more house advantage                              │
// │ • Dealer hits soft 17 (more dealer wins)                            │
// │ • Double only on 9/10/11 (restricts player options)                 │
// │ • 6:5 blackjack payout (instead of standard 3:2)                    │
// │ • 5x minimum bet (high stakes only)                                 │
// └─────────────────────────────────────────────────────────────────────┘
static func shark() -> Dealer {
    // Implementation
}
```

### 2. Australian English
- Comments: "colour" not "color", "optimise" not "optimize", "favour" not "favor"
- Currency: "$X AUD" format
- UI text: Australian spelling and phrasing

### 3. Visual Hierarchy
- Use box-drawing characters (╔═══╗, ┌───┐)
- Use emojis for sections (👥 🎮 💰 🃏 ✅ ⚠️ 🦈 🍀 ♦️)
- Clear visual separation between code blocks

### 4. Testing Requirements
- Write tests for all dealer rule variations
- Test names descriptive: `testSharkDealerHitsSoft17()`
- Include comments explaining business rules being tested

---

## 📂 File Structure to Create

```
Blackjackwhitejack/
├── Models/
│   ├── Dealer.swift                 (NEW - Phase 3)
│   ├── GameRules.swift              (NEW - Phase 3)
│   └── DealerTheme.swift            (NEW - Phase 3)
├── ViewModels/
│   └── GameViewModel.swift          (MODIFY - add dealer support)
├── Views/
│   ├── Dealers/
│   │   ├── DealerSelectionView.swift    (NEW - Phase 3)
│   │   ├── DealerCardView.swift         (NEW - Phase 3)
│   │   └── DealerInfoView.swift         (NEW - Phase 3)
│   └── Game/
│       └── GameView.swift               (MODIFY - add dealer theming)
├── Services/
│   ├── DeckManager.swift            (MODIFY - dynamic deck count)
│   └── MaverickRuleGenerator.swift  (NEW - Phase 3)
└── Utils/
    └── Colors.swift                 (MODIFY - add dealer theme colours)

BlackjackwhitejackTests/
├── DealerModelTests.swift           (NEW - Phase 3)
├── GameRulesTests.swift             (NEW - Phase 3)
├── GameViewModelTests.swift         (MODIFY - add rule variation tests)
└── MaverickRuleGeneratorTests.swift (NEW - Phase 3)
```

---

## 🎯 Key Implementation Details

### Dealer Model Structure

```swift
struct Dealer: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let tagline: String
    let personality: String // Full description
    let themeColor: Color
    let avatarName: String // SF Symbol or asset name
    let rules: GameRules

    // Computed
    var houseEdge: Double {
        // Calculate based on rules (approximation)
    }

    // Factory methods
    static func ruby() -> Dealer { ... }
    static func lucky() -> Dealer { ... }
    static func shark() -> Dealer { ... }
    static func zen() -> Dealer { ... }
    static func blitz() -> Dealer { ... }
    static func maverick() -> Dealer { ... }

    static var allDealers: [Dealer] {
        return [ruby(), lucky(), shark(), zen(), blitz(), maverick()]
    }
}
```

### GameRules Structure

```swift
struct GameRules: Codable, Equatable {
    // Deck configuration
    let numberOfDecks: Int // 1-8

    // Dealer behaviour
    let dealerHitsSoft17: Bool // true = hits S17, false = stands all 17s

    // Player double down rules
    let doubleOnlyOn: [Int]? // nil = any two cards, [9,10,11] = restricted
    let doubleAfterSplit: Bool // Can double after splitting?

    // Split rules
    let maxSplitHands: Int // 2, 3, or 4
    let resplitAces: Bool // Can split aces multiple times?
    let splitAcesOneCardOnly: Bool // Split aces get only one card each?

    // Surrender
    let surrenderAllowed: Bool
    let earlySurrender: Bool // Before dealer checks BJ?

    // Payouts
    let blackjackPayout: Double // 1.5 = 3:2, 1.2 = 6:5

    // Special mechanics
    let minimumBetMultiplier: Double // 1.0 = normal, 5.0 = Shark
    let freeDoubles: Bool // Lucky only
    let freeSplits: Bool // Lucky only

    // Defaults for standard blackjack
    static var standard: GameRules {
        return GameRules(
            numberOfDecks: 6,
            dealerHitsSoft17: false,
            doubleOnlyOn: nil,
            doubleAfterSplit: true,
            maxSplitHands: 4,
            resplitAces: false,
            splitAcesOneCardOnly: true,
            surrenderAllowed: false,
            earlySurrender: false,
            blackjackPayout: 1.5,
            minimumBetMultiplier: 1.0,
            freeDoubles: false,
            freeSplits: false
        )
    }
}
```

### Dealer AI with Soft 17

```swift
// In GameViewModel.playDealerHand()

while dealerHand.total < 17 || (dealerHand.total == 17 && dealerHand.isSoft && rules.dealerHitsSoft17) {
    // Dealer hits if:
    // 1. Total < 17, OR
    // 2. Soft 17 and rules say to hit soft 17

    guard let card = deckManager.dealCard() else {
        break
    }

    dealerHand.addCard(card)

    if dealerHand.isBust {
        break
    }
}
```

### Lucky's Free Double Implementation

```swift
func doubleDown() {
    guard gameState == .playerTurn else { return }
    guard currentHand.canDouble() else { return }

    let additionalBet = handBets[currentHandIndex]

    // Check if this is a free double (Lucky dealer)
    if !rules.freeDoubles {
        // Normal double - deduct from bankroll
        guard bankroll >= additionalBet else {
            print("⚠️ Insufficient funds to double")
            return
        }
        bankroll -= additionalBet
    } else {
        // Lucky's free double - no cost!
        print("🍀 Lucky's free double - no additional cost!")
    }

    // Update bet tracking (same either way for payout calculation)
    handBets[currentHandIndex] *= 2
    currentBet += additionalBet

    // Deal one card and auto-stand
    // ... rest of double logic
}
```

### Shark's 6:5 Blackjack Payout

```swift
// In evaluateResults()

if hand.isBlackjack && !dealerHand.isBlackjack {
    // Player blackjack beats dealer 21
    let payout = bet * (1 + rules.blackjackPayout) // 1.5 for 3:2, 1.2 for 6:5
    totalPayout += payout

    if rules.blackjackPayout == 1.5 {
        outcomes.append("Blackjack\(handNum): +$\(formatCurrency(payout - bet)) (3:2)")
    } else if rules.blackjackPayout == 1.2 {
        outcomes.append("Blackjack\(handNum): +$\(formatCurrency(payout - bet)) (6:5)")
    }
}
```

---

## 🧪 Testing Philosophy

### Unit Tests Required

1. **Dealer Creation Tests**
   - Test each factory method creates correct dealer
   - Verify each dealer has unique theme colour
   - Verify each dealer's rules match spec
   - Test `allDealers` returns 6 dealers

2. **Rule Enforcement Tests**
   - Soft 17: Verify dealer hits/stands correctly
   - Double restrictions: Shark only allows 9/10/11
   - Split restrictions: Shark max 2 hands
   - Blackjack payout: 3:2 vs 6:5 calculations
   - Minimum bet: Shark's 5x multiplier

3. **Lucky Special Mechanics**
   - Free double doesn't reduce bankroll
   - Free split doesn't reduce bankroll
   - Payouts calculated as if full bet placed

4. **Maverick Randomization**
   - Rules change each shoe
   - Rules always within fair house edge range
   - No two consecutive shoes have identical rules (preferably)

### Manual Testing Required

- Play 20+ hands with each dealer
- Verify personality comes through in rules
- Test dealer switching mid-game
- Verify theme colours apply correctly
- Test bankruptcy with each dealer's minimum bet
- Test all edge cases (soft 17, split aces, etc.)

---

## 🎬 Getting Started Workflow

### Step 1: Create Model Layer
1. Create `GameRules.swift` with all rule properties
2. Create `Dealer.swift` with factory methods for each dealer
3. Write comprehensive tests for models
4. **Commit**: "feat: implement Dealer and GameRules models"

### Step 2: Integrate into GameViewModel
1. Add `currentDealer` property to GameViewModel
2. Update all rule checks to use `rules.*` instead of hardcoded values
3. Implement soft 17 dealer logic
4. Implement Lucky's free mechanics
5. Implement Shark's restrictions
6. Write tests for rule enforcement
7. **Commit**: "feat: integrate rule variations into game logic"

### Step 3: Build Dealer Selection UI
1. Create `DealerSelectionView` with grid/carousel
2. Create `DealerCardView` for each dealer card
3. Create `DealerInfoView` for detailed rules display
4. Wire up dealer selection to GameViewModel
5. **Commit**: "feat: create dealer selection screen"

### Step 4: Theme & Polish
1. Add dealer avatar to GameView
2. Apply dealer theme colours throughout UI
3. Add dealer switching functionality
4. Test with each dealer
5. **Commit**: "feat: add dealer theming and switching"

### Step 5: Maverick's Chaos
1. Create `MaverickRuleGenerator`
2. Implement random rule selection
3. Add rules display for Maverick
4. Test thoroughly
5. **Commit**: "feat: implement Maverick random rules"

### Step 6: Final Testing & Documentation
1. Manual testing with all dealers
2. Update tests
3. Write Phase 3 summary
4. **Commit**: "docs: Phase 3 complete"
5. **Push** to branch

---

## 🎨 Avatar Recommendations

For Phase 3, use SF Symbols or simple shapes:
- **Ruby**: `suit.diamond.fill` (red)
- **Lucky**: `clover.fill` or `star.fill` (gold)
- **Shark**: `triangle.fill` rotated (blue, shark fin)
- **Zen**: `circle.fill` with gradient (purple)
- **Blitz**: `bolt.fill` (orange)
- **Maverick**: `questionmark.circle.fill` or `dice.fill` (rainbow)

Phase 6+ can add custom illustrated avatars if desired.

---

## 🚫 What NOT to Do

- ❌ Don't implement timer logic for Blitz (Phase 7)
- ❌ Don't implement strategy hints for Zen (Phase 8)
- ❌ Don't implement 5-card charlie or exotic bonuses yet (Phase 6)
- ❌ Don't implement mystery bonus rounds for Maverick (Phase 6)
- ❌ Don't implement animations (Phase 7)
- ❌ Don't create custom avatar graphics (use SF Symbols for now)
- ❌ Don't implement leaderboards or challenges (Phase 9-10)

**Focus**: Models, rules, logic, and basic UI. The personality and rules are what matter in Phase 3.

---

## ✅ Definition of Done

Phase 3 is complete when:
- ✅ All 6 dealers are implemented with correct rules
- ✅ Dealer selection screen is functional
- ✅ Player can switch dealers mid-session
- ✅ All rule variations work correctly (soft 17, split aces, double restrictions, etc.)
- ✅ Lucky's free mechanics work (doesn't cost extra but pays normally)
- ✅ Shark's 6:5 blackjack payout is correct
- ✅ Shark's 5x minimum bet is enforced
- ✅ Maverick's rules randomise each shoe
- ✅ Dealer theme colours apply throughout UI
- ✅ Dealer avatar displays in game
- ✅ All rule enforcement tests pass
- ✅ Manual testing completed with each dealer
- ✅ Code follows Phase 1/2 style (heavy comments, Australian English)
- ✅ All code committed and pushed

---

## 🎯 Success Criteria

After Phase 3, the app should:
1. Feel like 6 different games (same core mechanics, but different flavour)
2. Make rule selection intuitive through personality
3. Have clear visual identity for each dealer (colour, avatar)
4. Enforce all rule variations correctly
5. Provide interesting strategic choices (Ruby vs Lucky vs Shark)
6. Be fun to switch between dealers

**The goal**: Transform "blackjack with settings" into "choose your dealer, choose your adventure!"

---

## 📞 Questions to Consider

As you implement, think about:
- How does the UI communicate rule differences to the player?
- Is it obvious why Lucky is more favourable than Shark?
- Does Maverick feel chaotic-fun or chaotic-annoying?
- Are dealer personalities distinct and memorable?
- Do theme colours enhance or distract from gameplay?
- Is dealer switching easy to discover and use?

---

## 🎉 Let's Make This Happen!

Phase 3 is about bringing personality and variety to the game. Each dealer should feel distinct and memorable. Players should have a favourite dealer and understand why they prefer them.

**Your first task**: Create `Dealer.swift` and `GameRules.swift` with Ruby and Lucky fully defined. Then write tests to verify their rules are encoded correctly.

Ready? Let's give this blackjack game some personality! 🎰👥🃏

---

**Good luck! Remember**: Heavy comments, Australian English, and test as you go! 🚀
