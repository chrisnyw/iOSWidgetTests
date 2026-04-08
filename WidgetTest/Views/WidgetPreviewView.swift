//
//  WidgetPreviewView.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

struct WidgetPreviewView: View {
    let viewModel: WidgetFeatureDetailViewModel

    private var appearance: WidgetAppearance { viewModel.appearance }
    private var family: WidgetFamilyOption { viewModel.selectedFamily }

    var body: some View {
        Group {
            if family.isAccessory {
                accessoryPreview
            } else if viewModel.feature == .photoWidget {
                photoContent
                    .frame(
                        width: family.previewSize.width,
                        height: family.previewSize.height
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
            } else {
                widgetContent
                    .foregroundStyle(Color(hex: appearance.textColorHex))
                    .frame(
                        width: family.previewSize.width,
                        height: family.previewSize.height
                    )
                    .background(
                        widgetBackgroundStyle,
                        in: RoundedRectangle(cornerRadius: 22)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
            }
        }
        .animation(.smooth, value: appearance)
        .animation(.smooth, value: family)
    }

    // MARK: - Widget Content Router

    @ViewBuilder
    private var widgetContent: some View {
        switch viewModel.feature {
        case .staticWidget:
            StaticContentView(appearance: appearance)
        case .timelineWidget:
            TimelineContentView(appearance: appearance, date: .now, updateIndex: 0)
        case .configurableWidget:
            ConfigurableContentView(
                appearance: appearance,
                style: viewModel.configStyle,
                showDate: viewModel.configShowDate,
                accentColor: viewModel.configAccentColor,
                date: .now
            )
        case .interactiveWidget:
            interactiveContent
        case .deepLinkWidget:
            deepLinkContent
        case .lockScreenWidget:
            EmptyView()
        case .animatedWidget:
            AnimatedContentView(appearance: appearance, value: viewModel.animatedValue, date: .now)
        case .photoWidget:
            photoContent
        }
    }

    // MARK: - Interactive Widget (has widget-only Button/Toggle, can't fully share)

    @ViewBuilder
    private var interactiveContent: some View {
        if family == .medium {
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("Counter")
                        .font(.caption)
                        .opacity(0.7)
                    Text("\(viewModel.counterValue)")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .contentTransition(.numericText())
                    Label("Add", systemImage: "plus.circle.fill")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)

                Divider()

                VStack(spacing: 8) {
                    Text("Toggle")
                        .font(.caption)
                        .opacity(0.7)
                    Image(systemName: viewModel.isToggled ? "checkmark.circle.fill" : "circle")
                        .font(.title)
                        .foregroundStyle(viewModel.isToggled ? .green : .secondary)
                    Text(viewModel.isToggled ? "ON" : "OFF")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
            }
        } else {
            VStack(spacing: 8) {
                Text("\(viewModel.counterValue)")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .contentTransition(.numericText())
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
        }
    }

    // MARK: - Photo Widget

    private var photoContent: some View {
        PhotoContentView(
            title: appearance.title,
            date: .now,
            imageData: viewModel.photoData
        )
    }

    // MARK: - Deep Link Widget

    private var deepLinkContent: some View {
        DeepLinkGridContentView(
            appearance: appearance,
            style: family.deepLinkStyle
        )
    }

    // MARK: - Accessory Previews (Lock Screen)

    @ViewBuilder
    private var accessoryPreview: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                Circle().fill(.ultraThinMaterial)
                AccessoryCircularContentView(
                    iconName: appearance.iconName,
                    title: appearance.title
                )
            }
            .frame(width: family.previewSize.width, height: family.previewSize.height)
        case .accessoryRectangular:
            AccessoryRectangularContentView(
                iconName: appearance.iconName,
                title: appearance.title,
                subtitle: appearance.subtitle,
                showSubtitle: appearance.showSubtitle
            )
            .frame(width: family.previewSize.width, height: family.previewSize.height)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        case .accessoryInline:
            AccessoryInlineContentView(
                iconName: appearance.iconName,
                title: appearance.title
            )
            .font(.caption)
            .lineLimit(1)
            .frame(width: family.previewSize.width, height: family.previewSize.height)
            .background(.ultraThinMaterial, in: Capsule())
        default:
            EmptyView()
        }
    }
}

// MARK: - Helpers

private extension WidgetPreviewView {
    var widgetBackgroundStyle: AnyShapeStyle {
        if viewModel.feature == .animatedWidget {
            AnyShapeStyle(
                LinearGradient(
                    colors: [
                        Color.fromString(String(viewModel.animatedValue)),
                        Color.fromString(String(viewModel.animatedValue) + ".end")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        } else {
            AnyShapeStyle(Color(hex: appearance.backgroundColorHex))
        }
    }
}

private extension WidgetFamilyOption {
    var deepLinkStyle: DeepLinkGridStyle {
        switch self {
        case .small: .small
        case .large: .large
        default: .medium
        }
    }
}
