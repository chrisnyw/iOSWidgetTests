//
//  ConfigurableContentView.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

struct ConfigurableContentView: View {
    let appearance: WidgetAppearance
    let style: WidgetDisplayStyle
    let showDate: Bool
    let accentColor: Color
    let date: Date

    var body: some View {
        VStack(spacing: 8) {
            if appearance.showIcon {
                Image(systemName: appearance.iconName)
                    .font(.title2)
                    .foregroundStyle(accentColor)
            }

            switch style {
            case .minimal:
                Text(appearance.title)
                    .font(.system(size: appearance.fontSize, weight: .semibold))
            case .standard:
                VStack(spacing: 4) {
                    Text(appearance.title)
                        .font(.system(size: appearance.fontSize, weight: .semibold))
                    if showDate {
                        Text(date, style: .date)
                            .font(.caption)
                    }
                }
            case .detailed:
                VStack(spacing: 4) {
                    Text(appearance.title)
                        .font(.system(size: appearance.fontSize, weight: .semibold))
                    if appearance.showSubtitle {
                        Text(appearance.subtitle)
                            .font(.system(size: appearance.fontSize * 0.75))
                    }
                    if showDate {
                        Text(date, style: .date)
                            .font(.caption)
                        Text(date, style: .time)
                            .font(.caption2)
                    }
                }
            }
        }
    }
}
