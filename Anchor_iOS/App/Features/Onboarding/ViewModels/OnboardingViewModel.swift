//
//  OnboardingViewModel.swift
//  Anchor_iOS
//
//  ViewModel for onboarding flow
//

import Foundation
import SwiftUI
import Combine

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var selectedGoals: [String] = []
    @Published var selectedTriggers: [String] = []
    @Published var recoveryIdentity: String = ""

    private let services: ServiceContainer
    let stateManager: OnboardingStateManager

    // Total number of steps (0-6 = 7 screens)
    let totalSteps = 7

    init(services: ServiceContainer) {
        self.services = services
        self.stateManager = OnboardingStateManager()
    }

    func nextStep() {
        if currentStep < totalSteps - 1 {
            currentStep += 1
        } else {
            completeOnboarding()
        }
    }

    func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }

    func completeOnboarding() {
        // Save all selections to state manager
        stateManager.selectedGoals = selectedGoals
        stateManager.selectedTriggers = selectedTriggers
        stateManager.recoveryIdentity = recoveryIdentity

        // Mark onboarding as completed
        stateManager.completeOnboarding()
    }

    func startTrial() {
        // TODO: Integrate with StoreKit for trial subscription
        // For now, just complete onboarding
        completeOnboarding()
    }

    func continueFree() {
        // Complete onboarding without starting trial
        completeOnboarding()
    }
}

