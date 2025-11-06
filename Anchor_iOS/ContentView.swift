//
//  ContentView.swift
//  Anchor_iOS
//
//  Created by Reed Rawlings on 11/5/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var services: ServiceContainer
    @EnvironmentObject var deeplinkHandler: DeeplinkHandler
    @StateObject private var onboardingState = OnboardingState.shared
    @State private var showPanicButton = false
    @State private var showShortcutsSetup = false

    var body: some View {
        Group {
            if onboardingState.hasCompletedOnboarding {
                // Main app content
                mainAppView
            } else {
                // Onboarding flow
                OnboardingView(services: services)
            }
        }
        .onChange(of: deeplinkHandler.shouldShowPanic) { newValue in
            if newValue {
                showPanicButton = true
                deeplinkHandler.resetPanicTrigger()
            }
        }
        .onChange(of: deeplinkHandler.shouldShowShortcutsSetup) { newValue in
            if newValue {
                showShortcutsSetup = true
                deeplinkHandler.resetShortcutsTrigger()
            }
        }
    }

    private var mainAppView: some View {
        NavigationStack {
            HomeView(services: services)
                .overlay(alignment: .bottomTrailing) {
                    // Panic button - floating, always accessible
                    Button {
                        showPanicButton = true
                    } label: {
                        Text("Panic")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.coralAlert)
                            .clipShape(Circle())
                            .shadow(color: Color.coralAlert.opacity(0.4), radius: 12, x: 0, y: 6)
                    }
                    .padding(CGFloat.spacingXL)
                    .sheet(isPresented: $showPanicButton) {
                        PanicButtonView(services: services)
                    }
                }
                .sheet(isPresented: $showShortcutsSetup) {
                    ShortcutsSetupView()
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ServiceContainer.createStub())
        .environmentObject(DeeplinkHandler())
}
