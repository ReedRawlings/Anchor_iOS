//
//  StreakRepository.swift
//  Anchor_iOS
//
//  In-memory implementation of streak repository
//

import Foundation

@MainActor
class StreakRepository: StreakRepositoryProtocol {
    private var currentStreak: Streak?
    
    func getCurrentStreak() async -> Streak? {
        return currentStreak
    }
    
    func saveStreak(_ streak: Streak) async throws {
        currentStreak = streak
    }
    
    func updateStreak(_ streak: Streak) async throws {
        currentStreak = streak
    }
}

