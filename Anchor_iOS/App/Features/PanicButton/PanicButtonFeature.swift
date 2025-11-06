//
//  PanicButtonFeature.swift
//  Anchor_iOS
//
//  Consolidated Panic Button feature (ViewModel + View)
//

import Foundation
import SwiftUI
import Combine

// MARK: - PanicButtonViewModel

@MainActor
class PanicButtonViewModel: ObservableObject {
    @Published var isActive: Bool = false
    @Published var currentStep: PanicStep = .breathing

    enum PanicStep {
        case breathing
        case actionSelection
        case actionExecution
    }

    enum PanicAction {
        case talkToAI
        case blockEverything
        case breathingExercise
        case physicalChallenge
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
}

// MARK: - PanicButtonView

struct PanicButtonView: View {
    @StateObject private var viewModel: PanicButtonViewModel

    init(services: ServiceContainer) {
        _viewModel = StateObject(wrappedValue: PanicButtonViewModel(services: services))
    }

    var body: some View {
        VStack {
            switch viewModel.currentStep {
            case .breathing:
                Text("Breathe")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)

            case .actionSelection:
                Text("What would help right now?")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.textPrimary)

            case .actionExecution:
                Text("Action in progress...")
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBg)
    }
}
