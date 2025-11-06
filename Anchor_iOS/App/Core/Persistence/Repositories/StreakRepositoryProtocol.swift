//
//  StreakRepositoryProtocol.swift
//  Anchor_iOS
//
//  Protocol for streak repository
//

import Foundation

protocol StreakRepositoryProtocol {
    func getCurrentStreak() async -> Streak?
    func saveStreak(_ streak: Streak) async throws
    func updateStreak(_ streak: Streak) async throws
}

