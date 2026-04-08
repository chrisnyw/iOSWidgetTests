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
    func savePhoto(_ data: Data, for feature: WidgetFeature)
    func loadPhoto(for feature: WidgetFeature) -> Data?
    func removePhoto(for feature: WidgetFeature)
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
            defaults.synchronize()
        }
        WidgetCenter.shared.reloadTimelines(ofKind: feature.widgetKind)
    }

    func load(for feature: WidgetFeature) -> WidgetAppearance {
        defaults.synchronize()
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
        defaults.synchronize()
        return current
    }

    func counter() -> Int {
        defaults.synchronize()
        return defaults.integer(forKey: WidgetConstants.DefaultsKey.counter)
    }

    func toggleState() -> Bool {
        defaults.synchronize()
        return defaults.bool(forKey: WidgetConstants.DefaultsKey.toggle)
    }

    func setToggle(_ value: Bool) {
        defaults.set(value, forKey: WidgetConstants.DefaultsKey.toggle)
        defaults.synchronize()
    }

    // MARK: - Photo Storage

    private func photoURL(for feature: WidgetFeature) -> URL? {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: WidgetConstants.appGroupID)?
            .appendingPathComponent("\(feature.widgetKind)_photo.jpg")
    }

    func savePhoto(_ data: Data, for feature: WidgetFeature) {
        if let url = photoURL(for: feature) {
            do {
                try data.write(to: url)
                print("✅ [Store] Photo saved to: \(url.path), size: \(data.count) bytes")
            } catch {
                print("❌ [Store] Failed to save photo: \(error)")
            }
        } else {
            print("❌ [Store] Could not get photo URL for App Group container")
        }
        WidgetCenter.shared.reloadTimelines(ofKind: feature.widgetKind)
    }

    func loadPhoto(for feature: WidgetFeature) -> Data? {
        guard let url = photoURL(for: feature) else {
            print("❌ [Store] Could not get photo URL for loading")
            return nil
        }
        let exists = FileManager.default.fileExists(atPath: url.path)
        print("📖 [Store] Loading photo from: \(url.path), exists: \(exists)")
        return try? Data(contentsOf: url)
    }

    func removePhoto(for feature: WidgetFeature) {
        if let url = photoURL(for: feature) {
            try? FileManager.default.removeItem(at: url)
        }
        WidgetCenter.shared.reloadTimelines(ofKind: feature.widgetKind)
    }
}
