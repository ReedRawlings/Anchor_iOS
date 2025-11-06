//
//  AICoachViewModel.swift
//  Anchor_iOS
//
//  ViewModel for AI coach chat
//

import Foundation
import SwiftUI

@MainActor
class AICoachViewModel: ObservableObject {
    @Published var messages: [AIMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var remainingMessages: Int = 3
    @Published var isPanicMode: Bool = false
    
    private let services: ServiceContainer
    
    init(services: ServiceContainer, isPanicMode: Bool = false) {
        self.services = services
        self.isPanicMode = isPanicMode
        loadMessages()
    }
    
    func loadMessages() {
        Task {
            messages = await services.aiCoachService.getMessageHistory()
            remainingMessages = services.aiCoachService.getRemainingMessages()
        }
    }
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        guard !isLoading else { return }
        
        isLoading = true
        let userMessage = AIMessage(
            id: UUID().uuidString,
            role: "user",
            content: inputText,
            timestamp: Date()
        )
        messages.append(userMessage)
        let textToSend = inputText
        inputText = ""
        
        Task {
            let result = await services.aiCoachService.sendMessage(textToSend, isPanicMode: isPanicMode)
            await MainActor.run {
                isLoading = false
                switch result {
                case .success(let message):
                    messages.append(message)
                    remainingMessages = services.aiCoachService.getRemainingMessages()
                case .failure:
                    // TODO: Handle error
                    break
                }
            }
        }
    }
}

