//
//  HomeView.swift
//  Anchor_iOS
//
//  Home dashboard view
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(services: ServiceContainer) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(services: services))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: CGFloat.spacingXXL) {
                    // Hero stats
                    GlassCard {
                        VStack(alignment: .leading, spacing: CGFloat.spacingMD) {
                            Text("Current Streak")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            Text("\(viewModel.currentStreak)")
                                .font(.system(size: 48, weight: .semibold, design: .monospaced))
                                .foregroundColor(.emerald)
                        }
                    }
                    
                    // Quick actions placeholder
                    Text("Quick Actions - Coming Soon")
                        .foregroundColor(.textSecondary)
                }
                .padding(CGFloat.spacingXL)
            }
            .background(Color.primaryBg)
            .navigationTitle("Anchor")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Settings") {
                        SettingsView(services: ServiceContainer.createStub())
                    }
                }
            }
        }
    }
}

