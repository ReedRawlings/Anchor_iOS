//
//  SetGoalScreen.swift
//  Anchor_iOS
//
//  Set recovery identity/goal screen
//

import SwiftUI

struct SetGoalScreen: View {
    @Binding var recoveryIdentity: String
    @FocusState private var isTextFieldFocused: Bool
    let onContinue: () -> Void
    let onBack: () -> Void

    private let suggestions = [
        "be a better partner",
        "focus on my career",
        "be more present with family",
        "take care of my health",
        "develop my skills",
        "build meaningful connections"
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: CGFloat.spacingXXXL) {
                    // Header
                    VStack(spacing: CGFloat.spacingMD) {
                        Text("What do you want to reclaim time for?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)

                        Text("This helps personalize your recovery journey")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, CGFloat.spacingXXXL)
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Input Field
                    VStack(alignment: .leading, spacing: CGFloat.spacingSM) {
                        Text("I want to...")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.textSecondary)

                        TextField("", text: $recoveryIdentity, prompt: Text("be more present").foregroundColor(.textTertiary))
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal, CGFloat.spacingLG)
                            .padding(.vertical, CGFloat.spacingLG)
                            .background(Color.tertiaryBg)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        isTextFieldFocused ? Color.emerald : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                            .focused($isTextFieldFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                if canContinue {
                                    onContinue()
                                }
                            }
                    }
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Suggestions
                    VStack(alignment: .leading, spacing: CGFloat.spacingMD) {
                        Text("Suggestions")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, CGFloat.spacingXXL)

                        FlowLayout(spacing: CGFloat.spacingSM) {
                            ForEach(suggestions, id: \.self) { suggestion in
                                SuggestionChip(title: suggestion) {
                                    recoveryIdentity = suggestion
                                }
                            }
                        }
                        .padding(.horizontal, CGFloat.spacingXXL)
                    }

                    Spacer(minLength: CGFloat.spacingXXXL)
                }
            }

            // Bottom buttons
            VStack(spacing: CGFloat.spacingMD) {
                Button(action: onContinue) {
                    Text("Continue")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(canContinue ? Color.emerald : Color.emerald.opacity(0.5))
                        .cornerRadius(16)
                }
                .disabled(!canContinue)

                Button(action: onBack) {
                    Text("Back")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.emerald)
                        .frame(height: 44)
                }
            }
            .padding(.horizontal, CGFloat.spacingXXL)
            .padding(.bottom, CGFloat.spacingLG)
            .background(Color.primaryBg.opacity(0.95))
        }
        .background(Color.primaryBg)
        .onAppear {
            // Auto-focus the text field after a brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
    }

    private var canContinue: Bool {
        !recoveryIdentity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: - Suggestion Chip Component

struct SuggestionChip: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.textPrimary)
                .padding(.horizontal, CGFloat.spacingLG)
                .padding(.vertical, CGFloat.spacingMD)
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var identity: String = ""

        var body: some View {
            SetGoalScreen(
                recoveryIdentity: $identity,
                onContinue: {},
                onBack: {}
            )
        }
    }

    return PreviewWrapper()
}
