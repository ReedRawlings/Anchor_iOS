//
//  AICoachService.swift
//  Anchor_iOS
//
//  Stub implementation of AI coach service
//

import Foundation

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

