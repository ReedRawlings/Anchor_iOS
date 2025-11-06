//
//  Anchor_iOSApp.swift
//  Anchor_iOS
//
//  Created by Reed Rawlings on 11/5/25.
//

import SwiftUI

@main
struct Anchor_iOSApp: App {
    @StateObject private var services = ServiceContainer.createStub()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(services)
                .onOpenURL { url in
                    // TODO: Handle anchor://panic URL scheme
                    if url.scheme == "anchor" && url.host == "panic" {
                        // Navigate to panic flow
                    }
                }
        }
    }
}
