//
//  SubscriptionManagerProtocol.swift
//  Anchor_iOS
//
//  Protocol for subscription management
//

import Foundation

enum SubscriptionStatus {
    case free
    case premium
    case trial
}

protocol SubscriptionManagerProtocol {
    var status: SubscriptionStatus { get }
    var isPremium: Bool { get }
    
    func checkSubscriptionStatus() async
    func startTrial() async -> Result<Void, Error>
}

