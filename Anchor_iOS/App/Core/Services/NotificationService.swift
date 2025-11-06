//
//  NotificationService.swift
//  Anchor_iOS
//
//  Consolidated notification service (protocol + implementation)
//

import Foundation
import UserNotifications

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
    private let notificationCenter = UNUserNotificationCenter.current()

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }

    func scheduleRiskTimeAlert(time: Date) async {
        let content = UNMutableNotificationContent()
        content.title = "Time for check-in"
        content.body = "Take a moment to check in with yourself"
        content.sound = .default

        // Create trigger based on time
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: "risk-time-alert-\(components.hour ?? 0)-\(components.minute ?? 0)",
            content: content,
            trigger: trigger
        )

        do {
            try await notificationCenter.add(request)
        } catch {
            print("Failed to schedule notification: \(error)")
        }
    }

    func scheduleMilestoneCelebration(day: Int) async {
        let content = UNMutableNotificationContent()
        content.title = "Milestone Reached!"
        content.body = "Congratulations on \(day) days clean!"
        content.sound = .default

        // Trigger immediately for now (in production, this would be based on actual streak)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(
            identifier: "milestone-\(day)",
            content: content,
            trigger: trigger
        )

        do {
            try await notificationCenter.add(request)
        } catch {
            print("Failed to schedule milestone notification: \(error)")
        }
    }

    func cancelAllNotifications() async {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
    }
}

