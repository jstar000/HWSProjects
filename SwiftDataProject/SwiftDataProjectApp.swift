//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by 임지성 on 5/15/24.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
