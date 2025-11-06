//
//  OnboardingFeature.swift
//  Anchor_iOS
//
//  Consolidated Onboarding feature (ViewModel + View)
//

import Foundation
import SwiftUI
import Combine

// MARK: - OnboardingViewModel

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

// MARK: - OnboardingView

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel

    init(services: ServiceContainer) {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(services: services))
    }

    var body: some View {
        VStack {
            Text("Onboarding - Step \(viewModel.currentStep + 1)")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.textPrimary)

            Spacer()

            Button("Next") {
                viewModel.nextStep()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.primaryBg)
    }
}
