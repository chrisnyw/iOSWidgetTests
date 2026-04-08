//
//  DeepLinkWidget.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import WidgetKit
import SwiftUI

// MARK: - Provider

struct DeepLinkWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> DeepLinkEntry {
        DeepLinkEntry(date: .now, appearance: .defaultAppearance())
    }

    func getSnapshot(in context: Context, completion: @escaping (DeepLinkEntry) -> Void) {
        completion(DeepLinkEntry(date: .now, appearance: WidgetDataStore.shared.load(for: .deepLinkWidget)))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DeepLinkEntry>) -> Void) {
        let entry = DeepLinkEntry(date: .now, appearance: WidgetDataStore.shared.load(for: .deepLinkWidget))
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct DeepLinkEntry: TimelineEntry {
    let date: Date
    let appearance: WidgetAppearance
}

// MARK: - Views

struct DeepLinkWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: DeepLinkEntry

    private let features = Array(WidgetFeature.allCases.prefix(4))

    private var style: DeepLinkGridStyle {
        switch family {
        case .systemSmall: .small
        case .systemLarge: .large
        default: .medium
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(entry.appearance.title)
                .font(.system(size: entry.appearance.fontSize, weight: .semibold))

            let rows = features.chunked(into: style.columns)
            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                    GridRow {
                        ForEach(row, id: \.self) { feature in
                            Link(destination: feature.deepLinkURL) {
                                DeepLinkFeatureItemView(feature: feature, style: style)
                            }
                        }
                    }
                }
            }
        }
        .foregroundStyle(Color(hex: entry.appearance.textColorHex))
        .containerBackground(Color(hex: entry.appearance.backgroundColorHex), for: .widget)
    }
}

// MARK: - Widget

struct DeepLinkWidget: Widget {
    let kind = "DeepLinkWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DeepLinkWidgetProvider()) { entry in
            DeepLinkWidgetView(entry: entry)
                .widgetURL(WidgetFeature.deepLinkWidget.deepLinkURL)
        }
        .configurationDisplayName("Deep Link Widget")
        .description("Navigate to specific app screens")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
