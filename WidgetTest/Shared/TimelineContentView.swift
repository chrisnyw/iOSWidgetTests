//
//  TimelineContentView.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

struct TimelineContentView: View {
    let appearance: WidgetAppearance
    let date: Date
    let updateIndex: Int

    var body: some View {
        VStack(spacing: 6) {
            if appearance.showIcon {
                Image(systemName: "clock.arrow.2.circlepath")
                    .font(.system(size: appearance.fontSize * 1.5))
            }
            Text(appearance.title)
                .font(.system(size: appearance.fontSize, weight: .semibold))
            Text(date, style: .time)
                .font(.system(size: appearance.fontSize * 0.85))
                .contentTransition(.numericText())
            if appearance.showSubtitle {
                Text("Update #\(updateIndex)")
                    .font(.system(size: appearance.fontSize * 0.7))
                    .opacity(0.7)
            }
        }
    }
}
