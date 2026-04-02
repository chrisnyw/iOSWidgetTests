//
//  AddWidgetGuideView.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

struct AddWidgetGuideView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Follow these steps to add the widget to your Home Screen:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    step(
                        1,
                        title: "Long-press on your Home Screen",
                        description: "Touch and hold an empty area until the apps start jiggling."
                    )
                    step(
                        2,
                        title: "Tap the Edit button",
                        description: "Tap \"Edit\" at the top left, then \"Add Widget\"."
                    )
                    step(
                        3,
                        title: "Search for WidgetTest",
                        description: "Type \"WidgetTest\" in the search bar or scroll to find it."
                    )
                    step(
                        4,
                        title: "Choose a widget",
                        description: "Swipe through available sizes and tap \"Add Widget\"."
                    )
                    step(
                        5,
                        title: "Position and confirm",
                        description: "Drag it to your preferred location and tap \"Done\"."
                    )
                }
                .padding()
            }
            .navigationTitle("Add Widget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func step(_ number: Int, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Text("\(number)")
                .font(.title2.bold())
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(.blue, in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
