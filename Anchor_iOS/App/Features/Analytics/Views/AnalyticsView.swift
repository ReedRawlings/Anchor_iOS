//
//  AnalyticsView.swift
//  Anchor_iOS
//
//  Analytics and patterns view
//

import SwiftUI

struct AnalyticsView: View {
    @StateObject private var viewModel: AnalyticsViewModel
    
    init(services: ServiceContainer) {
        _viewModel = StateObject(wrappedValue: AnalyticsViewModel(services: services))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Analytics & Patterns")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Text("Calendar and pattern insights coming soon")
                    .foregroundColor(.textSecondary)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryBg)
            .navigationTitle("Analytics")
        }
    }
}

