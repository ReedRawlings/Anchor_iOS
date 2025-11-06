//
//  DeepSeekClient.swift
//  Anchor_iOS
//
//  Consolidated DeepSeek client (models + errors + protocol + implementation)
//

import Foundation

// MARK: - DeepSeekMessage

struct DeepSeekMessage {
    let role: String
    let content: String
}

// MARK: - DeepSeekResponse

struct DeepSeekResponse {
    let message: String
    let finishReason: String
}

// MARK: - DeepSeekError

enum DeepSeekError: Error {
    case invalidAPIKey
    case networkError(Error)
    case invalidResponse
    case rateLimitExceeded
}

// MARK: - DeepSeekClientProtocol

protocol DeepSeekClientProtocol {
    func sendChatCompletion(
        messages: [DeepSeekMessage],
        systemPrompt: String
    ) async -> Result<DeepSeekResponse, DeepSeekError>
}

// MARK: - DeepSeekClient

@MainActor
class DeepSeekClient: DeepSeekClientProtocol {
    func sendChatCompletion(
        messages: [DeepSeekMessage],
        systemPrompt: String
    ) async -> Result<DeepSeekResponse, DeepSeekError> {
        // Stub: return mock response
        let response = DeepSeekResponse(
            message: "This is a stub response from DeepSeek client.",
            finishReason: "stop"
        )
        return .success(response)
    }
}

