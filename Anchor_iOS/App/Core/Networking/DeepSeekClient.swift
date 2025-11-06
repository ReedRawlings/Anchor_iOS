//
//  DeepSeekClient.swift
//  Anchor_iOS
//
//  Stub implementation of DeepSeek API client
//

import Foundation

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

