//
//  WidgetFeature.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

enum WidgetFeature: String, CaseIterable, Identifiable, Hashable, Sendable {
    case staticWidget
    case timelineWidget
    case configurableWidget
    case interactiveWidget
    case deepLinkWidget
    case lockScreenWidget
    case animatedWidget
    case photoWidget

    var id: String { rawValue }

    var title: String {
        switch self {
        case .staticWidget: "Static Widget"
        case .timelineWidget: "Timeline Widget"
        case .configurableWidget: "Configurable Widget"
        case .interactiveWidget: "Interactive Widget"
        case .deepLinkWidget: "Deep Link Widget"
        case .lockScreenWidget: "Lock Screen Widget"
        case .animatedWidget: "Animated Widget"
        case .photoWidget: "Photo Widget"
        }
    }

    var subtitle: String {
        switch self {
        case .staticWidget: "Basic static content display"
        case .timelineWidget: "Auto-updating timeline entries"
        case .configurableWidget: "User-configurable via App Intents"
        case .interactiveWidget: "Buttons & toggles in widgets"
        case .deepLinkWidget: "Navigate to specific app screens"
        case .lockScreenWidget: "Accessory family widgets"
        case .animatedWidget: "Content transition animations"
        case .photoWidget: "Photo background with time overlay"
        }
    }

    var iconName: String {
        switch self {
        case .staticWidget: "square.text.square"
        case .timelineWidget: "clock.arrow.2.circlepath"
        case .configurableWidget: "gearshape.2"
        case .interactiveWidget: "hand.tap"
        case .deepLinkWidget: "link"
        case .lockScreenWidget: "lock.rectangle.on.rectangle"
        case .animatedWidget: "wand.and.stars"
        case .photoWidget: "photo.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .staticWidget: .blue
        case .timelineWidget: .orange
        case .configurableWidget: .purple
        case .interactiveWidget: .green
        case .deepLinkWidget: .red
        case .lockScreenWidget: .indigo
        case .animatedWidget: .pink
        case .photoWidget: .teal
        }
    }

    var widgetKind: String {
        switch self {
        case .staticWidget: "StaticWidget"
        case .timelineWidget: "TimelineWidget"
        case .configurableWidget: "ConfigurableWidget"
        case .interactiveWidget: "InteractiveWidget"
        case .deepLinkWidget: "DeepLinkWidget"
        case .lockScreenWidget: "LockScreenWidget"
        case .animatedWidget: "AnimatedWidget"
        case .photoWidget: "PhotoWidget"
        }
    }

    var deepLinkURL: URL {
        URL(string: "\(WidgetConstants.deepLinkScheme)://\(rawValue)")!
    }

    var featureDescription: String {
        switch self {
        case .staticWidget:
            "Tests StaticConfiguration widget. Displays static content that updates when the app writes new configuration data to the shared App Group."
        case .timelineWidget:
            "Tests TimelineProvider with scheduled entries. The widget creates multiple future timeline entries and automatically refreshes at each interval."
        case .configurableWidget:
            "Tests AppIntentConfiguration. Users can configure the widget directly from the widget edit screen using the App Intents framework."
        case .interactiveWidget:
            "Tests interactive controls (Button, Toggle) inside widgets. Actions execute via AppIntent without launching the app."
        case .deepLinkWidget:
            "Tests widgetURL and Link for deep linking. Tapping different areas of the widget navigates to specific screens in the app."
        case .lockScreenWidget:
            "Tests accessory widget families for the Lock Screen and StandBy: accessoryCircular, accessoryRectangular, and accessoryInline."
        case .animatedWidget:
            "Tests content transition animations in widgets. The widget animates between timeline entries using numericText and other transition styles."
        case .photoWidget:
            "Tests photo-based widgets. Select a photo from your album to display as the widget background with a live time and title overlay. Photo is shared via the App Group container."
        }
    }

    // MARK: - Supported Families

    var supportedFamilies: [WidgetFamilyOption] {
        switch self {
        case .staticWidget, .deepLinkWidget, .photoWidget:
            [.small, .medium, .large]
        case .timelineWidget, .configurableWidget, .interactiveWidget, .animatedWidget:
            [.small, .medium]
        case .lockScreenWidget:
            WidgetFamilyOption.lockScreenFamilies
        }
    }

    // MARK: - Control Visibility

    struct ControlVisibility {
        let title: Bool
        let subtitleField: Bool
        let subtitleToggle: Bool
        let backgroundColor: Bool
        let textColor: Bool
        let showIcon: Bool
        let fontSize: Bool
        let iconPicker: Bool

        var textSection: Bool { title || subtitleField || subtitleToggle }
        var appearanceSection: Bool { backgroundColor || textColor || showIcon || fontSize }
    }

    var controls: ControlVisibility {
        switch self {
        case .staticWidget:
            ControlVisibility(title: true, subtitleField: true, subtitleToggle: true, backgroundColor: true, textColor: true, showIcon: true, fontSize: true, iconPicker: true)
        case .timelineWidget:
            ControlVisibility(title: true, subtitleField: false, subtitleToggle: true, backgroundColor: true, textColor: true, showIcon: true, fontSize: true, iconPicker: false)
        case .configurableWidget:
            ControlVisibility(title: true, subtitleField: true, subtitleToggle: true, backgroundColor: true, textColor: true, showIcon: true, fontSize: true, iconPicker: true)
        case .interactiveWidget:
            ControlVisibility(title: false, subtitleField: false, subtitleToggle: false, backgroundColor: true, textColor: true, showIcon: false, fontSize: false, iconPicker: false)
        case .deepLinkWidget:
            ControlVisibility(title: true, subtitleField: false, subtitleToggle: false, backgroundColor: true, textColor: true, showIcon: false, fontSize: true, iconPicker: false)
        case .lockScreenWidget:
            ControlVisibility(title: true, subtitleField: true, subtitleToggle: true, backgroundColor: false, textColor: false, showIcon: false, fontSize: false, iconPicker: true)
        case .animatedWidget:
            ControlVisibility(title: true, subtitleField: false, subtitleToggle: true, backgroundColor: false, textColor: true, showIcon: true, fontSize: true, iconPicker: true)
        case .photoWidget:
            ControlVisibility(title: true, subtitleField: false, subtitleToggle: false, backgroundColor: false, textColor: false, showIcon: false, fontSize: false, iconPicker: false)
        }
    }
}
