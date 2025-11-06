//
//  AICoachServiceProtocol.swift
//  Anchor_iOS
//
//  Protocol for AI coach service
//

import Foundation

struct AIMessage: Identifiable {
    let id: String
    let role: String // "user" or "assistant"
    let content: String
    let timestamp: Date
}

enum AICoachError: Error {
    case rateLimitExceeded
    case networkError(Error)
    case invalidResponse
}

protocol AICoachServiceProtocol {
    func sendMessage(_ content: String, isPanicMode: Bool) async -> Result<AIMessage, AICoachError>
    func getMessageHistory() async -> [AIMessage]
    func getRemainingMessages() -> Int
}

