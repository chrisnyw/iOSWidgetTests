//
//  StaticWidget.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import WidgetKit
import SwiftUI

struct StaticWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> StaticEntry {
        StaticEntry(date: .now, appearance: .defaultAppearance())
    }

    func getSnapshot(in context: Context, completion: @escaping (StaticEntry) -> Void) {
        completion(StaticEntry(date: .now, appearance: WidgetDataStore.shared.load(for: .staticWidget)))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StaticEntry>) -> Void) {
        let appearance = WidgetDataStore.shared.load(for: .staticWidget)
        let entry = StaticEntry(date: .now, appearance: appearance)
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct StaticEntry: TimelineEntry {
    let date: Date
    let appearance: WidgetAppearance
}

struct StaticWidgetView: View {
    let entry: StaticEntry

    var body: some View {
        StaticContentView(appearance: entry.appearance)
            .foregroundStyle(Color(hex: entry.appearance.textColorHex))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .containerBackground(Color(hex: entry.appearance.backgroundColorHex), for: .widget)
    }
}

struct StaticWidget: Widget {
    let kind = "StaticWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StaticWidgetProvider()) { entry in
            StaticWidgetView(entry: entry)
                .widgetURL(WidgetFeature.staticWidget.deepLinkURL)
        }
        .configurationDisplayName("Static Widget")
        .description("Basic static content display")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
