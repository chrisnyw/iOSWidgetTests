//
//  WidgetFeatureDetailViewModel.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

@Observable
final class WidgetFeatureDetailViewModel {
    let feature: WidgetFeature
    var appearance: WidgetAppearance
    var selectedFamily: WidgetFamilyOption = .small
    var showAddGuide = false

    // Interactive widget state
    var counterValue: Int = 0
    var isToggled: Bool = false

    // Configurable widget state
    var configStyle: WidgetDisplayStyle = .standard
    var configShowDate: Bool = true
    var configAccentColor: Color = .blue

    // Animated widget state
    var animatedValue: Int = 42

    private let store: WidgetDataStoring

    init(feature: WidgetFeature, store: WidgetDataStoring = WidgetDataStore.shared) {
        self.feature = feature
        self.store = store
        self.appearance = store.load(for: feature)
        self.counterValue = store.counter()
        self.isToggled = store.toggleState()

        if feature == .lockScreenWidget {
            selectedFamily = .accessoryCircular
        }
    }

    // MARK: - Color Bindings

    var backgroundColor: Color {
        get { Color(hex: appearance.backgroundColorHex) }
        set { appearance.backgroundColorHex = newValue.toHex() }
    }

    var textColor: Color {
        get { Color(hex: appearance.textColorHex) }
        set { appearance.textColorHex = newValue.toHex() }
    }

    // MARK: - Actions

    func save() {
        store.save(appearance: appearance, for: feature)
    }

    func incrementCounter() {
        counterValue = store.incrementCounter()
    }

    func toggleSwitch() {
        isToggled.toggle()
        store.setToggle(isToggled)
    }

    func randomizeAnimatedValue() {
        animatedValue = Int.random(in: 0...999)
    }
}
