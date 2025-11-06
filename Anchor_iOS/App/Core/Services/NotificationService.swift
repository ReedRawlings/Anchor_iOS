//
//  NotificationService.swift
//  Anchor_iOS
//
//  Stub implementation of notification service
//

import Foundation

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

