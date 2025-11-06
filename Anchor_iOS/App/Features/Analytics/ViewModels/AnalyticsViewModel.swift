//
//  AnalyticsViewModel.swift
//  Anchor_iOS
//
//  ViewModel for analytics and patterns
//

import Foundation
import SwiftUI
import Combine

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

