//
//  AccessoryContentViews.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

struct AccessoryCircularContentView: View {
    let iconName: String
    let title: String

    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: iconName)
                .font(.title3)
            Text(title)
                .font(.system(size: 9))
                .lineLimit(1)
        }
    }
}

struct AccessoryRectangularContentView: View {
    let iconName: String
    let title: String
    var subtitle: String = ""
    var showSubtitle: Bool = false

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title2)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                if showSubtitle {
                    Text(subtitle)
                        .font(.caption)
                        .lineLimit(1)
                }
            }
        }
    }
}

struct AccessoryInlineContentView: View {
    let iconName: String
    let title: String

    var body: some View {
        Label(title, systemImage: iconName)
    }
}
