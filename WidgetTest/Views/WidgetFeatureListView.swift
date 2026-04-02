//
//  WidgetFeatureListView.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

struct WidgetFeatureListView: View {
    @Binding var path: NavigationPath

    var body: some View {
        NavigationStack(path: $path) {
            List(WidgetFeature.allCases) { feature in
                NavigationLink(value: feature) {
                    FeatureRow(feature: feature)
                }
            }
            .navigationTitle("WidgetKit Tests")
            .navigationDestination(for: WidgetFeature.self) { feature in
                WidgetFeatureDetailView(
                    viewModel: WidgetFeatureDetailViewModel(feature: feature)
                )
            }
        }
    }
}

private struct FeatureRow: View {
    let feature: WidgetFeature

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: feature.iconName)
                .font(.title2)
                .foregroundStyle(feature.iconColor)
                .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(feature.title)
                    .font(.headline)
                Text(feature.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
