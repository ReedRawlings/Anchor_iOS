//
//  SettingsViewModel.swift
//  Anchor_iOS
//
//  ViewModel for settings
//

import Foundation
import SwiftUI
import Combine

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

