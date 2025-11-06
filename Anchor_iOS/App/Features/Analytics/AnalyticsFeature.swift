//
//  AnalyticsFeature.swift
//  Anchor_iOS
//
//  Consolidated Analytics feature (ViewModel + View)
//

import Foundation
import SwiftUI
import Combine

// MARK: - AnalyticsViewModel

@MainActor
class AnalyticsViewModel: ObservableObject {
    @Published var selectedRange: AnalyticsRange = .sevenDays
    @Published var patterns: [Pattern] = []
    @Published var isLoading: Bool = false

    enum AnalyticsRange {
        case sevenDays
        case thirtyDays
        case ninetyDays
    }

    private let services: ServiceContainer

    init(services: ServiceContainer) {
        self.services = services
        loadPatterns()
    }

    func loadPatterns() {
        isLoading = true
        // TODO: Load patterns from repository
        isLoading = false
    }
}

// MARK: - AnalyticsView

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
