//
//  WidgetFeatureDetailView.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI
import PhotosUI

struct WidgetFeatureDetailView: View {
    @Bindable var viewModel: WidgetFeatureDetailViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                previewSection
                familyPicker
                featureControlsSection
                if viewModel.feature.controls.textSection { textSection }
                if viewModel.feature.controls.appearanceSection { appearanceSection }
                if viewModel.feature.controls.iconPicker { iconPicker }
                descriptionSection
                addWidgetButton
            }
            .padding()
        }
        .mask {
            VStack(spacing: 0) {
                LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                    .frame(height: 12)
                Color.black
            }
        }
        .navigationTitle(viewModel.feature.title)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.appearance) {
            viewModel.save()
        }
        .sheet(isPresented: $viewModel.showAddGuide) {
            AddWidgetGuideView()
        }
    }

    // MARK: - Preview

    private var previewSection: some View {
        VStack(spacing: 12) {
            Text("Preview")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            WidgetPreviewView(viewModel: viewModel)
                .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Family Picker

    private var familyPicker: some View {
        VStack(spacing: 8) {
            Text("Widget Size")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Picker("Family", selection: $viewModel.selectedFamily) {
                ForEach(viewModel.feature.supportedFamilies) { family in
                    Text(family.rawValue).tag(family)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    // MARK: - Feature-Specific Controls

    @ViewBuilder
    private var featureControlsSection: some View {
        switch viewModel.feature {
        case .interactiveWidget:
            interactiveControls
        case .configurableWidget:
            configurableControls
        case .animatedWidget:
            animatedControls
        case .photoWidget:
            photoControls
        default:
            EmptyView()
        }
    }

    private var interactiveControls: some View {
        VStack(spacing: 12) {
            Text("Widget Controls")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                HStack {
                    Label("Counter", systemImage: "number")
                    Spacer()
                    Text("\(viewModel.counterValue)")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .contentTransition(.numericText())
                    Button {
                        withAnimation { viewModel.incrementCounter() }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .tint(.green)
                }

                Divider()

                HStack {
                    Label("Toggle", systemImage: "switch.2")
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { viewModel.isToggled },
                        set: { _ in viewModel.toggleSwitch() }
                    ))
                    .labelsHidden()
                }
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    private var configurableControls: some View {
        VStack(spacing: 12) {
            Text("Widget Configuration")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("These options mirror what users configure from the widget's edit screen via App Intents.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Display Style")
                        .font(.subheadline)
                    Picker("Style", selection: $viewModel.configStyle) {
                        ForEach(WidgetDisplayStyle.allCases) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Toggle("Show Date", isOn: $viewModel.configShowDate)

                ColorPicker("Accent Color", selection: $viewModel.configAccentColor)
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    private var animatedControls: some View {
        VStack(spacing: 12) {
            Text("Animation Preview")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                withAnimation { viewModel.randomizeAnimatedValue() }
            } label: {
                Label("Randomize Value", systemImage: "dice.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var photoControls: some View {
        VStack(spacing: 12) {
            Text("Photo")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            let hasPhoto = viewModel.photoData != nil

            PhotosPicker(
                selection: $viewModel.selectedPhotoItem,
                matching: .images
            ) {
                HStack {
                    Label(
                        hasPhoto ? "Change Photo" : "Select Photo",
                        systemImage: "photo.on.rectangle"
                    )
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .onChange(of: viewModel.selectedPhotoItem) {
                Task { await viewModel.loadSelectedPhoto() }
            }

            if viewModel.photoData != nil {
                Button(role: .destructive) {
                    viewModel.removePhoto()
                } label: {
                    Label("Remove Photo", systemImage: "trash")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.red, in: RoundedRectangle(cornerRadius: 14))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Text Controls

    private var textSection: some View {
        VStack(spacing: 12) {
            Text("Text")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 8) {
                if viewModel.feature.controls.title {
                    HStack {
                        Text("Title")
                            .frame(width: 70, alignment: .leading)
                        TextField("Title", text: $viewModel.appearance.title)
                            .textFieldStyle(.roundedBorder)
                    }
                }

                if viewModel.feature.controls.subtitleField {
                    HStack {
                        Text("Subtitle")
                            .frame(width: 70, alignment: .leading)
                        TextField("Subtitle", text: $viewModel.appearance.subtitle)
                            .textFieldStyle(.roundedBorder)
                    }
                }

                if viewModel.feature.controls.subtitleToggle {
                    Toggle("Show Subtitle", isOn: $viewModel.appearance.showSubtitle)
                }
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Appearance Controls

    private var appearanceSection: some View {
        VStack(spacing: 12) {
            Text("Appearance")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                if viewModel.feature.controls.backgroundColor {
                    ColorPicker("Background", selection: $viewModel.backgroundColor)
                }
                if viewModel.feature.controls.textColor {
                    ColorPicker("Text Color", selection: $viewModel.textColor)
                }
                if viewModel.feature.controls.showIcon {
                    Toggle("Show Icon", isOn: $viewModel.appearance.showIcon)
                }
                if viewModel.feature.controls.fontSize {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Font Size: \(Int(viewModel.appearance.fontSize))")
                        Slider(value: $viewModel.appearance.fontSize, in: 10...32, step: 1)
                    }
                }
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Icon Picker

    private var iconPicker: some View {
        VStack(spacing: 12) {
            Text("Icon")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 6),
                spacing: 12
            ) {
                ForEach(Self.iconOptions, id: \.self) { icon in
                    Button {
                        viewModel.appearance.iconName = icon
                    } label: {
                        Image(systemName: icon)
                            .font(.title3)
                            .frame(width: 44, height: 44)
                            .background(
                                viewModel.appearance.iconName == icon
                                    ? Color.accentColor.opacity(0.2)
                                    : Color.clear,
                                in: RoundedRectangle(cornerRadius: 8)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Description

    private var descriptionSection: some View {
        VStack(spacing: 8) {
            Text("About")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(viewModel.feature.featureDescription)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Add Widget Button

    private var addWidgetButton: some View {
        Button {
            viewModel.showAddGuide = true
        } label: {
            Label("Add Widget to Home Screen", systemImage: "plus.square.on.square")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue, in: RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(.white)
        }
    }

    // MARK: - Data

    private static let iconOptions = [
        "star.fill", "heart.fill", "bolt.fill", "flame.fill",
        "globe", "cloud.fill", "sun.max.fill", "moon.fill",
        "bell.fill", "tag.fill", "bookmark.fill", "flag.fill",
        "gift.fill", "cart.fill", "bag.fill", "creditcard.fill",
        "house.fill", "building.2.fill", "car.fill", "airplane",
        "clock.fill", "calendar", "envelope.fill", "phone.fill",
        "camera.fill", "photo.fill", "music.note", "gamecontroller.fill",
        "pawprint.fill", "leaf.fill",
    ]
}
