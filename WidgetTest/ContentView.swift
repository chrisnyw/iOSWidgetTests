//
//  ContentView.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()

    var body: some View {
        WidgetFeatureListView(path: $path)
            .onOpenURL { url in
                guard url.scheme == WidgetConstants.deepLinkScheme,
                      let feature = WidgetFeature.allCases.first(where: { url.host == $0.rawValue })
                else { return }
                path = NavigationPath()
                path.append(feature)
            }
    }
}

#Preview {
    ContentView()
}
