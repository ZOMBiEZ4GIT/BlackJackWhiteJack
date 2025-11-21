//
//  GameView.swift
//  Natural - Modern Blackjack
//
//  Created by Claude Code
//  Part of Phase 1: Foundation Setup
//

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 🎮 GAME VIEW - Main Gameplay Screen                                       ║
// ║                                                                            ║
// ║ Purpose: The primary interface where blackjack gameplay happens           ║
// ║ Business Context: This is where players spend 95% of their time. It must  ║
// ║                   be clean, intuitive, and distraction-free.              ║
// ║                                                                            ║
// ║ Layout Structure:                                                          ║
// ║ • Top Bar: Bankroll display, dealer info, settings                        ║
// ║ • Dealer Area: Dealer's hand and avatar                                   ║
// ║ • Player Area: Player's hand(s)                                           ║
// ║ • Bottom: Action buttons (Hit, Stand, Double, Split)                      ║
// ║ • Swipe-up: Statistics panel                                              ║
// ║                                                                            ║
// ║ Phase 1: Basic structure and card display                                 ║
// ║ Phase 2: Will add full game logic and interactions                        ║
// ║                                                                            ║
// ║ Related Spec: See "Layout Structure" section, lines 306-323               ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import SwiftUI

struct GameView: View {

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 📊 STATE PROPERTIES                                                  │
    // │                                                                      │
    // │ For Phase 1, we're using placeholder state                          │
    // │ Phase 2 will replace this with GameViewModel                        │
    // └─────────────────────────────────────────────────────────────────────┘

    @State private var bankroll: Double = 10000
    @State private var currentBet: Double = 0

    // Placeholder hands for Phase 1 demo
    @State private var playerHand: Hand = Hand.from(["A♠", "K♥"])
    @State private var dealerHand: Hand = Hand.from(["10♦"])
    @State private var dealerHoleCard: Card? = Card(rank: .seven, suit: .clubs)

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🎨 BODY - Main Layout                                                │
    // └─────────────────────────────────────────────────────────────────────┘

    var body: some View {
        ZStack {
            // Background - Pure black per spec
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar with bankroll and controls
                topBar

                Spacer()

                // Dealer's area
                dealerArea

                Spacer()

                // Player's area
                playerArea

                Spacer()

                // Action buttons area (placeholder for Phase 2)
                actionButtonsArea

                // Swipe indicator
                swipeIndicator
            }
            .padding()
        }
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 📱 TOP BAR - Bankroll, Dealer Info, Settings                        │
    // │                                                                      │
    // │ Business Logic: Bankroll is always visible in large, readable       │
    // │ format. Gold gradient makes it feel valuable and important.         │
    // └─────────────────────────────────────────────────────────────────────┘

    private var topBar: some View {
        HStack {
            // Bankroll display - left side
            bankrollDisplay

            Spacer()

            // Dealer info button (Phase 2)
            Button(action: {}) {
                Image(systemName: "info.circle")
                    .font(.title2)
                    .foregroundColor(.info)
            }

            // Settings button
            Button(action: {}) {
                Image(systemName: "gearshape")
                    .font(.title2)
                    .foregroundColor(.mediumGrey)
            }
        }
        .padding(.top, 8)
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 💰 BANKROLL DISPLAY                                                  │
    // │                                                                      │
    // │ Business Logic: Shows current balance with gold gradient            │
    // │ Format: $10,250 (comma thousands separator, no decimals)            │
    // │ "AUD" label clarifies currency for Australian market                │
    // └─────────────────────────────────────────────────────────────────────┘

    private var bankrollDisplay: some View {
        HStack(spacing: 8) {
            // Chip icon
            Image(systemName: "dollarsign.circle.fill")
                .font(.title2)
                .foregroundStyle(Color.chipGradient)

            VStack(alignment: .leading, spacing: 2) {
                // Amount
                Text(formatCurrency(bankroll))
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.chipGradient)

                // Currency label
                Text("AUD")
                    .font(.caption)
                    .foregroundColor(.mediumGrey)
            }
        }
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🎴 DEALER AREA                                                       │
    // │                                                                      │
    // │ Business Logic: Shows dealer's cards and hand total                 │
    // │ During gameplay, one card is face-down (hole card)                  │
    // └─────────────────────────────────────────────────────────────────────┘

    private var dealerArea: some View {
        VStack(spacing: 12) {
            // "Dealer" label
            Text("Dealer")
                .font(.headline)
                .foregroundColor(.mediumGrey)

            // Dealer's cards
            HStack(spacing: -30) {
                // Visible card(s)
                ForEach(dealerHand.cards) { card in
                    CardView(card: card, size: .standard)
                }

                // Hole card (face down)
                if let holeCard = dealerHoleCard {
                    CardView(card: holeCard, isFaceDown: true, size: .standard)
                }
            }

            // Hand total (or "?" if hole card hidden)
            Text(dealerHoleCard != nil ? "?" : dealerHand.displayString)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🎴 PLAYER AREA                                                       │
    // │                                                                      │
    // │ Business Logic: Shows player's cards and hand total                 │
    // │ Highlights blackjack in gold, bust in red                           │
    // └─────────────────────────────────────────────────────────────────────┘

    private var playerArea: some View {
        VStack(spacing: 12) {
            // Hand total
            Text(playerHand.displayString)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(handTotalColor)

            // Player's cards
            HStack(spacing: -30) {
                ForEach(playerHand.cards) { card in
                    CardView(card: card, size: .standard)
                }
            }

            // "Your Hand" label
            Text("Your Hand")
                .font(.headline)
                .foregroundColor(.mediumGrey)
        }
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🎯 ACTION BUTTONS AREA                                               │
    // │                                                                      │
    // │ Placeholder for Phase 2 - will contain Hit, Stand, Double, Split    │
    // └─────────────────────────────────────────────────────────────────────┘

    private var actionButtonsArea: some View {
        HStack(spacing: 16) {
            // Placeholder buttons (Phase 2 will make these functional)
            actionButton(title: "Hit", color: .success)
            actionButton(title: "Stand", color: .info)
            actionButton(title: "Double", color: .warning)
        }
        .padding(.vertical, 20)
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🔼 SWIPE INDICATOR                                                   │
    // │                                                                      │
    // │ Visual cue that user can swipe up for statistics panel              │
    // └─────────────────────────────────────────────────────────────────────┘

    private var swipeIndicator: some View {
        VStack(spacing: 4) {
            Rectangle()
                .fill(Color.mediumGrey)
                .frame(width: 40, height: 4)
                .cornerRadius(2)

            Text("Swipe up for stats")
                .font(.caption2)
                .foregroundColor(.mediumGrey)
        }
        .padding(.bottom, 8)
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🎨 HELPER VIEWS                                                      │
    // └─────────────────────────────────────────────────────────────────────┘

    private func actionButton(title: String, color: Color) -> some View {
        Button(action: {}) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.darkGrey)
                .cornerRadius(12)
        }
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🧮 COMPUTED PROPERTIES                                               │
    // └─────────────────────────────────────────────────────────────────────┘

    /// Returns appropriate colour for hand total display
    private var handTotalColor: Color {
        if playerHand.isBlackjack {
            return .blackjackGlow
        } else if playerHand.isBust {
            return .bustHighlight
        } else if playerHand.isSoft {
            return .info
        } else {
            return .white
        }
    }

    // ┌─────────────────────────────────────────────────────────────────────┐
    // │ 🛠️ UTILITY FUNCTIONS                                                 │
    // └─────────────────────────────────────────────────────────────────────┘

    /// Formats currency with AUD symbol and comma separators
    /// Example: 10250 → "$10,250"
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 👁️ PREVIEW                                                                 ║
// ║                                                                            ║
// ║ Xcode preview for design iteration                                        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

#Preview("Game View - Blackjack") {
    GameView()
}

#Preview("Game View - Regular Hand") {
    var view = GameView()
    view.playerHand = Hand.from(["K♠", "9♥"])
    view.dealerHand = Hand.from(["A♦"])
    return view
}

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║ 📖 PHASE 2 TODO                                                            ║
// ║                                                                            ║
// ║ Next steps for this view:                                                 ║
// ║ • Replace @State with @StateObject GameViewModel                          ║
// ║ • Implement action button logic (Hit, Stand, Double, Split)               ║
// ║ • Add betting UI before each hand                                         ║
// ║ • Implement card dealing animations                                       ║
// ║ • Add dealer card flip animation for hole card reveal                     ║
// ║ • Implement swipe-up gesture for statistics panel                         ║
// ║ • Add win/loss result display with chip animation                         ║
// ║ • Handle multiple hands (after split)                                     ║
// ║ • Add dealer avatar display                                               ║
// ║ • Implement strategy hints (green/yellow pulses on buttons)               ║
// ╚═══════════════════════════════════════════════════════════════════════════╝
