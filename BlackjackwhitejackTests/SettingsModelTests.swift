//
//  SettingsModelTests.swift
//  BlackjackwhitejackTests
//
//  Created by Claude Code
//  Part of Phase 5: Settings & Customisation
//

import XCTest
@testable import Blackjackwhitejack

class SettingsModelTests: XCTestCase {

    // MARK: - UserSettings Tests

    func testDefaultSettings() {
        let settings = UserSettings.default

        XCTAssertTrue(settings.soundEffectsEnabled)
        XCTAssertEqual(settings.soundVolume, 0.7, accuracy: 0.01)
        XCTAssertEqual(settings.tableFeltColour, .classicGreen)
        XCTAssertEqual(settings.cardBackDesign, .classicRed)
        XCTAssertEqual(settings.animationSpeed, .normal)
        XCTAssertTrue(settings.hapticFeedbackEnabled)
        XCTAssertEqual(settings.defaultMinimumBet, 10.0)
        XCTAssertFalse(settings.autoStandOn21)
    }

    func testSettingsValidation() {
        var settings = UserSettings()

        // Test volume clamping
        settings.soundVolume = 1.5
        settings.validate()
        XCTAssertEqual(settings.soundVolume, 1.0, "Volume should be clamped to 1.0")

        settings.soundVolume = -0.5
        settings.validate()
        XCTAssertEqual(settings.soundVolume, 0.0, "Volume should be clamped to 0.0")

        // Test minimum bet clamping
        settings.defaultMinimumBet = 2000
        settings.validate()
        XCTAssertEqual(settings.defaultMinimumBet, 1000.0, "Min bet should be clamped to 1000")

        settings.defaultMinimumBet = 0.5
        settings.validate()
        XCTAssertEqual(settings.defaultMinimumBet, 1.0, "Min bet should be clamped to 1.0")
    }

    func testSettingsIsValid() {
        var settings = UserSettings()
        XCTAssertTrue(settings.isValid)

        settings.soundVolume = 1.5
        XCTAssertFalse(settings.isValid, "Settings with invalid volume should be invalid")

        settings.soundVolume = 0.5
        settings.defaultMinimumBet = 2000
        XCTAssertFalse(settings.isValid, "Settings with invalid bet should be invalid")
    }

    func testSettingsCodable() throws {
        let settings = UserSettings(
            soundVolume: 0.5,
            tableFeltColour: .royalBlue,
            animationSpeed: .fast,
            autoStandOn21: true
        )

        let encoded = try JSONEncoder().encode(settings)
        let decoded = try JSONDecoder().decode(UserSettings.self, from: encoded)

        XCTAssertEqual(decoded.soundVolume, 0.5, accuracy: 0.01)
        XCTAssertEqual(decoded.tableFeltColour, .royalBlue)
        XCTAssertEqual(decoded.animationSpeed, .fast)
        XCTAssertTrue(decoded.autoStandOn21)
    }

    func testResetToDefaults() {
        var settings = UserSettings()
        settings.soundVolume = 0.3
        settings.tableFeltColour = .navyBlue
        settings.autoStandOn21 = true

        settings.resetToDefaults()

        XCTAssertEqual(settings.soundVolume, 0.7, accuracy: 0.01)
        XCTAssertEqual(settings.tableFeltColour, .classicGreen)
        XCTAssertFalse(settings.autoStandOn21)
    }

    // MARK: - AnimationSpeed Tests

    func testAnimationSpeedDurations() {
        XCTAssertEqual(AnimationSpeed.slow.duration, 2.0)
        XCTAssertEqual(AnimationSpeed.normal.duration, 1.0)
        XCTAssertEqual(AnimationSpeed.fast.duration, 0.5)
        XCTAssertEqual(AnimationSpeed.instant.duration, 0.1)
    }

    // MARK: - TableFeltColour Tests

    func testTableFeltColourCases() {
        XCTAssertEqual(TableFeltColour.allCases.count, 6)
        XCTAssertTrue(TableFeltColour.allCases.contains(.classicGreen))
        XCTAssertTrue(TableFeltColour.allCases.contains(.royalBlue))
    }

    func testTableFeltColourCodable() throws {
        let colour = TableFeltColour.royalBlue
        let encoded = try JSONEncoder().encode(colour)
        let decoded = try JSONDecoder().decode(TableFeltColour.self, from: encoded)

        XCTAssertEqual(decoded, .royalBlue)
    }

    // MARK: - CardBackDesign Tests

    func testCardBackDesignCases() {
        XCTAssertEqual(CardBackDesign.allCases.count, 4)
        XCTAssertTrue(CardBackDesign.allCases.contains(.classicRed))
        XCTAssertTrue(CardBackDesign.allCases.contains(.goldPattern))
    }

    func testCardBackDesignCodable() throws {
        let design = CardBackDesign.goldPattern
        let encoded = try JSONEncoder().encode(design)
        let decoded = try JSONDecoder().decode(CardBackDesign.self, from: encoded)

        XCTAssertEqual(decoded, .goldPattern)
    }
}
