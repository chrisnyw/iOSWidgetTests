//
//  PhotoContentView.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

struct PhotoContentView: View {
    let title: String
    let date: Date
    let imageData: Data?

    var body: some View {
        ZStack {
            photoBackground
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(date, style: .time)
                            .font(.system(.title2, design: .rounded, weight: .bold))
                        Text(title)
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding()

                Spacer()
            }
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.5), radius: 4, y: 2)
        }
    }

    @ViewBuilder
    private var photoBackground: some View {
        if let imageData, let uiImage = UIImage(data: imageData) {
            GeometryReader { geo in
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
        } else {
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.largeTitle)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }
}
