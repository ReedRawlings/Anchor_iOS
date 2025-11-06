//
//  UrgeLog.swift
//  Anchor_iOS
//
//  Domain model for urge log entry
//

import Foundation

struct UrgeLog {
    let id: String
    let timestamp: Date
    let triggers: [String]
    let notes: String?
    let wasRelapse: Bool
}

