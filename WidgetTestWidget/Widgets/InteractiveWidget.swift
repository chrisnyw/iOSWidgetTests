//
//  InteractiveWidget.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import WidgetKit
import SwiftUI
import AppIntents

// MARK: - Intents

struct IncrementIntent: AppIntent {
    static var title: LocalizedStringResource = "Increment Counter"

    func perform() async throws -> some IntentResult {
        _ = WidgetDataStore.shared.incrementCounter()
        return .result()
    }
}

struct ToggleIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle State"

    @Parameter(title: "Value")
    var value: Bool

    init() {}

    init(value: Bool) {
        self.value = value
    }

    func perform() async throws -> some IntentResult {
        WidgetDataStore.shared.setToggle(value)
        return .result()
    }
}

// MARK: - Provider

struct InteractiveWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> InteractiveEntry {
        InteractiveEntry(date: .now, count: 0, isToggled: false, appearance: .defaultAppearance())
    }

    func getSnapshot(in context: Context, completion: @escaping (InteractiveEntry) -> Void) {
        let store = WidgetDataStore.shared
        completion(InteractiveEntry(
            date: .now,
            count: store.counter(),
            isToggled: store.toggleState(),
            appearance: store.load(for: .interactiveWidget)
        ))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<InteractiveEntry>) -> Void) {
        let store = WidgetDataStore.shared
        let entry = InteractiveEntry(
            date: .now,
            count: store.counter(),
            isToggled: store.toggleState(),
            appearance: store.load(for: .interactiveWidget)
        )
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct InteractiveEntry: TimelineEntry {
    let date: Date
    let count: Int
    let isToggled: Bool
    let appearance: WidgetAppearance
}

// MARK: - Views

struct InteractiveWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: InteractiveEntry

    var body: some View {
        Group {
            if family == .systemMedium {
                mediumLayout
            } else {
                smallLayout
            }
        }
        .foregroundStyle(Color(hex: entry.appearance.textColorHex))
        .containerBackground(Color(hex: entry.appearance.backgroundColorHex), for: .widget)
    }

    private var smallLayout: some View {
        VStack(spacing: 8) {
            Text("\(entry.count)")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .contentTransition(.numericText())

            Button(intent: IncrementIntent()) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
        }
    }

    private var mediumLayout: some View {
        HStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Counter")
                    .font(.caption)
                    .opacity(0.7)
                Text("\(entry.count)")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .contentTransition(.numericText())
                Button(intent: IncrementIntent()) {
                    Label("Add", systemImage: "plus.circle.fill")
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity)

            Divider()

            VStack(spacing: 8) {
                Text("Toggle")
                    .font(.caption)
                    .opacity(0.7)
                Image(systemName: entry.isToggled ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundStyle(entry.isToggled ? .green : .secondary)
                Toggle(
                    isOn: entry.isToggled,
                    intent: ToggleIntent(value: !entry.isToggled)
                ) {
                    Text(entry.isToggled ? "ON" : "OFF")
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Widget

struct InteractiveWidget: Widget {
    let kind = "InteractiveWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: InteractiveWidgetProvider()) { entry in
            InteractiveWidgetView(entry: entry)
                .widgetURL(WidgetFeature.interactiveWidget.deepLinkURL)
        }
        .configurationDisplayName("Interactive Widget")
        .description("Buttons & toggles in widgets")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
