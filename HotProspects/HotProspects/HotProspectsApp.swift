//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by David Hernandez on 24/09/24.
//

import SwiftData
import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
