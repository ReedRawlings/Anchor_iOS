//
//  ServiceContainer.swift
//  Anchor_iOS
//
//  Dependency injection container for services
//

import Foundation
import Combine

@MainActor
class ServiceContainer: ObservableObject {
    let blockingService: BlockingServiceProtocol
    let streakManager: StreakManagerProtocol
    let aiCoachService: AICoachServiceProtocol
    let subscriptionManager: SubscriptionManagerProtocol
    let notificationService: NotificationServiceProtocol
    
    init(
        blockingService: BlockingServiceProtocol,
        streakManager: StreakManagerProtocol,
        aiCoachService: AICoachServiceProtocol,
        subscriptionManager: SubscriptionManagerProtocol,
        notificationService: NotificationServiceProtocol
    ) {
        self.blockingService = blockingService
        self.streakManager = streakManager
        self.aiCoachService = aiCoachService
        self.subscriptionManager = subscriptionManager
        self.notificationService = notificationService
    }
    
    // Convenience initializer with default stub implementations
    static func createStub() -> ServiceContainer {
        return ServiceContainer(
            blockingService: BlockingService(),
            streakManager: StreakManager(),
            aiCoachService: AICoachService(),
            subscriptionManager: SubscriptionManager(),
            notificationService: NotificationService()
        )
    }
}

