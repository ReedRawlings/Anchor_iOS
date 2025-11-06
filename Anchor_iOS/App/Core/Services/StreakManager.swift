//
//  StreakManager.swift
//  Anchor_iOS
//
//  Stub implementation of streak manager
//

import Foundation
import Combine

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

