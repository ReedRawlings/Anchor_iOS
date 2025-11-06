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
    @Published var showShortcutsSetup = false

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
                    HStack {
                        Text("Subscription")
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text(viewModel.subscriptionStatus.description)
                            .foregroundColor(.textSecondary)
                    }
                }

                Section("Lock In") {
                    Button {
                        viewModel.showShortcutsSetup = true
                    } label: {
                        HStack {
                            Image(systemName: "hand.tap.fill")
                                .foregroundColor(.coralAlert)
                            Text("Setup Triple Back-Tap")
                                .foregroundColor(.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.textTertiary)
                        }
                    }
                }

                Section("App") {
                    NavigationLink {
                        Text("Notifications settings coming soon")
                            .foregroundColor(.textSecondary)
                    } label: {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.emerald)
                            Text("Notifications")
                                .foregroundColor(.textPrimary)
                        }
                    }

                    NavigationLink {
                        Text("Blocking settings coming soon")
                            .foregroundColor(.textSecondary)
                    } label: {
                        HStack {
                            Image(systemName: "shield.fill")
                                .foregroundColor(.emerald)
                            Text("Blocking")
                                .foregroundColor(.textPrimary)
                        }
                    }
                }

                Section("Data") {
                    Button {
                        // TODO: Export data
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.emerald)
                            Text("Export My Data")
                                .foregroundColor(.textPrimary)
                        }
                    }

                    Button(role: .destructive) {
                        // TODO: Delete account
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Account")
                        }
                    }
                }

                Section {
                    HStack {
                        Text("Version")
                            .foregroundColor(.textPrimary)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.primaryBg)
            .navigationTitle("Settings")
            .sheet(isPresented: $viewModel.showShortcutsSetup) {
                ShortcutsSetupView()
            }
        }
    }
}
