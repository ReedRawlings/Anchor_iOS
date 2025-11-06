//
//  StreakManager.swift
//  Anchor_iOS
//
//  Consolidated streak manager (protocol + implementation)
//

import Foundation
import Combine

// MARK: - StreakManagerProtocol

protocol StreakManagerProtocol {
    var currentStreak: Int { get }
    var totalCleanDays: Int { get }

    func incrementStreak()
    func resetStreak()
    func addCleanDay()
}

// MARK: - StreakManager

@MainActor
class StreakManager: StreakManagerProtocol, ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var totalCleanDays: Int = 0

    func incrementStreak() {
        currentStreak += 1
    }

    func resetStreak() {
        currentStreak = 0
    }

    func addCleanDay() {
        totalCleanDays += 1
    }
}

