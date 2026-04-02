//
//  WidgetDataStore.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import Foundation
import WidgetKit

protocol WidgetDataStoring: Sendable {
    func save(appearance: WidgetAppearance, for feature: WidgetFeature)
    func load(for feature: WidgetFeature) -> WidgetAppearance
    func incrementCounter() -> Int
    func counter() -> Int
    func toggleState() -> Bool
    func setToggle(_ value: Bool)
}

final class WidgetDataStore: WidgetDataStoring, @unchecked Sendable {
    static let shared = WidgetDataStore()

    private let defaults: UserDefaults

    init(defaults: UserDefaults? = nil) {
        self.defaults = defaults ?? UserDefaults(suiteName: WidgetConstants.appGroupID) ?? .standard
    }

    // MARK: - Appearance

    func save(appearance: WidgetAppearance, for feature: WidgetFeature) {
        if let data = try? JSONEncoder().encode(appearance) {
            defaults.set(data, forKey: feature.widgetKind)
        }
        WidgetCenter.shared.reloadTimelines(ofKind: feature.widgetKind)
    }

    func load(for feature: WidgetFeature) -> WidgetAppearance {
        guard let data = defaults.data(forKey: feature.widgetKind),
              let appearance = try? JSONDecoder().decode(WidgetAppearance.self, from: data) else {
            return .defaultAppearance()
        }
        return appearance
    }

    // MARK: - Interactive Widget State

    func incrementCounter() -> Int {
        let current = defaults.integer(forKey: WidgetConstants.DefaultsKey.counter) + 1
        defaults.set(current, forKey: WidgetConstants.DefaultsKey.counter)
        return current
    }

    func counter() -> Int {
        defaults.integer(forKey: WidgetConstants.DefaultsKey.counter)
    }

    func toggleState() -> Bool {
        defaults.bool(forKey: WidgetConstants.DefaultsKey.toggle)
    }

    func setToggle(_ value: Bool) {
        defaults.set(value, forKey: WidgetConstants.DefaultsKey.toggle)
    }
}
