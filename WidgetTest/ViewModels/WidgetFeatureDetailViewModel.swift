//
//  WidgetFeatureDetailViewModel.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI
import PhotosUI

@Observable
@MainActor
final class WidgetFeatureDetailViewModel {
    let feature: WidgetFeature
    var appearance: WidgetAppearance
    var selectedFamily: WidgetFamilyOption = .small
    var showAddGuide = false

    // Interactive widget state
    var counterValue: Int = 0
    var isToggled: Bool = false

    // Configurable widget state
    var configStyle: WidgetDisplayStyle = .standard
    var configShowDate: Bool = true
    var configAccentColor: Color = .blue

    // Animated widget state
    var animatedValue: Int = 42

    // Photo widget state
    var selectedPhotoItem: PhotosPickerItem?
    var photoData: Data?

    private let store: WidgetDataStoring

    init(feature: WidgetFeature, store: WidgetDataStoring? = nil) {
        self.feature = feature
        self.store = store ?? WidgetDataStore.shared
        self.appearance = self.store.load(for: feature)
        self.counterValue = self.store.counter()
        self.isToggled = self.store.toggleState()
        self.photoData = self.store.loadPhoto(for: feature)

        if feature == .lockScreenWidget {
            selectedFamily = .accessoryCircular
        }
    }

    // MARK: - Color Bindings

    var backgroundColor: Color {
        get { Color(hex: appearance.backgroundColorHex) }
        set { appearance.backgroundColorHex = newValue.toHex() }
    }

    var textColor: Color {
        get { Color(hex: appearance.textColorHex) }
        set { appearance.textColorHex = newValue.toHex() }
    }

    // MARK: - Actions

    func save() {
        store.save(appearance: appearance, for: feature)
    }

    func incrementCounter() {
        counterValue = store.incrementCounter()
    }

    func toggleSwitch() {
        isToggled.toggle()
        store.setToggle(isToggled)
    }

    func randomizeAnimatedValue() {
        animatedValue = Int.random(in: 0...999)
    }

    func loadSelectedPhoto() async {
        guard let item = selectedPhotoItem else {
            print("❌ [Photo] No photo item selected")
            return
        }
        do {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                print("❌ [Photo] loadTransferable returned nil")
                return
            }
            print("✅ [Photo] Loaded raw data: \(data.count) bytes")
            guard let compressed = Self.compressForWidget(data) else {
                print("❌ [Photo] compressForWidget failed")
                return
            }
            print("✅ [Photo] Compressed: \(compressed.count) bytes")
            photoData = compressed
            store.savePhoto(compressed, for: feature)
            save()
            print("✅ [Photo] Saved to store and triggered widget reload")
        } catch {
            print("❌ [Photo] loadTransferable error: \(error)")
        }
    }

    func removePhoto() {
        photoData = nil
        selectedPhotoItem = nil
        store.removePhoto(for: feature)
        save()
    }

    private static func compressForWidget(_ data: Data) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        // Widget archival fails if total pixel area exceeds ~1M pixels.
        // Use pixel dimensions (points × scale) to calculate the actual area.
        let pixelWidth = image.size.width * image.scale
        let pixelHeight = image.size.height * image.scale
        let maxPixelArea: CGFloat = 1_000_000
        let currentArea = pixelWidth * pixelHeight
        let scale = currentArea > maxPixelArea ? sqrt(maxPixelArea / currentArea) : 1
        if scale < 1 {
            let newSize = CGSize(width: pixelWidth * scale, height: pixelHeight * scale)
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1.0
            let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
            let resized = renderer.image { _ in image.draw(in: CGRect(origin: .zero, size: newSize)) }
            return resized.jpegData(compressionQuality: 0.7)
        }
        return image.jpegData(compressionQuality: 0.7)
    }
}
