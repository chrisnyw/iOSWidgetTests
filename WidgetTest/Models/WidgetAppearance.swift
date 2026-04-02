//
//  WidgetAppearance.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import Foundation

struct WidgetAppearance: Codable, Equatable, Sendable {
    var title: String
    var subtitle: String
    var backgroundColorHex: String
    var textColorHex: String
    var iconName: String
    var fontSize: Double
    var showSubtitle: Bool
    var showIcon: Bool

    static func defaultAppearance() -> WidgetAppearance {
        WidgetAppearance(
            title: "Hello, Widget!",
            subtitle: "WidgetKit Demo",
            backgroundColorHex: "#007AFF",
            textColorHex: "#FFFFFF",
            iconName: "star.fill",
            fontSize: 16,
            showSubtitle: true,
            showIcon: true
        )
    }
}
