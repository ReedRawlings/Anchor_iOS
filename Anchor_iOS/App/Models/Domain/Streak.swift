//
//  Streak.swift
//  Anchor_iOS
//
//  Domain model for streak data
//

import Foundation

struct Streak {
    let id: String
    let currentStreak: Int
    let totalCleanDays: Int
    let lastUpdated: Date
}

