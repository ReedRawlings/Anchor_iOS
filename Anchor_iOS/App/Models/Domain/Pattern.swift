//
//  Pattern.swift
//  Anchor_iOS
//
//  Domain model for pattern analysis
//

import Foundation

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

