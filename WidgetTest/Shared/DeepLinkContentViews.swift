//
//  DeepLinkContentViews.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

struct DeepLinkGridStyle {
    var columns: Int = 4
    var iconFont: Font = .title3
    var textFont: Font = .system(size: 10)

    static let small = DeepLinkGridStyle(columns: 2, iconFont: .title3, textFont: .system(size: 10))
    static let medium = DeepLinkGridStyle(columns: 4, iconFont: .title3, textFont: .system(size: 10))
    static let large = DeepLinkGridStyle(columns: 2, iconFont: .title, textFont: .system(size: 12))
}

struct DeepLinkFeatureItemView: View {
    let feature: WidgetFeature
    var style: DeepLinkGridStyle = .medium

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: feature.iconName)
                .font(style.iconFont)
            Text(feature.title.components(separatedBy: " ").first ?? "")
                .font(style.textFont)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DeepLinkGridContentView: View {
    let appearance: WidgetAppearance
    var style: DeepLinkGridStyle = .medium

    private let features = Array(WidgetFeature.allCases.prefix(4))

    var body: some View {
        VStack(spacing: 8) {
            Text(appearance.title)
                .font(.system(size: appearance.fontSize, weight: .semibold))

            let rows = features.chunked(into: style.columns)
            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                    GridRow {
                        ForEach(row, id: \.self) { feature in
                            DeepLinkFeatureItemView(feature: feature, style: style)
                        }
                    }
                }
            }
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
