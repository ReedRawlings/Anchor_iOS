//
//  PanicButtonFeature.swift
//  Anchor_iOS
//
//  Consolidated Lock In feature (ViewModel + View)
//  (File kept as PanicButton for backward compatibility with URL scheme)
//

import Foundation
import SwiftUI
import Combine

// MARK: - LockInViewModel

@MainActor
class LockInViewModel: ObservableObject {
    @Published var currentStep: LockInStep = .breathing
    @Published var selectedAction: LockInAction?
    @Published var breathingProgress: Double = 0
    @Published var showDurationPicker = false
    @Published var blockDuration: TimeInterval = 3600 // 1 hour default
    @Published var breathingTimer: Int = 0

    enum LockInStep {
        case breathing
        case actionSelection
        case actionExecution
    }

    enum LockInAction {
        case talkToAI
        case blockEverything
        case breathingExercise
        case physicalChallenge
    }

    private let services: ServiceContainer
    private var breathingAnimationTimer: Timer?
    private var breathingCountdownTimer: Timer?

    init(services: ServiceContainer) {
        self.services = services
        startBreathing()
        logUrgeAutomatically()
    }

    private func startBreathing() {
        currentStep = .breathing
        breathingProgress = 0

        // 10-second animation
        breathingAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            Task { @MainActor in
                self.breathingProgress += 0.005 // 0.005 * 200 = 1.0 over 10 seconds
                if self.breathingProgress >= 1.0 {
                    timer.invalidate()
                    self.proceedToActionSelection()
                }
            }
        }
    }

    private func logUrgeAutomatically() {
        Task {
            // Auto-log urge in background
            let log = UrgeLog(
                id: UUID().uuidString,
                timestamp: Date(),
                triggers: ["Lock In Activated"],
                notes: "Lock In button was triggered",
                wasRelapse: false
            )
            // TODO: Save to persistence when implemented
            print("Auto-logged urge: \(log.id)")
        }
    }

    func proceedToActionSelection() {
        currentStep = .actionSelection
    }

    func selectAction(_ action: LockInAction) {
        selectedAction = action
        currentStep = .actionExecution
    }

    func backToActionSelection() {
        currentStep = .actionSelection
        selectedAction = nil
        breathingTimer = 0
    }

    func startBreathingExercise() {
        breathingTimer = 120 // 2 minutes
        breathingCountdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            Task { @MainActor in
                if self.breathingTimer > 0 {
                    self.breathingTimer -= 1
                } else {
                    timer.invalidate()
                }
            }
        }
    }

    func applyBlockEverything() {
        Task {
            // Block all apps for selected duration
            let result = await services.blockingService.blockApps(["all"], duration: blockDuration)
            switch result {
            case .success:
                print("Block applied for \(blockDuration) seconds")
            case .failure(let error):
                print("Block failed: \(error)")
            }
        }
    }

    deinit {
        breathingAnimationTimer?.invalidate()
        breathingCountdownTimer?.invalidate()
    }
}

// MARK: - PanicButtonView (Main Entry Point)

struct PanicButtonView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: LockInViewModel

    init(services: ServiceContainer) {
        _viewModel = StateObject(wrappedValue: LockInViewModel(services: services))
    }

    var body: some View {
        Group {
            switch viewModel.currentStep {
            case .breathing:
                LockInBreathingView(progress: viewModel.breathingProgress)

            case .actionSelection:
                LockInActionsView(viewModel: viewModel)

            case .actionExecution:
                if let action = viewModel.selectedAction {
                    LockInActionExecutionView(
                        viewModel: viewModel,
                        action: action,
                        onDismiss: { dismiss() }
                    )
                }
            }
        }
        .interactiveDismissDisabled(viewModel.currentStep == .breathing)
    }
}

// MARK: - LockInBreathingView

struct LockInBreathingView: View {
    let progress: Double

    var body: some View {
        ZStack {
            Color.primaryBg.ignoresSafeArea()

            VStack(spacing: CGFloat.spacingXXXL) {
                Spacer()

                // Breathing circle animation
                ZStack {
                    // Outer pulsing circle
                    Circle()
                        .fill(Color.emerald.opacity(0.2))
                        .frame(width: 250 + (progress * 50), height: 250 + (progress * 50))
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: progress)

                    // Inner breathing circle
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.emerald, Color.emerald.opacity(0.6)],
                                center: .center,
                                startRadius: 50,
                                endRadius: 125
                            )
                        )
                        .frame(width: 200, height: 200)
                        .scaleEffect(0.8 + (progress * 0.4))
                        .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: progress)
                }

                VStack(spacing: CGFloat.spacingMD) {
                    Text("Lock In")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.textPrimary)

                    Text("Take a deep breath")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.textSecondary)

                    Text("You're in control")
                        .font(.system(size: 16))
                        .foregroundColor(.textTertiary)
                }

                Spacer()

                // Progress indicator
                VStack(spacing: CGFloat.spacingSM) {
                    ProgressView(value: progress)
                        .tint(.emerald)
                        .frame(width: 200)

                    Text("\(Int(progress * 10))s")
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundColor(.textSecondary)
                }
                .padding(.bottom, CGFloat.spacingXXXL)
            }
        }
    }
}

// MARK: - LockInActionsView

struct LockInActionsView: View {
    @ObservedObject var viewModel: LockInViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.primaryBg.ignoresSafeArea()

            VStack(spacing: CGFloat.spacingXXL) {
                // Header
                VStack(spacing: CGFloat.spacingSM) {
                    Text("What would help right now?")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)

                    Text("Choose an action to regain control")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, CGFloat.spacingXXXL)
                .padding(.horizontal, CGFloat.spacingXL)

                // 2x2 Action Grid
                VStack(spacing: CGFloat.spacingLG) {
                    HStack(spacing: CGFloat.spacingLG) {
                        // Talk to AI
                        LockInActionCard(
                            icon: "brain.head.profile",
                            title: "Talk to AI",
                            subtitle: "Unlimited",
                            color: .emerald
                        ) {
                            viewModel.selectAction(.talkToAI)
                        }

                        // Block Everything
                        LockInActionCard(
                            icon: "shield.fill",
                            title: "Block Everything",
                            subtitle: "Set duration",
                            color: .coralAlert
                        ) {
                            viewModel.selectAction(.blockEverything)
                        }
                    }

                    HStack(spacing: CGFloat.spacingLG) {
                        // Breathing Exercise
                        LockInActionCard(
                            icon: "wind",
                            title: "Breathing",
                            subtitle: "2 min timer",
                            color: .blue
                        ) {
                            viewModel.selectAction(.breathingExercise)
                        }

                        // Physical Challenge
                        LockInActionCard(
                            icon: "figure.run",
                            title: "Physical",
                            subtitle: "Coming soon",
                            color: .purple
                        ) {
                            viewModel.selectAction(.physicalChallenge)
                        }
                    }
                }
                .padding(.horizontal, CGFloat.spacingXL)

                Spacer()

                // Cancel button
                Button {
                    dismiss()
                } label: {
                    Text("I'm okay now")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .padding(.vertical, CGFloat.spacingMD)
                }
                .padding(.bottom, CGFloat.spacingXXL)
            }
        }
    }
}

// MARK: - LockInActionCard

struct LockInActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: CGFloat.spacingMD) {
                Image(systemName: icon)
                    .font(.system(size: 36))
                    .foregroundColor(color)

                VStack(spacing: CGFloat.spacingXS) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.textPrimary)

                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .background(Color.elevatedBg)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - LockInActionExecutionView

struct LockInActionExecutionView: View {
    @ObservedObject var viewModel: LockInViewModel
    let action: LockInViewModel.LockInAction
    let onDismiss: () -> Void
    @EnvironmentObject var services: ServiceContainer

    var body: some View {
        Group {
            switch action {
            case .talkToAI:
                AICoachView(services: services, isPanicMode: true)

            case .blockEverything:
                BlockEverythingView(viewModel: viewModel, onComplete: onDismiss)

            case .breathingExercise:
                BreathingExerciseView(viewModel: viewModel)

            case .physicalChallenge:
                PhysicalChallengePlaceholderView(onBack: {
                    viewModel.backToActionSelection()
                })
            }
        }
    }
}

// MARK: - BlockEverythingView

struct BlockEverythingView: View {
    @ObservedObject var viewModel: LockInViewModel
    let onComplete: () -> Void
    @State private var selectedDuration: TimeInterval = 3600

    let durationOptions: [(String, TimeInterval)] = [
        ("15 minutes", 900),
        ("30 minutes", 1800),
        ("1 hour", 3600),
        ("2 hours", 7200),
        ("4 hours", 14400),
        ("8 hours", 28800)
    ]

    var body: some View {
        ZStack {
            Color.primaryBg.ignoresSafeArea()

            VStack(spacing: CGFloat.spacingXXL) {
                // Header
                VStack(spacing: CGFloat.spacingSM) {
                    Image(systemName: "shield.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.coralAlert)

                    Text("Block Everything")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.textPrimary)

                    Text("How long do you need?")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, CGFloat.spacingXXXL)

                // Duration picker
                ScrollView {
                    VStack(spacing: CGFloat.spacingMD) {
                        ForEach(durationOptions, id: \.1) { option in
                            Button {
                                selectedDuration = option.1
                            } label: {
                                HStack {
                                    Text(option.0)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.textPrimary)

                                    Spacer()

                                    if selectedDuration == option.1 {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.emerald)
                                            .font(.system(size: 22))
                                    }
                                }
                                .padding(CGFloat.spacingLG)
                                .background(
                                    selectedDuration == option.1 ?
                                    Color.emerald.opacity(0.1) :
                                    Color.elevatedBg
                                )
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            selectedDuration == option.1 ?
                                            Color.emerald.opacity(0.5) :
                                            Color.clear,
                                            lineWidth: 1
                                        )
                                )
                            }
                        }
                    }
                    .padding(.horizontal, CGFloat.spacingXL)
                }

                // Apply button
                VStack(spacing: CGFloat.spacingMD) {
                    Button {
                        viewModel.blockDuration = selectedDuration
                        viewModel.applyBlockEverything()
                        onComplete()
                    } label: {
                        Text("Apply Block")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.coralAlert)
                            .cornerRadius(12)
                    }

                    Button {
                        viewModel.backToActionSelection()
                    } label: {
                        Text("Back")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(.horizontal, CGFloat.spacingXL)
                .padding(.bottom, CGFloat.spacingXXL)
            }
        }
    }
}

// MARK: - BreathingExerciseView

struct BreathingExerciseView: View {
    @ObservedObject var viewModel: LockInViewModel

    var body: some View {
        ZStack {
            Color.primaryBg.ignoresSafeArea()

            VStack(spacing: CGFloat.spacingXXXL) {
                Spacer()

                // Timer display
                VStack(spacing: CGFloat.spacingLG) {
                    Text(formatTime(viewModel.breathingTimer))
                        .font(.system(size: 64, weight: .bold, design: .monospaced))
                        .foregroundColor(.emerald)

                    Text(viewModel.breathingTimer > 0 ? "Keep breathing..." : "Great job!")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.textSecondary)
                }

                // Breathing animation
                ZStack {
                    Circle()
                        .fill(Color.emerald.opacity(0.2))
                        .frame(width: 220, height: 220)

                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.emerald, Color.emerald.opacity(0.6)],
                                center: .center,
                                startRadius: 40,
                                endRadius: 100
                            )
                        )
                        .frame(width: 180, height: 180)
                        .scaleEffect(viewModel.breathingTimer > 0 ? 1.0 : 0.8)
                        .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: viewModel.breathingTimer)
                }

                Spacer()

                // Controls
                VStack(spacing: CGFloat.spacingMD) {
                    if viewModel.breathingTimer == 120 {
                        Button {
                            viewModel.startBreathingExercise()
                        } label: {
                            Text("Start")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.emerald)
                                .cornerRadius(12)
                        }
                    }

                    Button {
                        viewModel.backToActionSelection()
                    } label: {
                        Text("Back")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.textSecondary)
                    }
                }
                .padding(.horizontal, CGFloat.spacingXXL)
                .padding(.bottom, CGFloat.spacingXXL)
            }
        }
        .onAppear {
            if viewModel.breathingTimer == 0 {
                viewModel.breathingTimer = 120
            }
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - PhysicalChallengePlaceholderView

struct PhysicalChallengePlaceholderView: View {
    let onBack: () -> Void

    var body: some View {
        ZStack {
            Color.primaryBg.ignoresSafeArea()

            VStack(spacing: CGFloat.spacingXXL) {
                Spacer()

                Image(systemName: "figure.run")
                    .font(.system(size: 72))
                    .foregroundColor(.purple)

                VStack(spacing: CGFloat.spacingSM) {
                    Text("Physical Challenge")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.textPrimary)

                    Text("Coming soon")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                Button {
                    onBack()
                } label: {
                    Text("Back")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
                .padding(.bottom, CGFloat.spacingXXXL)
            }
        }
    }
}
