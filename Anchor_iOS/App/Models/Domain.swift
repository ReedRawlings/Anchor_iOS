//
//  Domain.swift
//  Anchor_iOS
//
//  Consolidated domain models
//

import Foundation

// MARK: - Streak

struct Streak {
    let id: String
    let currentStreak: Int
    let totalCleanDays: Int
    let lastUpdated: Date
}

// MARK: - UrgeLog

struct UrgeLog {
    let id: String
    let timestamp: Date
    let triggers: [String]
    let notes: String?
    let wasRelapse: Bool
}

// MARK: - Pattern

struct Pattern {
    let id: String
    let type: PatternType
    let value: String
    let confidence: Double
    let detectedAt: Date
}

enum PatternType {
    case timeOfDay
    case dayOfWeek
    case triggerCorrelation
    case moodCorrelation
}
