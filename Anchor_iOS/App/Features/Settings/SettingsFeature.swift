//
//  SettingsFeature.swift
//  Anchor_iOS
//
//  Consolidated Settings feature (ViewModel + View)
//

import Foundation
import SwiftUI
import Combine

// MARK: - SettingsViewModel

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var subscriptionStatus: SubscriptionStatus = .free

    private let services: ServiceContainer

    init(services: ServiceContainer) {
        self.services = services
        loadSettings()
    }

    func loadSettings() {
        subscriptionStatus = services.subscriptionManager.status
    }
}

// MARK: - SettingsView

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel

    init(services: ServiceContainer) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(services: services))
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    Text("Subscription: \(viewModel.subscriptionStatus)")
                }

                Section("Settings") {
                    Text("Settings options coming soon")
                }
            }
            .background(Color.primaryBg)
            .navigationTitle("Settings")
        }
    }
}
