//
//  Repositories.swift
//  Anchor_iOS
//
//  Consolidated repositories (all protocols + implementations)
//

import Foundation

// MARK: - StreakRepository

protocol StreakRepositoryProtocol {
    func getCurrentStreak() async -> Streak?
    func saveStreak(_ streak: Streak) async throws
    func updateStreak(_ streak: Streak) async throws
}

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

// MARK: - UrgeLogRepository

protocol UrgeLogRepositoryProtocol {
    func getAllLogs() async -> [UrgeLog]
    func getLogs(from startDate: Date, to endDate: Date) async -> [UrgeLog]
    func saveLog(_ log: UrgeLog) async throws
    func deleteLog(_ id: String) async throws
}

@MainActor
class UrgeLogRepository: UrgeLogRepositoryProtocol {
    private var logs: [UrgeLog] = []

    func getAllLogs() async -> [UrgeLog] {
        return logs
    }

    func getLogs(from startDate: Date, to endDate: Date) async -> [UrgeLog] {
        return logs.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
    }

    func saveLog(_ log: UrgeLog) async throws {
        logs.append(log)
    }

    func deleteLog(_ id: String) async throws {
        logs.removeAll { $0.id == id }
    }
}

// MARK: - PatternRepository

protocol PatternRepositoryProtocol {
    func getAllPatterns() async -> [Pattern]
    func getPatterns(ofType type: PatternType) async -> [Pattern]
    func savePattern(_ pattern: Pattern) async throws
    func deletePattern(_ id: String) async throws
}

@MainActor
class PatternRepository: PatternRepositoryProtocol {
    private var patterns: [Pattern] = []

    func getAllPatterns() async -> [Pattern] {
        return patterns
    }

    func getPatterns(ofType type: PatternType) async -> [Pattern] {
        return patterns.filter { $0.type == type }
    }

    func savePattern(_ pattern: Pattern) async throws {
        patterns.append(pattern)
    }

    func deletePattern(_ id: String) async throws {
        patterns.removeAll { $0.id == id }
    }
}
