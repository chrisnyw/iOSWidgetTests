//
//  TimelineWidget.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import WidgetKit
import SwiftUI

struct TimelineWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> TimelineWidgetEntry {
        TimelineWidgetEntry(date: .now, appearance: .defaultAppearance(), updateIndex: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (TimelineWidgetEntry) -> Void) {
        let appearance = WidgetDataStore.shared.load(for: .timelineWidget)
        completion(TimelineWidgetEntry(date: .now, appearance: appearance, updateIndex: 0))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TimelineWidgetEntry>) -> Void) {
        let appearance = WidgetDataStore.shared.load(for: .timelineWidget)
        var entries: [TimelineWidgetEntry] = []
        let now = Date.now

        for minuteOffset in 0..<60 {
            let date = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: now)!
            entries.append(TimelineWidgetEntry(date: date, appearance: appearance, updateIndex: minuteOffset))
        }

        completion(Timeline(entries: entries, policy: .atEnd))
    }
}

struct TimelineWidgetEntry: TimelineEntry {
    let date: Date
    let appearance: WidgetAppearance
    let updateIndex: Int
}

struct TimelineWidgetView: View {
    let entry: TimelineWidgetEntry

    var body: some View {
        TimelineContentView(appearance: entry.appearance, date: entry.date, updateIndex: entry.updateIndex)
            .foregroundStyle(Color(hex: entry.appearance.textColorHex))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .containerBackground(Color(hex: entry.appearance.backgroundColorHex), for: .widget)
    }
}

struct TimelineWidget: Widget {
    let kind = "TimelineWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TimelineWidgetProvider()) { entry in
            TimelineWidgetView(entry: entry)
                .widgetURL(WidgetFeature.timelineWidget.deepLinkURL)
        }
        .configurationDisplayName("Timeline Widget")
        .description("Auto-updating timeline entries")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
