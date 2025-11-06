//
//  OnboardingFeature.swift
//  Anchor_iOS
//
//  Consolidated Onboarding feature (ViewModel + View)
//

import Foundation
import SwiftUI
import Combine
import FamilyControls
import UserNotifications

// MARK: - OnboardingState (UserDefaults)

@MainActor
class OnboardingState: ObservableObject {
    static let shared = OnboardingState()

    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("selectedGoals") private var selectedGoalsData: Data = Data()
    @AppStorage("selectedTriggers") private var selectedTriggersData: Data = Data()
    @AppStorage("dailyGoal") var dailyGoal: Int = 7 // Default 7 days
    @AppStorage("hasGrantedScreenTimePermission") var hasGrantedScreenTimePermission: Bool = false
    @AppStorage("hasGrantedNotificationPermission") var hasGrantedNotificationPermission: Bool = false
    @AppStorage("hasSeenPanicIntro") var hasSeenPanicIntro: Bool = false
    @AppStorage("hasSeenTrialOffer") var hasSeenTrialOffer: Bool = false

    var selectedGoals: [String] {
        get {
            (try? JSONDecoder().decode([String].self, from: selectedGoalsData)) ?? []
        }
        set {
            selectedGoalsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    var selectedTriggers: [String] {
        get {
            (try? JSONDecoder().decode([String].self, from: selectedTriggersData)) ?? []
        }
        set {
            selectedTriggersData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
    }

    func resetOnboarding() {
        hasCompletedOnboarding = false
        selectedGoals = []
        selectedTriggers = []
        dailyGoal = 7
        hasGrantedScreenTimePermission = false
        hasGrantedNotificationPermission = false
        hasSeenPanicIntro = false
        hasSeenTrialOffer = false
    }
}

// MARK: - OnboardingViewModel

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var selectedGoals: Set<String> = []
    @Published var selectedTriggers: Set<String> = []
    @Published var dailyGoal: Int = 7
    @Published var showingScreenTimeRequest = false
    @Published var showingNotificationRequest = false

    private let services: ServiceContainer
    private let onboardingState = OnboardingState.shared

    let totalSteps = 7

    // Available goals
    let availableGoals = [
        "Break the habit",
        "Improve relationships",
        "Better mental health",
        "Increase productivity",
        "Build self-control",
        "Feel more confident"
    ]

    // Available triggers (clinical language)
    let availableTriggers = [
        "Boredom",
        "Stress/Anxiety",
        "Late night/Unable to sleep",
        "Social media use",
        "Alone time",
        "After work/school",
        "Specific apps/websites",
        "Other"
    ]

    init(services: ServiceContainer) {
        self.services = services
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

    func toggleGoal(_ goal: String) {
        if selectedGoals.contains(goal) {
            selectedGoals.remove(goal)
        } else {
            selectedGoals.insert(goal)
        }
    }

    func toggleTrigger(_ trigger: String) {
        if selectedTriggers.contains(trigger) {
            selectedTriggers.remove(trigger)
        } else {
            selectedTriggers.insert(trigger)
        }
    }

    func requestScreenTimePermission() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            onboardingState.hasGrantedScreenTimePermission = true
        } catch {
            print("Screen Time permission denied: \(error)")
        }
    }

    func requestNotificationPermission() async {
        let granted = await services.notificationService.requestAuthorization()
        onboardingState.hasGrantedNotificationPermission = granted
    }

    func completeOnboarding() {
        // Save selections
        onboardingState.selectedGoals = Array(selectedGoals)
        onboardingState.selectedTriggers = Array(selectedTriggers)
        onboardingState.dailyGoal = dailyGoal
        onboardingState.hasSeenPanicIntro = true
        onboardingState.hasSeenTrialOffer = true

        // Mark onboarding as complete
        onboardingState.completeOnboarding()
    }
}

// MARK: - OnboardingView (Main Coordinator)

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    @Environment(\.dismiss) private var dismiss

    init(services: ServiceContainer) {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(services: services))
    }

    var body: some View {
        ZStack {
            Color.primaryBg.ignoresSafeArea()

            TabView(selection: $viewModel.currentStep) {
                WelcomeScreen(viewModel: viewModel)
                    .tag(0)

                GoalsTriggersScreen(viewModel: viewModel)
                    .tag(1)

                SetGoalScreen(viewModel: viewModel)
                    .tag(2)

                ScreenTimePermissionScreen(viewModel: viewModel)
                    .tag(3)

                NotificationPermissionScreen(viewModel: viewModel)
                    .tag(4)

                PanicAIIntroScreen(viewModel: viewModel)
                    .tag(5)

                TrialOfferScreen(viewModel: viewModel)
                    .tag(6)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .indexViewStyle(.page(backgroundDisplayMode: .never))
        }
    }
}

// MARK: - Screen 1: Welcome

struct WelcomeScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: CGFloat.spacingXXL) {
            Spacer()

            // App icon or welcome graphic
            Image(systemName: "anchor.fill")
                .font(.system(size: 80))
                .foregroundColor(.emerald)
                .padding(.bottom, CGFloat.spacingLG)

            VStack(spacing: CGFloat.spacingMD) {
                Text("Welcome to Anchor")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)

                Text("Your recovery journey starts here. We're here to support you every step of the way.")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, CGFloat.spacingXL)

            Spacer()

            // Progress indicator
            ProgressIndicator(currentStep: viewModel.currentStep, totalSteps: viewModel.totalSteps)
                .padding(.bottom, CGFloat.spacingMD)

            Button {
                viewModel.nextStep()
            } label: {
                Text("Get Started")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.emerald)
                    .cornerRadius(16)
            }
            .padding(.horizontal, CGFloat.spacingXL)
            .padding(.bottom, CGFloat.spacingXL)
        }
        .background(Color.primaryBg)
    }
}

// MARK: - Screen 2: Goals/Triggers Selection

struct GoalsTriggersScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: CGFloat.spacingXL) {
            // Header
            VStack(spacing: CGFloat.spacingSM) {
                Text("Let's personalize your experience")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)

                Text("Select what resonates with you")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.textSecondary)
            }
            .padding(.top, CGFloat.spacingXXL)
            .padding(.horizontal, CGFloat.spacingXL)

            ScrollView {
                VStack(spacing: CGFloat.spacingXL) {
                    // Goals section
                    VStack(alignment: .leading, spacing: CGFloat.spacingMD) {
                        Text("My Goals")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal, CGFloat.spacingXL)

                        VStack(spacing: CGFloat.spacingXS) {
                            ForEach(viewModel.availableGoals, id: \.self) { goal in
                                SelectionRow(
                                    text: goal,
                                    isSelected: viewModel.selectedGoals.contains(goal)
                                ) {
                                    viewModel.toggleGoal(goal)
                                }
                            }
                        }
                        .padding(.horizontal, CGFloat.spacingXL)
                    }

                    // Triggers section
                    VStack(alignment: .leading, spacing: CGFloat.spacingMD) {
                        Text("Common Triggers")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal, CGFloat.spacingXL)

                        Text("Knowing your triggers helps us provide better support")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.textTertiary)
                            .padding(.horizontal, CGFloat.spacingXL)

                        VStack(spacing: CGFloat.spacingXS) {
                            ForEach(viewModel.availableTriggers, id: \.self) { trigger in
                                SelectionRow(
                                    text: trigger,
                                    isSelected: viewModel.selectedTriggers.contains(trigger)
                                ) {
                                    viewModel.toggleTrigger(trigger)
                                }
                            }
                        }
                        .padding(.horizontal, CGFloat.spacingXL)
                    }
                }
                .padding(.bottom, 120)
            }

            Spacer()

            // Bottom navigation
            VStack(spacing: CGFloat.spacingMD) {
                ProgressIndicator(currentStep: viewModel.currentStep, totalSteps: viewModel.totalSteps)

                HStack(spacing: CGFloat.spacingMD) {
                    Button {
                        viewModel.previousStep()
                    } label: {
                        Text("Back")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.emerald)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.emerald.opacity(0.3), lineWidth: 2)
                            )
                    }

                    Button {
                        viewModel.nextStep()
                    } label: {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.emerald)
                            .cornerRadius(16)
                    }
                    .disabled(viewModel.selectedGoals.isEmpty)
                    .opacity(viewModel.selectedGoals.isEmpty ? 0.5 : 1.0)
                }
            }
            .padding(.horizontal, CGFloat.spacingXL)
            .padding(.bottom, CGFloat.spacingXL)
        }
        .background(Color.primaryBg)
    }
}

// MARK: - Screen 3: Set Goal

struct SetGoalScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel

    let goalOptions = [7, 14, 30, 90]

    var body: some View {
        VStack(spacing: CGFloat.spacingXXL) {
            Spacer()

            VStack(spacing: CGFloat.spacingMD) {
                Text("Set Your Initial Goal")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.textPrimary)

                Text("You can adjust this anytime")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, CGFloat.spacingXL)

            // Goal selector
            VStack(spacing: CGFloat.spacingMD) {
                ForEach(goalOptions, id: \.self) { days in
                    Button {
                        viewModel.dailyGoal = days
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(days) Days")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.textPrimary)

                                Text(goalDescription(for: days))
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.textSecondary)
                            }

                            Spacer()

                            if viewModel.dailyGoal == days {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.emerald)
                            }
                        }
                        .padding(CGFloat.spacingMD)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.dailyGoal == days ? Color.emerald : Color.clear, lineWidth: 2)
                        )
                    }
                }
            }
            .padding(.horizontal, CGFloat.spacingXL)

            Spacer()

            // Bottom navigation
            VStack(spacing: CGFloat.spacingMD) {
                ProgressIndicator(currentStep: viewModel.currentStep, totalSteps: viewModel.totalSteps)

                HStack(spacing: CGFloat.spacingMD) {
                    Button {
                        viewModel.previousStep()
                    } label: {
                        Text("Back")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.emerald)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.emerald.opacity(0.3), lineWidth: 2)
                            )
                    }

                    Button {
                        viewModel.nextStep()
                    } label: {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.emerald)
                            .cornerRadius(16)
                    }
                }
            }
            .padding(.horizontal, CGFloat.spacingXL)
            .padding(.bottom, CGFloat.spacingXL)
        }
        .background(Color.primaryBg)
    }

    func goalDescription(for days: Int) -> String {
        switch days {
        case 7: return "One week clean"
        case 14: return "Two weeks clean"
        case 30: return "One month clean"
        case 90: return "Three months clean"
        default: return "\(days) days clean"
        }
    }
}

// MARK: - Screen 4: Screen Time Permission

struct ScreenTimePermissionScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isRequesting = false

    var body: some View {
        VStack(spacing: CGFloat.spacingXXL) {
            Spacer()

            // Icon
            Image(systemName: "hourglass.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.emerald)

            VStack(spacing: CGFloat.spacingMD) {
                Text("Enable App Blocking")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)

                Text("Anchor uses Screen Time to block apps when you need support. This helps you stay on track during difficult moments.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, CGFloat.spacingXL)

            // Permission info
            GlassCard {
                VStack(alignment: .leading, spacing: CGFloat.spacingSM) {
                    HStack(spacing: CGFloat.spacingSM) {
                        Image(systemName: "lock.shield.fill")
                            .foregroundColor(.emerald)
                        Text("Your privacy is protected")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.textPrimary)
                    }

                    Text("Anchor only sees which apps are blocked. We never see what you're browsing or using.")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.textSecondary)
                        .lineSpacing(2)
                }
            }
            .padding(.horizontal, CGFloat.spacingXL)

            Spacer()

            // Bottom navigation
            VStack(spacing: CGFloat.spacingMD) {
                ProgressIndicator(currentStep: viewModel.currentStep, totalSteps: viewModel.totalSteps)

                VStack(spacing: CGFloat.spacingSM) {
                    Button {
                        isRequesting = true
                        Task {
                            await viewModel.requestScreenTimePermission()
                            isRequesting = false
                            viewModel.nextStep()
                        }
                    } label: {
                        HStack {
                            if isRequesting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text("Enable Screen Time")
                        }
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.emerald)
                        .cornerRadius(16)
                    }
                    .disabled(isRequesting)

                    Button {
                        viewModel.nextStep()
                    } label: {
                        Text("Skip for now")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.textTertiary)
                            .frame(height: 44)
                    }
                }
            }
            .padding(.horizontal, CGFloat.spacingXL)
            .padding(.bottom, CGFloat.spacingXL)
        }
        .background(Color.primaryBg)
    }
}

// MARK: - Screen 5: Notification Permission

struct NotificationPermissionScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isRequesting = false

    var body: some View {
        VStack(spacing: CGFloat.spacingXXL) {
            Spacer()

            // Icon
            Image(systemName: "bell.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.emerald)

            VStack(spacing: CGFloat.spacingMD) {
                Text("Stay on Track")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)

                Text("Get gentle reminders during high-risk times and celebrate your milestones.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, CGFloat.spacingXL)

            // Examples
            VStack(spacing: CGFloat.spacingSM) {
                NotificationExample(
                    icon: "moon.fill",
                    title: "High-Risk Time Alert",
                    subtitle: "Gentle reminder when you need it"
                )

                NotificationExample(
                    icon: "star.fill",
                    title: "Milestone Celebration",
                    subtitle: "Celebrate your progress"
                )
            }
            .padding(.horizontal, CGFloat.spacingXL)

            Spacer()

            // Bottom navigation
            VStack(spacing: CGFloat.spacingMD) {
                ProgressIndicator(currentStep: viewModel.currentStep, totalSteps: viewModel.totalSteps)

                VStack(spacing: CGFloat.spacingSM) {
                    Button {
                        isRequesting = true
                        Task {
                            await viewModel.requestNotificationPermission()
                            isRequesting = false
                            viewModel.nextStep()
                        }
                    } label: {
                        HStack {
                            if isRequesting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text("Enable Notifications")
                        }
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.emerald)
                        .cornerRadius(16)
                    }
                    .disabled(isRequesting)

                    Button {
                        viewModel.nextStep()
                    } label: {
                        Text("Skip for now")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.textTertiary)
                            .frame(height: 44)
                    }
                }
            }
            .padding(.horizontal, CGFloat.spacingXL)
            .padding(.bottom, CGFloat.spacingXL)
        }
        .background(Color.primaryBg)
    }
}

// MARK: - Screen 6: Lock In + AI Intro

struct PanicAIIntroScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: CGFloat.spacingXXL) {
            Spacer()

            VStack(spacing: CGFloat.spacingMD) {
                Text("Your Support System")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.textPrimary)

                Text("Two powerful tools when you need them most")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, CGFloat.spacingXL)

            VStack(spacing: CGFloat.spacingMD) {
                // Lock In Button info
                GlassCard {
                    VStack(spacing: CGFloat.spacingMD) {
                        // Lock In button demo
                        Circle()
                            .fill(Color.coralAlert)
                            .frame(width: 70, height: 70)
                            .shadow(color: Color.coralAlert.opacity(0.4), radius: 12, x: 0, y: 6)
                            .overlay(
                                Text("Lock In")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                            )

                        VStack(spacing: CGFloat.spacingSM) {
                            Text("Lock In")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.textPrimary)

                            Text("Triple tap the back of your phone anytime for immediate support. Access breathing exercises, emergency blocking, and unlimited AI coaching.")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(2)
                        }
                    }
                }
                .padding(.horizontal, CGFloat.spacingXL)

                // AI Coach info
                GlassCard {
                    VStack(spacing: CGFloat.spacingMD) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 48))
                            .foregroundColor(.emerald)

                        VStack(spacing: CGFloat.spacingSM) {
                            Text("AI Coach")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.textPrimary)

                            Text("Talk through difficult moments with your personal AI coach. Available 24/7 with understanding and evidence-based support.")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(2)
                        }
                    }
                }
                .padding(.horizontal, CGFloat.spacingXL)
            }

            Spacer()

            // Bottom navigation
            VStack(spacing: CGFloat.spacingMD) {
                ProgressIndicator(currentStep: viewModel.currentStep, totalSteps: viewModel.totalSteps)

                Button {
                    viewModel.nextStep()
                } label: {
                    Text("Continue")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.emerald)
                        .cornerRadius(16)
                }
            }
            .padding(.horizontal, CGFloat.spacingXL)
            .padding(.bottom, CGFloat.spacingXL)
        }
        .background(Color.primaryBg)
    }
}

// MARK: - Screen 7: Trial Offer

struct TrialOfferScreen: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: CGFloat.spacingXXL) {
            Spacer()

            VStack(spacing: CGFloat.spacingMD) {
                Text("Start Your Free Trial")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.textPrimary)

                Text("7 days free, then $9.99/month")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.textSecondary)
            }

            // Features
            VStack(spacing: CGFloat.spacingSM) {
                FeatureRow(icon: "infinity", text: "Unlimited AI coaching")
                FeatureRow(icon: "shield.fill", text: "Emergency app blocking")
                FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Pattern insights & analytics")
                FeatureRow(icon: "calendar", text: "Streak tracking & milestones")
                FeatureRow(icon: "bell.fill", text: "Smart risk-time alerts")
            }
            .padding(.horizontal, CGFloat.spacingXL)

            Spacer()

            // Bottom navigation
            VStack(spacing: CGFloat.spacingMD) {
                ProgressIndicator(currentStep: viewModel.currentStep, totalSteps: viewModel.totalSteps)

                VStack(spacing: CGFloat.spacingSM) {
                    Button {
                        // TODO: Start trial with subscription manager
                        viewModel.completeOnboarding()
                    } label: {
                        Text("Start Free Trial")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.emerald)
                            .cornerRadius(16)
                    }

                    Button {
                        viewModel.completeOnboarding()
                    } label: {
                        Text("Continue with Free Version")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.emerald)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.emerald.opacity(0.3), lineWidth: 2)
                            )
                    }

                    Text("No credit card required for trial")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.textTertiary)
                        .padding(.top, 4)
                }
            }
            .padding(.horizontal, CGFloat.spacingXL)
            .padding(.bottom, CGFloat.spacingXL)
        }
        .background(Color.primaryBg)
    }
}

// MARK: - Supporting Views

struct SelectionRow: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.textPrimary)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.emerald)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(CGFloat.spacingMD)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.emerald : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct ProgressIndicator: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalSteps, id: \.self) { step in
                Capsule()
                    .fill(step <= currentStep ? Color.emerald : Color.textTertiary.opacity(0.3))
                    .frame(height: 4)
            }
        }
        .padding(.horizontal, CGFloat.spacingXL)
    }
}

struct NotificationExample: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: CGFloat.spacingMD) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.emerald)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textPrimary)

                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .padding(CGFloat.spacingMD)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: CGFloat.spacingMD) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.emerald)
                .frame(width: 32)

            Text(text)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.textPrimary)

            Spacer()
        }
    }
}

// MARK: - Shortcuts Setup View

struct ShortcutsSetupView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: CGFloat.spacingXXL) {
                    // Header
                    VStack(spacing: CGFloat.spacingMD) {
                        Circle()
                            .fill(Color.coralAlert)
                            .frame(width: 80, height: 80)
                            .shadow(color: Color.coralAlert.opacity(0.4), radius: 12, x: 0, y: 6)
                            .overlay(
                                Image(systemName: "hand.tap.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            )

                        Text("Setup Triple Back-Tap")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.textPrimary)

                        Text("Access Lock In mode instantly by tapping the back of your phone 3 times")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .padding(.top, CGFloat.spacingXL)

                    // Step-by-step instructions
                    VStack(spacing: CGFloat.spacingMD) {
                        SetupStep(
                            number: 1,
                            title: "Open Settings App",
                            description: "Go to your iPhone's Settings app"
                        )

                        SetupStep(
                            number: 2,
                            title: "Navigate to Accessibility",
                            description: "Tap on Accessibility in the settings menu"
                        )

                        SetupStep(
                            number: 3,
                            title: "Select Touch",
                            description: "Under Physical and Motor, tap on Touch"
                        )

                        SetupStep(
                            number: 4,
                            title: "Choose Back Tap",
                            description: "Scroll down and select Back Tap"
                        )

                        SetupStep(
                            number: 5,
                            title: "Configure Triple Tap",
                            description: "Tap on 'Triple Tap' and scroll to find Shortcuts"
                        )

                        SetupStep(
                            number: 6,
                            title: "Select Anchor Shortcut",
                            description: "Choose the 'Anchor Lock In' shortcut from the list"
                        )
                    }

                    // Info card
                    GlassCard {
                        VStack(alignment: .leading, spacing: CGFloat.spacingSM) {
                            HStack(spacing: CGFloat.spacingSM) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.emerald)
                                Text("First time setup")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }

                            Text("If you don't see the 'Anchor Lock In' shortcut, you'll need to create it first. The shortcut should open the URL: anchor://panic")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.textSecondary)
                                .lineSpacing(2)
                        }
                    }

                    // Alternative method
                    VStack(alignment: .leading, spacing: CGFloat.spacingMD) {
                        Text("Alternative: Use Shortcuts App")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.textPrimary)

                        Text("1. Open the Shortcuts app\n2. Tap + to create new shortcut\n3. Add 'Open URL' action\n4. Enter: anchor://panic\n5. Name it 'Anchor Lock In'\n6. Then follow steps above")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.textSecondary)
                            .lineSpacing(4)
                    }

                    // URL for copying
                    VStack(spacing: CGFloat.spacingSM) {
                        Text("Shortcut URL")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.textTertiary)
                            .textCase(.uppercase)

                        HStack {
                            Text("anchor://panic")
                                .font(.system(size: 15, weight: .medium, design: .monospaced))
                                .foregroundColor(.textPrimary)

                            Spacer()

                            Button {
                                UIPasteboard.general.string = "anchor://panic"
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "doc.on.doc")
                                    Text("Copy")
                                }
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.emerald)
                            }
                        }
                        .padding(CGFloat.spacingMD)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                    }
                }
                .padding(CGFloat.spacingXL)
                .padding(.bottom, 100)
            }
            .background(Color.primaryBg)
            .navigationTitle("Setup Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.emerald)
                }
            }
        }
    }
}

struct SetupStep: View {
    let number: Int
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: CGFloat.spacingMD) {
            // Step number
            Text("\(number)")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(.emerald)
                .frame(width: 32, height: 32)
                .background(Color.emerald.opacity(0.2))
                .clipShape(Circle())

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textPrimary)

                Text(description)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.textSecondary)
                    .lineSpacing(2)
            }

            Spacer()
        }
        .padding(CGFloat.spacingMD)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}
