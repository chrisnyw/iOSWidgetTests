//
//  StaticContentView.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

struct StaticContentView: View {
    let appearance: WidgetAppearance

    var body: some View {
        VStack(spacing: 6) {
            if appearance.showIcon {
                Image(systemName: appearance.iconName)
                    .font(.system(size: appearance.fontSize * 1.5))
            }
            Text(appearance.title)
                .font(.system(size: appearance.fontSize, weight: .semibold))
                .lineLimit(2)
                .multilineTextAlignment(.center)
            if appearance.showSubtitle {
                Text(appearance.subtitle)
                    .font(.system(size: appearance.fontSize * 0.75))
                    .opacity(0.8)
            }
        }
    }
}
