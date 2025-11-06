//
//  OnboardingViewModel.swift
//  Anchor_iOS
//
//  ViewModel for onboarding flow
//

import Foundation
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var hasCompletedOnboarding: Bool = false
    
    private let services: ServiceContainer
    
    init(services: ServiceContainer) {
        self.services = services
    }
    
    func nextStep() {
        if currentStep < 6 {
            currentStep += 1
        } else {
            hasCompletedOnboarding = true
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
}

