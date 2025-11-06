//
//  OnboardingStateManager.swift
//  Anchor_iOS
//
//  Manages onboarding completion state and user selections
//

import Foundation
import SwiftUI

/// Manages onboarding state persistence
@MainActor
class OnboardingStateManager: ObservableObject {

    // MARK: - Published Properties

    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("selectedGoals") private var selectedGoalsData: Data = Data()
    @AppStorage("selectedTriggers") private var selectedTriggersData: Data = Data()
    @AppStorage("recoveryIdentity") var recoveryIdentity: String = ""
    @AppStorage("hasGrantedScreenTimePermission") var hasGrantedScreenTimePermission: Bool = false
    @AppStorage("hasGrantedNotificationPermission") var hasGrantedNotificationPermission: Bool = false
    @AppStorage("hasSeenTrialOffer") var hasSeenTrialOffer: Bool = false

    // MARK: - Computed Properties

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

    // MARK: - Methods

    func completeOnboarding() {
        hasCompletedOnboarding = true
    }

    func resetOnboarding() {
        hasCompletedOnboarding = false
        selectedGoals = []
        selectedTriggers = []
        recoveryIdentity = ""
        hasGrantedScreenTimePermission = false
        hasGrantedNotificationPermission = false
        hasSeenTrialOffer = false
    }
}
