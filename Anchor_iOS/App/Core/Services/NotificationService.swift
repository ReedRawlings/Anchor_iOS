//
//  NotificationService.swift
//  Anchor_iOS
//
//  Consolidated notification service (protocol + implementation)
//

import Foundation

// MARK: - NotificationServiceProtocol

protocol NotificationServiceProtocol {
    func requestAuthorization() async -> Bool
    func scheduleRiskTimeAlert(time: Date) async
    func scheduleMilestoneCelebration(day: Int) async
    func cancelAllNotifications() async
}

// MARK: - NotificationService

@MainActor
class NotificationService: NotificationServiceProtocol {
    func requestAuthorization() async -> Bool {
        // Stub: return true
        return true
    }

    func scheduleRiskTimeAlert(time: Date) async {
        // Stub: no-op
    }

    func scheduleMilestoneCelebration(day: Int) async {
        // Stub: no-op
    }

    func cancelAllNotifications() async {
        // Stub: no-op
    }
}

