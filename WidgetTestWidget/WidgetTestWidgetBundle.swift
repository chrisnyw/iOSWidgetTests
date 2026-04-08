//
//  WidgetTestWidgetBundle.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import WidgetKit
import SwiftUI

@main
struct WidgetTestWidgetBundle: WidgetBundle {
    var body: some Widget {
        StaticWidget()
        TimelineWidget()
        ConfigurableWidget()
        InteractiveWidget()
        DeepLinkWidget()
        LockScreenWidget()
        AnimatedWidget()
        PhotoWidget()
    }
}
