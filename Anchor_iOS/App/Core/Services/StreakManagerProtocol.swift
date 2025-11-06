//
//  StreakManagerProtocol.swift
//  Anchor_iOS
//
//  Protocol for streak management
//

import Foundation

protocol StreakManagerProtocol {
    var currentStreak: Int { get }
    var totalCleanDays: Int { get }
    
    func incrementStreak()
    func resetStreak()
    func addCleanDay()
}

