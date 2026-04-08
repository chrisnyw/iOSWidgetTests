//
//  AnimatedWidget.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import WidgetKit
import SwiftUI

// MARK: - Provider

struct AnimatedWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> AnimatedEntry {
        AnimatedEntry(date: .now, value: 42, appearance: .defaultAppearance())
    }

    func getSnapshot(in context: Context, completion: @escaping (AnimatedEntry) -> Void) {
        completion(AnimatedEntry(date: .now, value: 42, appearance: WidgetDataStore.shared.load(for: .animatedWidget)))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AnimatedEntry>) -> Void) {
        let appearance = WidgetDataStore.shared.load(for: .animatedWidget)
        var entries: [AnimatedEntry] = []
        let now = Date.now

        for i in 0..<10 {
            let date = Calendar.current.date(byAdding: .second, value: i * 10, to: now)!
            entries.append(AnimatedEntry(date: date, value: Int.random(in: 0...999), appearance: appearance))
        }

        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct AnimatedEntry: TimelineEntry {
    let date: Date
    let value: Int
    let appearance: WidgetAppearance
}

// MARK: - View

struct AnimatedWidgetView: View {
    let entry: AnimatedEntry

    var body: some View {
        AnimatedContentView(appearance: entry.appearance, value: entry.value, date: entry.date)
            .foregroundStyle(Color(hex: entry.appearance.textColorHex))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .containerBackground(for: .widget) {
                LinearGradient(
                    colors: [
                        Color.fromString(String(entry.value)),
                        Color.fromString(String(entry.value) + ".end")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
    }
}

// MARK: - Widget

struct AnimatedWidget: Widget {
    let kind = "AnimatedWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AnimatedWidgetProvider()) { entry in
            AnimatedWidgetView(entry: entry)
                .widgetURL(WidgetFeature.animatedWidget.deepLinkURL)
        }
        .configurationDisplayName("Animated Widget")
        .description("Content transition animations")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
