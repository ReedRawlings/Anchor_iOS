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
    @StateObject private var deeplinkHandler = DeeplinkHandler()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(services)
                .environmentObject(deeplinkHandler)
                .onOpenURL { url in
                    deeplinkHandler.handle(url)
                }
        }
    }
}

// MARK: - Deeplink Handler

@MainActor
class DeeplinkHandler: ObservableObject {
    @Published var shouldShowPanic = false
    @Published var shouldShowShortcutsSetup = false

    func handle(_ url: URL) {
        guard url.scheme == "anchor" else { return }

        switch url.host {
        case "panic":
            // Trigger panic flow
            shouldShowPanic = true

        case "shortcuts-setup":
            // Show shortcuts setup guide
            shouldShowShortcutsSetup = true

        default:
            print("Unknown deeplink: \(url)")
        }
    }

    func resetPanicTrigger() {
        shouldShowPanic = false
    }

    func resetShortcutsTrigger() {
        shouldShowShortcutsSetup = false
    }
}
