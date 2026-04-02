//
//  WidgetFamilyOption.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

enum WidgetFamilyOption: String, CaseIterable, Identifiable, Sendable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
    case extraLarge = "Extra Large"
    case accessoryCircular = "Circular"
    case accessoryRectangular = "Rectangular"
    case accessoryInline = "Inline"

    var id: String { rawValue }

    var previewSize: CGSize {
        switch self {
        case .small: CGSize(width: 155, height: 155)
        case .medium: CGSize(width: 329, height: 155)
        case .large: CGSize(width: 329, height: 345)
        case .extraLarge: CGSize(width: 345, height: 345)
        case .accessoryCircular: CGSize(width: 76, height: 76)
        case .accessoryRectangular: CGSize(width: 172, height: 76)
        case .accessoryInline: CGSize(width: 234, height: 26)
        }
    }

    var isAccessory: Bool {
        switch self {
        case .accessoryCircular, .accessoryRectangular, .accessoryInline: true
        default: false
        }
    }

    static var homeScreenFamilies: [WidgetFamilyOption] {
        [.small, .medium, .large, .extraLarge]
    }

    static var lockScreenFamilies: [WidgetFamilyOption] {
        [.accessoryCircular, .accessoryRectangular, .accessoryInline]
    }
}
