//
//  AnimatedContentView.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

struct AnimatedContentView: View {
    let appearance: WidgetAppearance
    let value: Int
    let date: Date

    var body: some View {
        VStack(spacing: 8) {
            if appearance.showIcon {
                Image(systemName: appearance.iconName)
                    .font(.largeTitle)
                    .symbolEffect(.pulse)
            }
            Text("\(value)")
                .font(.system(size: appearance.fontSize * 2, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
            Text(appearance.title)
                .font(.system(size: appearance.fontSize * 0.75))
            if appearance.showSubtitle {
                Text(date, style: .time)
                    .font(.caption2)
                    .opacity(0.7)
            }
        }
    }
}
