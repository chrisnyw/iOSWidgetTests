//
//  WidgetDisplayStyle.swift
//  WidgetTest
//
//  Created by Chris Ng on 2026-04-02.
//

import Foundation

enum WidgetDisplayStyle: String, CaseIterable, Identifiable, Sendable {
    case minimal = "Minimal"
    case standard = "Standard"
    case detailed = "Detailed"

    var id: String { rawValue }
}
