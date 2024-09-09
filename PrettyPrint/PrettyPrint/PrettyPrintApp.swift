//
//  PrettyPrintApp.swift
//  PrettyPrint
//
//  Created by David Hernandez on 4/09/24.
//

import SwiftUI

@main
struct PrettyPrintApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [User.self, Friend.self]) //Include user and friend models
    }
}
