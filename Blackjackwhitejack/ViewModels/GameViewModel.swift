//
//  GameViewModel.swift
//  Natural - Modern Blackjack
//
//  Created by Claude Code
//  Part of Phase 2: Core Gameplay
//

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 🎮 GAME VIEW MODEL - The Brain of Blackjack                               ║
// ║                                                                            ║
// ║ Purpose: Orchestrates all gameplay state, logic, and flow                 ║
// ║ Business Context: This is the single source of truth for the entire game. ║
// ║                   It coordinates the deck, hands, bets, and game flow,    ║
// ║                   implementing a state machine that guides the player     ║
// ║                   from betting → dealing → playing → dealer turn → result.║
// ║                                                                            ║
// ║ Responsibilities:                                                          ║
// ║ • Manage game state transitions (betting → dealing → playing → result)    ║
// ║ • Coordinate with DeckManager for card dealing                            ║
// ║ • Track player hand(s) and dealer hand                                    ║
// ║ • Process player actions (Hit, Stand, Double, Split, Surrender)           ║
// ║ • Implement dealer AI logic                                               ║
// ║ • Calculate payouts and update bankroll                                   ║
// ║ • Handle edge cases (bust, blackjack, push, bankruptcy)                   ║
// ║                                                                            ║
// ║ Used By: GameView (observes @Published properties for UI updates)         ║
// ║ Uses: DeckManager, Hand, Card, Player models                              ║
// ║                                                                            ║
// ║ Related Spec: See "Core Gameplay Mechanics" section (lines 130-170)       ║
// ║               and "Typical Game Flow" (lines 543-551)                     ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 📊 PUBLISHED STATE PROPERTIES                                        │
    // │                                                                      │
    // │ These properties trigger UI updates when changed                    │
    // │ GameView observes these to stay in sync with game state             │
    // └─────────────────────────────────────────────────────────────────────┘

    /// Current game state - drives UI display and available actions
    @Published private(set) var gameState: GameState = .betting

    /// Player's current hand(s) - array supports splits (up to 4 hands)
    @Published private(set) var playerHands: [Hand] = [Hand()]

    /// Index of currently active player hand (important for splits)
    @Published private(set) var currentHandIndex: Int = 0

    /// Dealer's visible card (the "upcard")
    @Published private(set) var dealerUpcard: Card?

    /// Dealer's hidden card (revealed during dealer's turn)
    @Published private(set) var dealerHoleCard: Card?

    /// All dealer cards (built as hole card is revealed)
    @Published private(set) var dealerHand: Hand = Hand()

    /// Current bet amount (in AUD)
    @Published var currentBet: Double = 0

    /// Player's bankroll (in AUD)
    @Published var bankroll: Double = 10000 // Default starting balance

    /// Last bet amount (used to remember bet between hands)
    @Published private(set) var lastBet: Double = 10

    /// Minimum bet allowed (based on settings or dealer rules)
    @Published var minimumBet: Double = 10

    /// Result message to display to player
    @Published private(set) var resultMessage: String = ""

    /// Whether reshuffle is needed (visual indicator for player)
    @Published private(set) var needsReshuffle: Bool = false

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🔧 INTERNAL PROPERTIES                                               │
    // │                                                                      │
    // │ These are used internally but don't need to trigger UI updates      │
    // └─────────────────────────────────────────────────────────────────────┘

    /// Deck manager handles shoe management and dealing
    private var deckManager: DeckManager

    /// Bets for each hand (needed for splits where each hand can have different bets)
    private var handBets: [Double] = []

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🏗️ INITIALISER                                                       │
    // │                                                                      │
    // │ Parameters:                                                          │
    // │ • numberOfDecks: Shoe size (1-8, based on dealer - default 6)       │
    // │ • startingBankroll: Initial player balance (default $10,000 AUD)    │
    // │ • minimumBet: Lowest bet allowed (default $10 AUD)                  │
    // └─────────────────────────────────────────────────────────────────────┘

    init(numberOfDecks: Int = 6, startingBankroll: Double = 10000, minimumBet: Double = 10) {
        self.deckManager = DeckManager(numberOfDecks: numberOfDecks, penetrationThreshold: 0.75)
        self.bankroll = startingBankroll
        self.minimumBet = minimumBet
        self.lastBet = minimumBet
    }

    // ╔═══════════════════════════════════════════════════════════════════════════╗
    // ║ 🎰 BETTING PHASE                                                           ║
    // ╚═══════════════════════════════════════════════════════════════════════════╝

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 💰 PLACE BET                                                         │
    // │                                                                      │
    // │ Business Logic: Player commits to a bet amount to start a new hand  │
    // │ Called when: Player confirms bet via BettingView UI                 │
    // │                                                                      │
    // │ Validation:                                                          │
    // │ • Bet must be >= minimumBet                                         │
    // │ • Bet must be <= current bankroll                                   │
    // │                                                                      │
    // │ Side Effects:                                                        │
    // │ • Deducts bet from bankroll                                         │
    // │ • Transitions to .dealing state                                     │
    // │ • Remembers bet as lastBet                                          │
    // │ • Triggers initial deal                                             │
    // └─────────────────────────────────────────────────────────────────────┘

    func placeBet(_ amount: Double) {
        // Validate bet
        guard amount >= minimumBet else {
            print("⚠️ Bet too low: \(amount) < \(minimumBet)")
            return
        }

        guard amount <= bankroll else {
            print("⚠️ Insufficient funds: \(amount) > \(bankroll)")
            return
        }

        guard gameState == .betting else {
            print("⚠️ Cannot place bet in \(gameState) state")
            return
        }

        // Commit bet
        currentBet = amount
        lastBet = amount
        bankroll -= amount

        // Set up single hand with this bet
        handBets = [amount]

        print("💰 Bet placed: $\(amount) AUD (Bankroll: $\(bankroll))")

        // Transition to dealing
        gameState = .dealing

        // Start dealing sequence
        dealInitialCards()
    }

    // ╔═══════════════════════════════════════════════════════════════════════════╗
    // ║ 🎴 DEALING PHASE                                                           ║
    // ╚═══════════════════════════════════════════════════════════════════════════╝

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🎴 DEAL INITIAL CARDS                                                │
    // │                                                                      │
    // │ Business Logic: Deals 2 cards to player, 2 to dealer (one hidden)   │
    // │ Standard casino sequence:                                            │
    // │ 1. Player card (face up)                                            │
    // │ 2. Dealer card (face up - upcard)                                   │
    // │ 3. Player card (face up)                                            │
    // │ 4. Dealer card (face down - hole card)                              │
    // │                                                                      │
    // │ After dealing:                                                       │
    // │ • Check for player blackjack                                        │
    // │ • Check for dealer blackjack                                        │
    // │ • If both: Push (tie)                                               │
    // │ • If only player: Instant win 3:2                                   │
    // │ • If only dealer: Instant loss                                      │
    // │ • Otherwise: Transition to player's turn                            │
    // └─────────────────────────────────────────────────────────────────────┘

    private func dealInitialCards() {
        // Check for reshuffle before dealing
        if deckManager.needsReshuffle {
            needsReshuffle = true
            deckManager.reshuffle()
            needsReshuffle = false
        }

        // Deal cards using DeckManager
        guard let initialDeal = deckManager.dealInitialHands() else {
            print("❌ Failed to deal cards - deck exhausted?")
            return
        }

        // Set up player hand
        playerHands = [initialDeal.playerHand]
        currentHandIndex = 0

        // Set up dealer cards
        dealerUpcard = initialDeal.dealerUpcard
        dealerHoleCard = initialDeal.dealerHoleCard

        // Build dealer's visible hand (just upcard for now)
        dealerHand = Hand()
        dealerHand.addCard(initialDeal.dealerUpcard)

        print("🎴 Cards dealt:")
        print("   Player: \(playerHands[0].description)")
        print("   Dealer: \(dealerUpcard!.displayString) + [hidden]")

        // Check for blackjacks
        let playerHasBlackjack = playerHands[0].isBlackjack

        // For blackjack check, we need to peek at dealer's full hand
        var dealerFullHand = Hand()
        dealerFullHand.addCard(initialDeal.dealerUpcard)
        dealerFullHand.addCard(initialDeal.dealerHoleCard)
        let dealerHasBlackjack = dealerFullHand.isBlackjack

        if playerHasBlackjack || dealerHasBlackjack {
            // Instant resolution - reveal dealer hole card
            revealDealerHoleCard()

            if playerHasBlackjack && dealerHasBlackjack {
                // Push - both have blackjack
                resultMessage = "Push - Both Blackjack!"
                bankroll += currentBet // Return bet
                print("🤝 Push - Both have blackjack")
            } else if playerHasBlackjack {
                // Player wins 3:2
                let payout = currentBet * 2.5 // Bet + 1.5x bet = 2.5x total
                bankroll += payout
                resultMessage = "Blackjack! You win $\(formatCurrency(payout - currentBet))!"
                print("🎉 Player blackjack! Payout: $\(payout)")
            } else {
                // Dealer wins
                resultMessage = "Dealer Blackjack - You lose"
                print("😔 Dealer blackjack - player loses")
            }

            gameState = .result
        } else {
            // Normal play - transition to player's turn
            gameState = .playerTurn
            print("▶️ Player's turn")
        }
    }

    // ╔═══════════════════════════════════════════════════════════════════════════╗
    // ║ 🎯 PLAYER ACTION PHASE                                                     ║
    // ╚═══════════════════════════════════════════════════════════════════════════╝

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🎴 HIT - Take Another Card                                           │
    // │                                                                      │
    // │ Business Logic: Deal one card to player's current hand              │
    // │ Called when: Player taps "Hit" button during their turn             │
    // │                                                                      │
    // │ Side Effects:                                                        │
    // │ • Adds card to current hand                                         │
    // │ • If bust: End player's turn, move to dealer turn                   │
    // │ • If 21: Auto-stand (optional rule, implementing for UX)            │
    // │ • If split scenario: May advance to next hand                       │
    // └─────────────────────────────────────────────────────────────────────┘

    func hit() {
        guard gameState == .playerTurn else {
            print("⚠️ Cannot hit in \(gameState) state")
            return
        }

        guard let card = deckManager.dealCard() else {
            print("❌ No cards remaining to deal")
            return
        }

        // Add card to current hand
        playerHands[currentHandIndex].addCard(card)
        let hand = playerHands[currentHandIndex]

        print("🎴 Player hits: \(card.displayString) → \(hand.description)")

        // Check for bust
        if hand.isBust {
            print("💥 Player busts with \(hand.total)")

            // If this was the last/only hand, move to dealer turn
            if currentHandIndex == playerHands.count - 1 {
                // All hands complete - dealer's turn
                gameState = .dealerTurn
                playDealerHand()
            } else {
                // Move to next split hand
                currentHandIndex += 1
                print("▶️ Moving to hand \(currentHandIndex + 1) of \(playerHands.count)")
            }
        } else if hand.total == 21 {
            // Auto-stand on 21 for better UX
            print("✓ Hand reaches 21 - auto-standing")
            stand()
        }
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ ✋ STAND - End Current Hand                                          │
    // │                                                                      │
    // │ Business Logic: Player is satisfied with current hand                │
    // │ Called when: Player taps "Stand" button during their turn           │
    // │                                                                      │
    // │ Side Effects:                                                        │
    // │ • If more split hands: Move to next hand                            │
    // │ • If all hands complete: Transition to dealer turn                  │
    // └─────────────────────────────────────────────────────────────────────┘

    func stand() {
        guard gameState == .playerTurn else {
            print("⚠️ Cannot stand in \(gameState) state")
            return
        }

        let hand = playerHands[currentHandIndex]
        print("✋ Player stands on \(hand.displayString)")

        // Check if there are more split hands
        if currentHandIndex < playerHands.count - 1 {
            // Move to next split hand
            currentHandIndex += 1
            print("▶️ Moving to hand \(currentHandIndex + 1) of \(playerHands.count)")
        } else {
            // All hands complete - dealer's turn
            gameState = .dealerTurn
            playDealerHand()
        }
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 💪 DOUBLE DOWN - Double Bet, Take One Card, Auto-Stand              │
    // │                                                                      │
    // │ Business Logic: Risky move - double your bet for exactly one card   │
    // │ Called when: Player taps "Double" button (only available on 2 cards)│
    // │                                                                      │
    // │ Rules:                                                               │
    // │ • Only available on first two cards (hand.canDouble())              │
    // │ • Some dealers restrict to totals 9/10/11 (Phase 3)                 │
    // │ • Must have enough bankroll to double                               │
    // │                                                                      │
    // │ Side Effects:                                                        │
    // │ • Deducts additional bet from bankroll                              │
    // │ • Deals exactly one card                                            │
    // │ • Automatically stands (no more actions allowed)                    │
    // └─────────────────────────────────────────────────────────────────────┘

    func doubleDown() {
        guard gameState == .playerTurn else {
            print("⚠️ Cannot double in \(gameState) state")
            return
        }

        let hand = playerHands[currentHandIndex]

        guard hand.canDouble() else {
            print("⚠️ Cannot double - hand has \(hand.count) cards")
            return
        }

        let additionalBet = handBets[currentHandIndex]

        guard bankroll >= additionalBet else {
            print("⚠️ Insufficient funds to double - need $\(additionalBet), have $\(bankroll)")
            return
        }

        // Deduct additional bet
        bankroll -= additionalBet
        handBets[currentHandIndex] *= 2
        currentBet += additionalBet

        print("💪 Player doubles down - bet now $\(handBets[currentHandIndex])")

        // Deal exactly one card
        guard let card = deckManager.dealCard() else {
            print("❌ No cards remaining to deal")
            return
        }

        playerHands[currentHandIndex].addCard(card)
        let updatedHand = playerHands[currentHandIndex]

        print("🎴 Double down card: \(card.displayString) → \(updatedHand.description)")

        // Automatically stand (even if bust)
        if currentHandIndex < playerHands.count - 1 {
            // More split hands to play
            currentHandIndex += 1
            print("▶️ Moving to hand \(currentHandIndex + 1) of \(playerHands.count)")
        } else {
            // All hands complete - dealer's turn
            gameState = .dealerTurn
            playDealerHand()
        }
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ ✂️ SPLIT - Split Pair Into Two Hands                                │
    // │                                                                      │
    // │ Business Logic: Split matching cards into two separate hands        │
    // │ Called when: Player taps "Split" button on a pair                   │
    // │                                                                      │
    // │ Rules:                                                               │
    // │ • Only on pairs (same rank, e.g., 8♠ 8♥ or K♠ Q♦)                  │
    // │ • Requires bankroll for second bet (equal to first)                 │
    // │ • Creates two hands, each with one card                             │
    // │ • Deals one card to each new hand                                   │
    // │ • Most dealers allow 3 re-splits (4 hands max)                      │
    // │ • Special rule: Split aces usually get only 1 card each (Phase 3)   │
    // │                                                                      │
    // │ Side Effects:                                                        │
    // │ • Deducts second bet from bankroll                                  │
    // │ • Creates two hands from one                                        │
    // │ • Deals one card to each hand                                       │
    // │ • Player continues with first hand                                  │
    // └─────────────────────────────────────────────────────────────────────┘

    func split() {
        guard gameState == .playerTurn else {
            print("⚠️ Cannot split in \(gameState) state")
            return
        }

        let hand = playerHands[currentHandIndex]

        guard hand.canSplit() else {
            print("⚠️ Cannot split - not a pair")
            return
        }

        guard playerHands.count < 4 else {
            print("⚠️ Cannot split - already have 4 hands (max)")
            return
        }

        let splitBet = handBets[currentHandIndex]

        guard bankroll >= splitBet else {
            print("⚠️ Insufficient funds to split - need $\(splitBet), have $\(bankroll)")
            return
        }

        // Deduct second bet
        bankroll -= splitBet
        currentBet += splitBet

        print("✂️ Player splits pair - creating 2 hands at $\(splitBet) each")

        // Split the hand
        let cards = hand.cards
        var hand1 = Hand(cards: [cards[0]])
        var hand2 = Hand(cards: [cards[1]])

        // Deal one card to each hand
        if let card1 = deckManager.dealCard() {
            hand1.addCard(card1)
            print("   Hand 1: \(hand1.description)")
        }

        if let card2 = deckManager.dealCard() {
            hand2.addCard(card2)
            print("   Hand 2: \(hand2.description)")
        }

        // Replace current hand and insert new hand
        playerHands[currentHandIndex] = hand1
        playerHands.insert(hand2, at: currentHandIndex + 1)
        handBets.insert(splitBet, at: currentHandIndex + 1)

        // Continue playing first split hand
        print("▶️ Playing hand 1 of \(playerHands.count)")

        // Check for instant 21 on first hand (auto-stand)
        if hand1.total == 21 {
            print("✓ First split hand is 21 - auto-standing")
            stand()
        }
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🏳️ SURRENDER - Forfeit Half Bet, End Hand                           │
    // │                                                                      │
    // │ Business Logic: Give up and get half your bet back                  │
    // │ Called when: Player taps "Surrender" button (dealer-specific)       │
    // │                                                                      │
    // │ Rules:                                                               │
    // │ • Only available as first action (before hit/stand)                 │
    // │ • Not all dealers allow this (Lucky & Zen do, Ruby doesn't)         │
    // │ • Returns 50% of bet to player                                      │
    // │                                                                      │
    // │ Side Effects:                                                        │
    // │ • Returns half bet to bankroll                                      │
    // │ • Immediately ends hand (no dealer play needed)                     │
    // │ • Transitions to result state                                       │
    // │                                                                      │
    // │ Phase 2 Note: Basic implementation here, dealer rules in Phase 3    │
    // └─────────────────────────────────────────────────────────────────────┘

    func surrender() {
        guard gameState == .playerTurn else {
            print("⚠️ Cannot surrender in \(gameState) state")
            return
        }

        let hand = playerHands[currentHandIndex]

        // Can only surrender as first action (2-card hand)
        guard hand.count == 2 else {
            print("⚠️ Cannot surrender - already took action")
            return
        }

        let bet = handBets[currentHandIndex]
        let refund = bet * 0.5

        bankroll += refund
        currentBet -= refund

        print("🏳️ Player surrenders - refunding $\(refund) (half of $\(bet))")

        resultMessage = "Surrendered - $\(formatCurrency(refund)) returned"
        gameState = .result
    }

    // ╔═══════════════════════════════════════════════════════════════════════════╗
    // ║ 🎰 DEALER TURN                                                             ║
    // ╚═══════════════════════════════════════════════════════════════════════════╝

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🤖 DEALER AI - Automated Dealer Play                                │
    // │                                                                      │
    // │ Business Logic: Dealer follows fixed rules (no decisions)           │
    // │ Standard Rules:                                                      │
    // │ • Reveal hole card                                                  │
    // │ • Hit on 16 or less                                                 │
    // │ • Stand on 17 or more                                               │
    // │                                                                      │
    // │ Dealer-Specific Variations (Phase 3):                               │
    // │ • Ruby: Stand on soft 17                                            │
    // │ • Shark: Hit on soft 17                                             │
    // │                                                                      │
    // │ Optimisation: If all player hands bust, dealer doesn't play         │
    // │ (house wins automatically)                                           │
    // │                                                                      │
    // │ Side Effects:                                                        │
    // │ • Reveals hole card                                                 │
    // │ • Deals cards to dealer until stand/bust                            │
    // │ • Transitions to result state                                       │
    // └─────────────────────────────────────────────────────────────────────┘

    private func playDealerHand() {
        guard gameState == .dealerTurn else {
            print("⚠️ Cannot play dealer hand in \(gameState) state")
            return
        }

        // Optimisation: If all player hands bust, dealer wins automatically
        let allPlayerHandsBust = playerHands.allSatisfy { $0.isBust }

        if allPlayerHandsBust {
            print("🎰 All player hands bust - dealer wins without playing")
            revealDealerHoleCard()
            evaluateResults()
            return
        }

        // Reveal hole card
        revealDealerHoleCard()

        print("🎰 Dealer plays: \(dealerHand.description)")

        // Dealer hits on 16 or less, stands on 17 or more
        // TODO Phase 3: Add soft 17 rule variations per dealer
        while dealerHand.total < 17 {
            guard let card = deckManager.dealCard() else {
                print("❌ No cards remaining for dealer")
                break
            }

            dealerHand.addCard(card)
            print("   Dealer hits: \(card.displayString) → \(dealerHand.description)")

            if dealerHand.isBust {
                print("   💥 Dealer busts with \(dealerHand.total)")
                break
            }
        }

        if !dealerHand.isBust {
            print("   ✋ Dealer stands on \(dealerHand.displayString)")
        }

        // Evaluate all results
        evaluateResults()
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🔓 REVEAL DEALER HOLE CARD                                           │
    // │                                                                      │
    // │ Business Logic: Flip dealer's hidden card face-up                   │
    // │ Called when: Dealer's turn begins or instant blackjack resolution   │
    // │                                                                      │
    // │ Side Effects:                                                        │
    // │ • Adds hole card to dealer's visible hand                           │
    // │ • Clears hole card property (no longer hidden)                      │
    // │ • Triggers flip animation in UI (Phase 2.8)                         │
    // └─────────────────────────────────────────────────────────────────────┘

    private func revealDealerHoleCard() {
        guard let holeCard = dealerHoleCard else {
            print("⚠️ No hole card to reveal")
            return
        }

        dealerHand.addCard(holeCard)
        print("🔓 Dealer reveals hole card: \(holeCard.displayString) → \(dealerHand.description)")

        // Clear hole card (no longer hidden)
        // Note: We keep the property for animation - UI checks gameState to show/hide
    }

    // ╔═══════════════════════════════════════════════════════════════════════════╗
    // ║ 🏆 RESULT EVALUATION & PAYOUT                                              ║
    // ╚═══════════════════════════════════════════════════════════════════════════╝

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🏆 EVALUATE RESULTS - Determine Winner & Calculate Payout           │
    // │                                                                      │
    // │ Business Logic: Compare each player hand to dealer hand             │
    // │                                                                      │
    // │ Win Conditions:                                                      │
    // │ • Player blackjack beats dealer 21: 3:2 payout                      │
    // │ • Player blackjack vs dealer blackjack: Push (return bet)           │
    // │ • Player total > dealer total (both ≤21): 1:1 payout                │
    // │ • Dealer bust, player ≤21: 1:1 payout                               │
    // │ • Player total = dealer total: Push (return bet)                    │
    // │ • Player bust: Lose (already deducted)                              │
    // │ • Dealer total > player total: Lose (already deducted)              │
    // │                                                                      │
    // │ Side Effects:                                                        │
    // │ • Updates bankroll with payouts                                     │
    // │ • Sets result message for UI                                        │
    // │ • Transitions to result state                                       │
    // │ • Checks for bankruptcy                                             │
    // └─────────────────────────────────────────────────────────────────────┘

    private func evaluateResults() {
        let dealerTotal = dealerHand.total
        let dealerBust = dealerHand.isBust

        var totalPayout: Double = 0
        var outcomes: [String] = []

        // Evaluate each player hand
        for (index, hand) in playerHands.enumerated() {
            let bet = handBets[index]
            let handNum = playerHands.count > 1 ? " (Hand \(index + 1))" : ""

            if hand.isBust {
                // Player bust - already lost bet
                outcomes.append("Bust\(handNum): -$\(formatCurrency(bet))")
                print("   Hand \(index + 1): Bust - lose $\(bet)")

            } else if dealerBust {
                // Dealer bust, player didn't - player wins 1:1
                let payout = bet * 2 // Return bet + winnings
                totalPayout += payout
                outcomes.append("Win\(handNum): +$\(formatCurrency(bet))")
                print("   Hand \(index + 1): Dealer bust - win $\(bet)")

            } else if hand.isBlackjack && !dealerHand.isBlackjack {
                // Player blackjack beats dealer 21 - pays 3:2
                let payout = bet * 2.5 // Return bet + 1.5x bet
                totalPayout += payout
                outcomes.append("Blackjack\(handNum): +$\(formatCurrency(payout - bet))")
                print("   Hand \(index + 1): Blackjack - win $\(payout - bet)")

            } else if hand.total > dealerTotal {
                // Player total higher - wins 1:1
                let payout = bet * 2
                totalPayout += payout
                outcomes.append("Win\(handNum): +$\(formatCurrency(bet))")
                print("   Hand \(index + 1): \(hand.total) > \(dealerTotal) - win $\(bet)")

            } else if hand.total == dealerTotal {
                // Push - return bet
                let payout = bet
                totalPayout += payout
                outcomes.append("Push\(handNum)")
                print("   Hand \(index + 1): \(hand.total) = \(dealerTotal) - push")

            } else {
                // Dealer wins
                outcomes.append("Lose\(handNum): -$\(formatCurrency(bet))")
                print("   Hand \(index + 1): \(hand.total) < \(dealerTotal) - lose $\(bet)")
            }
        }

        // Apply payouts to bankroll
        bankroll += totalPayout

        // Generate result message
        let netResult = totalPayout - currentBet
        if netResult > 0 {
            resultMessage = "You Win! +$\(formatCurrency(netResult))\n" + outcomes.joined(separator: "\n")
        } else if netResult == 0 {
            resultMessage = "Push - Bet Returned\n" + outcomes.joined(separator: "\n")
        } else {
            resultMessage = "Dealer Wins -$\(formatCurrency(-netResult))\n" + outcomes.joined(separator: "\n")
        }

        print("🏆 Results: \(resultMessage.replacingOccurrences(of: "\n", with: " | "))")
        print("💰 Bankroll: $\(bankroll)")

        // Check for bankruptcy
        if bankroll < minimumBet {
            print("💸 Bankrupt! Balance ($\(bankroll)) < minimum bet ($\(minimumBet))")
            gameState = .gameOver
        } else {
            gameState = .result
        }
    }

    // ╔═══════════════════════════════════════════════════════════════════════════╗
    // ║ 🔄 GAME FLOW CONTROL                                                       ║
    // ╚═══════════════════════════════════════════════════════════════════════════╝

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ ▶️ NEXT HAND - Start New Round                                       │
    // │                                                                      │
    // │ Business Logic: Reset for next hand, return to betting              │
    // │ Called when: Player taps "Next Hand" after result                   │
    // │                                                                      │
    // │ Side Effects:                                                        │
    // │ • Clears all hands                                                  │
    // │ • Resets current bet to 0                                           │
    // │ • Checks for reshuffle needs                                        │
    // │ • Returns to betting state                                          │
    // └─────────────────────────────────────────────────────────────────────┘

    func nextHand() {
        guard gameState == .result else {
            print("⚠️ Cannot start next hand from \(gameState) state")
            return
        }

        // Clear hands
        playerHands = [Hand()]
        dealerHand = Hand()
        dealerUpcard = nil
        dealerHoleCard = nil
        currentHandIndex = 0

        // Reset bets
        currentBet = 0
        handBets = []

        // Clear result message
        resultMessage = ""

        // Check for reshuffle
        if deckManager.needsReshuffle {
            print("♠️ Shuffle indicator - will reshuffle before next deal")
            needsReshuffle = true
        }

        print("▶️ Ready for next hand")
        gameState = .betting
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🔄 RESET BANKROLL - Bankruptcy Recovery                             │
    // │                                                                      │
    // │ Business Logic: Reset bankroll to starting amount                   │
    // │ Called when: Player bankrupt and confirms reset                     │
    // │                                                                      │
    // │ Side Effects:                                                        │
    // │ • Resets bankroll to starting amount (default $10,000)              │
    // │ • Returns to betting state                                          │
    // │ • Reshuffles deck for fresh start                                   │
    // └─────────────────────────────────────────────────────────────────────┘

    func resetBankroll(to amount: Double = 10000) {
        bankroll = amount
        lastBet = minimumBet

        // Clear any ongoing game
        playerHands = [Hand()]
        dealerHand = Hand()
        dealerUpcard = nil
        dealerHoleCard = nil
        currentHandIndex = 0
        currentBet = 0
        handBets = []
        resultMessage = ""

        // Fresh shoe
        deckManager.reshuffle()
        needsReshuffle = false

        print("🔄 Bankroll reset to $\(amount)")
        gameState = .betting
    }

    // ╔═══════════════════════════════════════════════════════════════════════════╗
    // ║ 🎯 COMPUTED PROPERTIES - Convenience Accessors                             ║
    // ╚═══════════════════════════════════════════════════════════════════════════╝

    /// Current active hand (for UI display)
    var currentHand: Hand {
        return playerHands[currentHandIndex]
    }

    /// Can player hit? (not bust, not stood, not 21)
    var canHit: Bool {
        return gameState == .playerTurn && !currentHand.isBust && currentHand.total < 21
    }

    /// Can player stand?
    var canStand: Bool {
        return gameState == .playerTurn && !currentHand.isBust
    }

    /// Can player double down?
    var canDoubleDown: Bool {
        return gameState == .playerTurn && currentHand.canDouble() && bankroll >= handBets[currentHandIndex]
    }

    /// Can player split?
    var canSplit: Bool {
        return gameState == .playerTurn &&
               currentHand.canSplit() &&
               playerHands.count < 4 &&
               bankroll >= handBets[currentHandIndex]
    }

    /// Can player surrender?
    var canSurrender: Bool {
        return gameState == .playerTurn && currentHand.count == 2 && playerHands.count == 1
    }

    // ╔═══════════════════════════════════════════════════════════════════════════╗
    // ║ 🛠️ UTILITY FUNCTIONS                                                       ║
    // ╚═══════════════════════════════════════════════════════════════════════════╝

    /// Format currency for display
    private func formatCurrency(_ amount: Double) -> String {
        return String(format: "%.2f", amount)
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 🎮 GAME STATE ENUMERATION                                                  ║
// ║                                                                            ║
// ║ Purpose: Defines all possible states in the game flow                     ║
// ║ Business Context: The game is a state machine. Each state determines      ║
// ║                   what UI is shown and what actions are available.        ║
// ║                                                                            ║
// ║ State Transitions:                                                         ║
// ║ .betting → .dealing → .playerTurn → .dealerTurn → .result → .betting     ║
// ║                                              ↓                             ║
// ║                                         .gameOver (if bankrupt)            ║
// ║                                                                            ║
// ║ UI Implications:                                                           ║
// ║ • .betting: Show betting slider and confirm button                        ║
// ║ • .dealing: Show card dealing animation                                   ║
// ║ • .playerTurn: Show action buttons (Hit, Stand, Double, Split)           ║
// ║ • .dealerTurn: Show dealer playing automatically                          ║
// ║ • .result: Show win/loss message and "Next Hand" button                   ║
// ║ • .gameOver: Show bankruptcy message and "Reset Bankroll" button          ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

enum GameState {
    case betting      // Player selects bet amount
    case dealing      // Cards being dealt (animation state)
    case playerTurn   // Player making decisions (Hit, Stand, Double, Split)
    case dealerTurn   // Dealer playing automatically
    case result       // Showing outcome and payout
    case gameOver     // Bankrupt - needs reset
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📖 USAGE EXAMPLES                                                          ║
// ║                                                                            ║
// ║ Create game view model:                                                    ║
// ║   let gameVM = GameViewModel(numberOfDecks: 6,                             ║
// ║                              startingBankroll: 10000,                     ║
// ║                              minimumBet: 10)                              ║
// ║                                                                            ║
// ║ Place a bet:                                                               ║
// ║   gameVM.placeBet(50.0)  // Automatically deals cards                     ║
// ║                                                                            ║
// ║ Player actions:                                                            ║
// ║   if gameVM.canHit {                                                       ║
// ║       gameVM.hit()                                                         ║
// ║   }                                                                        ║
// ║   if gameVM.canDoubleDown {                                               ║
// ║       gameVM.doubleDown()                                                 ║
// ║   }                                                                        ║
// ║   gameVM.stand()  // Triggers dealer play automatically                   ║
// ║                                                                            ║
// ║ Start next hand:                                                           ║
// ║   if gameVM.gameState == .result {                                        ║
// ║       gameVM.nextHand()  // Returns to betting                            ║
// ║   }                                                                        ║
// ║                                                                            ║
// ║ Handle bankruptcy:                                                         ║
// ║   if gameVM.gameState == .gameOver {                                      ║
// ║       gameVM.resetBankroll(to: 10000)                                     ║
// ║   }                                                                        ║
// ║                                                                            ║
// ║ In SwiftUI View:                                                           ║
// ║   @StateObject var viewModel = GameViewModel()                            ║
// ║                                                                            ║
// ║   var body: some View {                                                    ║
// ║       Text("Bankroll: $\(viewModel.bankroll)")                            ║
// ║       Button("Hit") {                                                      ║
// ║           viewModel.hit()                                                  ║
// ║       }                                                                    ║
// ║       .disabled(!viewModel.canHit)                                        ║
// ║   }                                                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
