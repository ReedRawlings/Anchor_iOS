//
//  SubscriptionManager.swift
//  Anchor_iOS
//
//  Consolidated subscription manager (enum + protocol + implementation)
//

import Foundation
import Combine

// MARK: - SubscriptionStatus

enum SubscriptionStatus {
    case free
    case premium
    case trial
}

// MARK: - SubscriptionManagerProtocol

protocol SubscriptionManagerProtocol {
    var status: SubscriptionStatus { get }
    var isPremium: Bool { get }

    func checkSubscriptionStatus() async
    func startTrial() async -> Result<Void, Error>
}

// MARK: - SubscriptionManager

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

