//
//  SettingsView.swift
//  Anchor_iOS
//
//  Settings view
//

import SwiftUI

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

