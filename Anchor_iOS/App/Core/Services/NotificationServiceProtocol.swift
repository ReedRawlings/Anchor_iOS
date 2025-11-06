//
//  NotificationServiceProtocol.swift
//  Anchor_iOS
//
//  Protocol for notification management
//

import Foundation

protocol NotificationServiceProtocol {
    func requestAuthorization() async -> Bool
    func scheduleRiskTimeAlert(time: Date) async
    func scheduleMilestoneCelebration(day: Int) async
    func cancelAllNotifications() async
}

