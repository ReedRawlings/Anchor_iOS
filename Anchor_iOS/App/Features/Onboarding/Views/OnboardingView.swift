//
//  OnboardingView.swift
//  Anchor_iOS
//
//  Onboarding flow view - Coordinates all 7 onboarding screens
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showShortcutsGuide = false

    init(services: ServiceContainer) {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(services: services))
    }

    var body: some View {
        ZStack {
            // Background
            Color.primaryBg
                .ignoresSafeArea()

            // Current screen
            Group {
                switch viewModel.currentStep {
                case 0:
                    WelcomeScreen(onContinue: {
                        viewModel.nextStep()
                    })

                case 1:
                    GoalsTriggersScreen(
                        selectedGoals: $viewModel.selectedGoals,
                        selectedTriggers: $viewModel.selectedTriggers,
                        onContinue: {
                            viewModel.nextStep()
                        },
                        onBack: {
                            viewModel.previousStep()
                        }
                    )

                case 2:
                    SetGoalScreen(
                        recoveryIdentity: $viewModel.recoveryIdentity,
                        onContinue: {
                            viewModel.nextStep()
                        },
                        onBack: {
                            viewModel.previousStep()
                        }
                    )

                case 3:
                    ScreenTimePermissionScreen(
                        onContinue: {
                            viewModel.nextStep()
                        },
                        onBack: {
                            viewModel.previousStep()
                        }
                    )

                case 4:
                    NotificationPermissionScreen(
                        onContinue: {
                            viewModel.nextStep()
                        },
                        onBack: {
                            viewModel.previousStep()
                        }
                    )

                case 5:
                    PanicAIIntroScreen(
                        onContinue: {
                            viewModel.nextStep()
                        },
                        onBack: {
                            viewModel.previousStep()
                        }
                    )

                case 6:
                    TrialOfferScreen(
                        onStartTrial: {
                            viewModel.startTrial()
                            // Show shortcuts guide after onboarding
                            showShortcutsGuide = true
                        },
                        onContinueFree: {
                            viewModel.continueFree()
                            // Show shortcuts guide after onboarding
                            showShortcutsGuide = true
                        },
                        onBack: {
                            viewModel.previousStep()
                        }
                    )

                default:
                    EmptyView()
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))
            .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
        }
        .interactiveDismissDisabled() // Prevent swipe to dismiss
        .sheet(isPresented: $showShortcutsGuide, onDismiss: {
            // Dismiss the entire onboarding flow after shortcuts guide is shown
            dismiss()
        }) {
            ShortcutsSetupGuideView()
        }
    }
}

#Preview {
    OnboardingView(services: ServiceContainer.createStub())
}

