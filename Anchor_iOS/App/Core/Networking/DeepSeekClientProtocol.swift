//
//  DeepSeekClientProtocol.swift
//  Anchor_iOS
//
//  Protocol for DeepSeek API client
//

import Foundation

struct DeepSeekMessage {
    let role: String
    let content: String
}

struct DeepSeekResponse {
    let message: String
    let finishReason: String
}

enum DeepSeekError: Error {
    case invalidAPIKey
    case networkError(Error)
    case invalidResponse
    case rateLimitExceeded
}

protocol DeepSeekClientProtocol {
    func sendChatCompletion(
        messages: [DeepSeekMessage],
        systemPrompt: String
    ) async -> Result<DeepSeekResponse, DeepSeekError>
}

