//
//  PanicButtonViewModel.swift
//  Anchor_iOS
//
//  ViewModel for panic button flow
//

import Foundation
import SwiftUI

@MainActor
class PanicButtonViewModel: ObservableObject {
    @Published var isActive: Bool = false
    @Published var currentStep: PanicStep = .breathing
    
    enum PanicStep {
        case breathing
        case actionSelection
        case actionExecution
    }
    
    private let services: ServiceContainer
    
    init(services: ServiceContainer) {
        self.services = services
    }
    
    func activate() {
        isActive = true
        currentStep = .breathing
        // Auto-log urge in background
        Task {
            // TODO: Log urge automatically
        }
    }
    
    func proceedToActionSelection() {
        currentStep = .actionSelection
    }
    
    func selectAction(_ action: PanicAction) {
        currentStep = .actionExecution
        // TODO: Handle action
    }
    
    enum PanicAction {
        case talkToAI
        case blockEverything
        case breathingExercise
        case physicalChallenge
    }
}

