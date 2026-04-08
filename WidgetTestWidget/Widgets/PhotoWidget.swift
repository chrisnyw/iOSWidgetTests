//
//  PhotoWidget.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import WidgetKit
import SwiftUI

// MARK: - Provider

struct PhotoWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> PhotoEntry {
        PhotoEntry(date: .now, appearance: .defaultAppearance(), imageData: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (PhotoEntry) -> Void) {
        let store = WidgetDataStore.shared
        completion(PhotoEntry(
            date: .now,
            appearance: store.load(for: .photoWidget),
            imageData: store.loadPhoto(for: .photoWidget)
        ))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PhotoEntry>) -> Void) {
        let store = WidgetDataStore.shared
        let appearance = store.load(for: .photoWidget)
        let imageData = store.loadPhoto(for: .photoWidget)
        print("🔄 [Widget] getTimeline - title: \(appearance.title), hasPhoto: \(imageData != nil), photoSize: \(imageData?.count ?? 0)")
        let entry = PhotoEntry(
            date: .now,
            appearance: appearance,
            imageData: imageData
        )
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct PhotoEntry: TimelineEntry {
    let date: Date
    let appearance: WidgetAppearance
    let imageData: Data?
}

// MARK: - View

struct PhotoWidgetView: View {
    let entry: PhotoEntry

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.date, style: .time)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                    Text(entry.appearance.title)
                        .font(.subheadline)
                }
                Spacer()
            }
            Spacer()
        }
        .foregroundStyle(.white)
        .shadow(color: .black.opacity(0.5), radius: 4, y: 2)
        .widgetURL(WidgetFeature.photoWidget.deepLinkURL)
        .containerBackground(for: .widget) {
            if let data = entry.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                LinearGradient(
                    colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .overlay {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.largeTitle)
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
        }
    }
}

// MARK: - Widget

struct PhotoWidget: Widget {
    let kind = "PhotoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PhotoWidgetProvider()) { entry in
            PhotoWidgetView(entry: entry)
        }
        .configurationDisplayName("Photo Widget")
        .description("Display a photo with time overlay")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
