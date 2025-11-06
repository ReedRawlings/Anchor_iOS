//
//  AICoachService.swift
//  Anchor_iOS
//
//  Consolidated AI coach service (model + errors + protocol + implementation)
//

import Foundation

// MARK: - AIMessage

struct AIMessage: Identifiable {
    let id: String
    let role: String // "user" or "assistant"
    let content: String
    let timestamp: Date
}

// MARK: - AICoachError

enum AICoachError: Error {
    case rateLimitExceeded
    case networkError(Error)
    case invalidResponse
}

// MARK: - AICoachServiceProtocol

protocol AICoachServiceProtocol {
    func sendMessage(_ content: String, isPanicMode: Bool) async -> Result<AIMessage, AICoachError>
    func getMessageHistory() async -> [AIMessage]
    func getRemainingMessages() -> Int
}

// MARK: - AICoachService

@MainActor
class AICoachService: AICoachServiceProtocol {
    private var messages: [AIMessage] = []
    private var messagesUsedToday: Int = 0
    private let maxFreeMessages = 3

    func sendMessage(_ content: String, isPanicMode: Bool) async -> Result<AIMessage, AICoachError> {
        // Stub: create a mock response
        let userMessage = AIMessage(
            id: UUID().uuidString,
            role: "user",
            content: content,
            timestamp: Date()
        )
        messages.append(userMessage)

        if !isPanicMode {
            messagesUsedToday += 1
            if messagesUsedToday > maxFreeMessages {
                return .failure(.rateLimitExceeded)
            }
        }

        let assistantMessage = AIMessage(
            id: UUID().uuidString,
            role: "assistant",
            content: "This is a stub response. AI integration coming soon.",
            timestamp: Date()
        )
        messages.append(assistantMessage)

        return .success(assistantMessage)
    }

    func getMessageHistory() async -> [AIMessage] {
        return messages
    }

    func getRemainingMessages() -> Int {
        return max(0, maxFreeMessages - messagesUsedToday)
    }
}

