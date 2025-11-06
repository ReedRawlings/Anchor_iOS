//
//  OnboardingView.swift
//  Anchor_iOS
//
//  Onboarding flow view
//

import SwiftUI

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

