//
//  ConfigurableWidget.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import WidgetKit
import SwiftUI
import AppIntents

// MARK: - Configuration Intent

struct ConfigurableWidgetIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configure Widget"
    static var description: IntentDescription = "Customize what the widget displays"

    @Parameter(title: "Display Style", default: .standard)
    var style: ConfigWidgetStyle

    @Parameter(title: "Show Date", default: true)
    var showDate: Bool

    @Parameter(title: "Accent Color", default: .blue)
    var accentColor: ConfigWidgetColor
}

enum ConfigWidgetStyle: String, AppEnum {
    case minimal, standard, detailed

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Display Style"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .minimal: "Minimal",
        .standard: "Standard",
        .detailed: "Detailed",
    ]

    var displayStyle: WidgetDisplayStyle {
        switch self {
        case .minimal: .minimal
        case .standard: .standard
        case .detailed: .detailed
        }
    }
}

enum ConfigWidgetColor: String, AppEnum {
    case blue, green, purple, orange, red

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Color"
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .blue: "Blue",
        .green: "Green",
        .purple: "Purple",
        .orange: "Orange",
        .red: "Red",
    ]

    var color: Color {
        switch self {
        case .blue: .blue
        case .green: .green
        case .purple: .purple
        case .orange: .orange
        case .red: .red
        }
    }
}

// MARK: - Provider

struct ConfigurableWidgetProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> ConfigurableEntry {
        ConfigurableEntry(
            date: .now, style: .standard, showDate: true,
            accentColor: .blue, appearance: .defaultAppearance()
        )
    }

    func snapshot(for configuration: ConfigurableWidgetIntent, in context: Context) async -> ConfigurableEntry {
        let appearance = WidgetDataStore.shared.load(for: .configurableWidget)
        return ConfigurableEntry(
            date: .now, style: configuration.style.displayStyle,
            showDate: configuration.showDate,
            accentColor: configuration.accentColor.color,
            appearance: appearance
        )
    }

    func timeline(for configuration: ConfigurableWidgetIntent, in context: Context) async -> Timeline<ConfigurableEntry> {
        let appearance = WidgetDataStore.shared.load(for: .configurableWidget)
        let entry = ConfigurableEntry(
            date: .now, style: configuration.style.displayStyle,
            showDate: configuration.showDate,
            accentColor: configuration.accentColor.color,
            appearance: appearance
        )
        return Timeline(entries: [entry], policy: .never)
    }
}

struct ConfigurableEntry: TimelineEntry {
    let date: Date
    let style: WidgetDisplayStyle
    let showDate: Bool
    let accentColor: Color
    let appearance: WidgetAppearance
}

// MARK: - View

struct ConfigurableWidgetView: View {
    let entry: ConfigurableEntry

    var body: some View {
        ConfigurableContentView(
            appearance: entry.appearance,
            style: entry.style,
            showDate: entry.showDate,
            accentColor: entry.accentColor,
            date: entry.date
        )
        .foregroundStyle(Color(hex: entry.appearance.textColorHex))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(Color(hex: entry.appearance.backgroundColorHex), for: .widget)
    }
}

// MARK: - Widget

struct ConfigurableWidget: Widget {
    let kind = "ConfigurableWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurableWidgetIntent.self,
            provider: ConfigurableWidgetProvider()
        ) { entry in
            ConfigurableWidgetView(entry: entry)
                .widgetURL(WidgetFeature.configurableWidget.deepLinkURL)
        }
        .configurationDisplayName("Configurable Widget")
        .description("User-configurable via App Intents")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
