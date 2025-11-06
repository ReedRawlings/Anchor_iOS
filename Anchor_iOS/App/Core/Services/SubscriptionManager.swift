//
//  SubscriptionManager.swift
//  Anchor_iOS
//
//  Stub implementation of subscription manager
//

import Foundation

@MainActor
class SubscriptionManager: SubscriptionManagerProtocol, ObservableObject {
    @Published var status: SubscriptionStatus = .free
    
    var isPremium: Bool {
        status == .premium || status == .trial
    }
    
    func checkSubscriptionStatus() async {
        // Stub: no-op
    }
    
    func startTrial() async -> Result<Void, Error> {
        status = .trial
        return .success(())
    }
}

