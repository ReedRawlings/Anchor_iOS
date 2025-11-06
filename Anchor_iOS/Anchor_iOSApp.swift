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
    @StateObject private var onboardingState = OnboardingStateManager()
    @State private var showPanicFromDeepLink = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Main app content
                ContentView()
                    .environmentObject(services)
                    .onOpenURL { url in
                        // Handle anchor://panic URL scheme (for triple back-tap shortcut)
                        if url.scheme == "anchor" && url.host == "panic" {
                            showPanicFromDeepLink = true
                        }
                    }
                    .sheet(isPresented: $showPanicFromDeepLink) {
                        PanicButtonView(services: services)
                    }

                // Onboarding overlay - shows if not completed
                if !onboardingState.hasCompletedOnboarding {
                    OnboardingView(services: services)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .environmentObject(onboardingState)
        }
    }
}
