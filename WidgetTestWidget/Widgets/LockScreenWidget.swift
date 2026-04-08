//
//  LockScreenWidget.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import WidgetKit
import SwiftUI

// MARK: - Provider

struct LockScreenWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> LockScreenEntry {
        LockScreenEntry(date: .now, appearance: .defaultAppearance())
    }

    func getSnapshot(in context: Context, completion: @escaping (LockScreenEntry) -> Void) {
        completion(LockScreenEntry(date: .now, appearance: WidgetDataStore.shared.load(for: .lockScreenWidget)))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LockScreenEntry>) -> Void) {
        let entry = LockScreenEntry(date: .now, appearance: WidgetDataStore.shared.load(for: .lockScreenWidget))
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct LockScreenEntry: TimelineEntry {
    let date: Date
    let appearance: WidgetAppearance
}

// MARK: - Views

struct LockScreenWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    let entry: LockScreenEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                AccessoryCircularContentView(
                    iconName: entry.appearance.iconName,
                    title: entry.appearance.title
                )
            }
        case .accessoryRectangular:
            AccessoryRectangularContentView(
                iconName: entry.appearance.iconName,
                title: entry.appearance.title,
                subtitle: entry.appearance.subtitle,
                showSubtitle: entry.appearance.showSubtitle
            )
        case .accessoryInline:
            AccessoryInlineContentView(
                iconName: entry.appearance.iconName,
                title: entry.appearance.title
            )
        default:
            Text(entry.appearance.title)
        }
    }
}

// MARK: - Widget

struct LockScreenWidget: Widget {
    let kind = "LockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LockScreenWidgetProvider()) { entry in
            LockScreenWidgetEntryView(entry: entry)
                .widgetURL(WidgetFeature.lockScreenWidget.deepLinkURL)
        }
        .configurationDisplayName("Lock Screen Widget")
        .description("Accessory family widgets")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}
