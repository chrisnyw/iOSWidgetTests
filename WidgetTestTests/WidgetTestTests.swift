//
//  WidgetTestTests.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import Testing
import SwiftUI
@testable import WidgetTest

// MARK: - WidgetAppearance Tests

struct WidgetAppearanceTests {

    @Test func defaultAppearance() {
        let appearance = WidgetAppearance.defaultAppearance()
        #expect(appearance.title == "Hello, Widget!")
        #expect(appearance.subtitle == "WidgetKit Demo")
        #expect(appearance.showSubtitle == true)
        #expect(appearance.showIcon == true)
        #expect(appearance.fontSize == 16)
    }

    @Test func encodingRoundTrip() throws {
        let original = WidgetAppearance(
            title: "Test", subtitle: "Sub",
            backgroundColorHex: "#FF0000", textColorHex: "#00FF00",
            iconName: "star", fontSize: 20,
            showSubtitle: false, showIcon: true
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(WidgetAppearance.self, from: data)
        #expect(original == decoded)
    }
}

// MARK: - WidgetFeature Tests

struct WidgetFeatureTests {

    @Test func allCasesHaveUniqueWidgetKinds() {
        let kinds = WidgetFeature.allCases.map(\.widgetKind)
        #expect(Set(kinds).count == kinds.count)
    }

    @Test func allCasesHaveUniqueRawValues() {
        let rawValues = WidgetFeature.allCases.map(\.rawValue)
        #expect(Set(rawValues).count == rawValues.count)
    }

    @Test func deepLinkURLsUseCorrectScheme() {
        for feature in WidgetFeature.allCases {
            #expect(feature.deepLinkURL.scheme == WidgetConstants.deepLinkScheme)
            #expect(feature.deepLinkURL.host == feature.rawValue)
        }
    }

    @Test func supportedFamiliesNonEmpty() {
        for feature in WidgetFeature.allCases {
            #expect(!feature.supportedFamilies.isEmpty)
        }
    }

    @Test func controlVisibilityConsistency() {
        // Interactive widget should show no text controls
        let interactive = WidgetFeature.interactiveWidget.controls
        #expect(!interactive.title)
        #expect(!interactive.subtitleField)
        #expect(!interactive.subtitleToggle)
        #expect(!interactive.textSection)

        // Lock screen should show no color/font controls
        let lockScreen = WidgetFeature.lockScreenWidget.controls
        #expect(!lockScreen.backgroundColor)
        #expect(!lockScreen.textColor)
        #expect(!lockScreen.fontSize)

        // Static should show everything
        let staticWidget = WidgetFeature.staticWidget.controls
        #expect(staticWidget.textSection)
        #expect(staticWidget.appearanceSection)
        #expect(staticWidget.iconPicker)

        // Photo widget should only show title, no appearance/icon
        let photo = WidgetFeature.photoWidget.controls
        #expect(photo.title)
        #expect(!photo.subtitleField)
        #expect(!photo.backgroundColor)
        #expect(!photo.iconPicker)
    }
}

// MARK: - WidgetDataStore Tests

struct WidgetDataStoreTests {

    private func makeStore() -> WidgetDataStore {
        let suiteName = "test.widgetdatastore.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        return WidgetDataStore(defaults: defaults)
    }

    @Test func saveAndLoadAppearance() {
        let store = makeStore()
        var appearance = WidgetAppearance.defaultAppearance()
        appearance.title = "Saved Title"
        appearance.backgroundColorHex = "#FF5500"

        store.save(appearance: appearance, for: .staticWidget)
        let loaded = store.load(for: .staticWidget)

        #expect(loaded.title == "Saved Title")
        #expect(loaded.backgroundColorHex == "#FF5500")
    }

    @Test func loadReturnsDefaultWhenEmpty() {
        let store = makeStore()
        let loaded = store.load(for: .staticWidget)
        #expect(loaded == WidgetAppearance.defaultAppearance())
    }

    @Test func counterIncrement() {
        let store = makeStore()
        #expect(store.counter() == 0)
        #expect(store.incrementCounter() == 1)
        #expect(store.incrementCounter() == 2)
        #expect(store.counter() == 2)
    }

    @Test func toggleState() {
        let store = makeStore()
        #expect(store.toggleState() == false)
        store.setToggle(true)
        #expect(store.toggleState() == true)
        store.setToggle(false)
        #expect(store.toggleState() == false)
    }

    @Test func separateFeatureAppearances() {
        let store = makeStore()
        var staticAppearance = WidgetAppearance.defaultAppearance()
        staticAppearance.title = "Static"
        var timelineAppearance = WidgetAppearance.defaultAppearance()
        timelineAppearance.title = "Timeline"

        store.save(appearance: staticAppearance, for: .staticWidget)
        store.save(appearance: timelineAppearance, for: .timelineWidget)

        #expect(store.load(for: .staticWidget).title == "Static")
        #expect(store.load(for: .timelineWidget).title == "Timeline")
    }
}

// MARK: - Color+Hex Tests

struct ColorHexTests {

    @Test func validHexParsing() {
        let color = Color(hex: "#FF0000")
        let hex = color.toHex()
        #expect(hex == "#FF0000")
    }

    @Test func hexWithoutHash() {
        let color = Color(hex: "00FF00")
        let hex = color.toHex()
        #expect(hex == "#00FF00")
    }

    @Test func shortHex() {
        let color = Color(hex: "#FFF")
        let hex = color.toHex()
        #expect(hex == "#FFFFFF")
    }
}

// MARK: - WidgetFamilyOption Tests

struct WidgetFamilyOptionTests {

    @Test func homeScreenFamiliesAreNotAccessory() {
        for family in WidgetFamilyOption.homeScreenFamilies {
            #expect(!family.isAccessory)
        }
    }

    @Test func lockScreenFamiliesAreAccessory() {
        for family in WidgetFamilyOption.lockScreenFamilies {
            #expect(family.isAccessory)
        }
    }

    @Test func previewSizesArePositive() {
        for family in WidgetFamilyOption.allCases {
            #expect(family.previewSize.width > 0)
            #expect(family.previewSize.height > 0)
        }
    }
}
