//
//  PanicAIIntroScreen.swift
//  Anchor_iOS
//
//  Combined Panic Button + AI Coach introduction screen
//

import SwiftUI

struct PanicAIIntroScreen: View {
    let onContinue: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: CGFloat.spacingXXXL) {
                    // Header
                    VStack(spacing: CGFloat.spacingMD) {
                        Text("Your Safety Net")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)

                        Text("Two powerful tools for when urges hit")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, CGFloat.spacingXXXL)
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Panic Button Section
                    VStack(spacing: CGFloat.spacingLG) {
                        // Panic button demo
                        Button(action: {}) {
                            Text("Panic")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(Color.coralAlert)
                                .clipShape(Circle())
                                .shadow(color: Color.coralAlert.opacity(0.4), radius: 12, x: 0, y: 6)
                        }
                        .disabled(true)

                        VStack(spacing: CGFloat.spacingSM) {
                            Text("Panic Button")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.textPrimary)

                            Text("Always available in bottom-right corner")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.textSecondary)
                        }

                        // Features
                        VStack(alignment: .leading, spacing: CGFloat.spacingMD) {
                            FeatureCheckmark(text: "Guided breathing exercise")
                            FeatureCheckmark(text: "Instant app blocking")
                            FeatureCheckmark(text: "Emergency AI support")
                        }
                        .padding(.top, CGFloat.spacingSM)
                    }
                    .padding(CGFloat.spacingXL)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Divider
                    HStack {
                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 1)

                        Text("AND")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.textSecondary)
                            .padding(.horizontal, CGFloat.spacingMD)

                        Rectangle()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, CGFloat.spacingXXXL)

                    // AI Coach Section
                    VStack(spacing: CGFloat.spacingLG) {
                        // AI icon
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 60))
                            .foregroundColor(.emerald)

                        VStack(spacing: CGFloat.spacingSM) {
                            Text("AI Recovery Coach")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.textPrimary)

                            Text("Available anytime you need support")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.textSecondary)
                        }

                        // Features
                        VStack(alignment: .leading, spacing: CGFloat.spacingMD) {
                            FeatureCheckmark(text: "Personalized recovery insights")
                            FeatureCheckmark(text: "Pattern recognition")
                            FeatureCheckmark(text: "Non-judgmental support")
                        }
                        .padding(.top, CGFloat.spacingSM)

                        // Free message badge
                        HStack(spacing: CGFloat.spacingSM) {
                            Image(systemName: "gift.fill")
                                .font(.system(size: 14))

                            Text("3 free messages daily")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundColor(.emerald)
                        .padding(.horizontal, CGFloat.spacingLG)
                        .padding(.vertical, CGFloat.spacingSM)
                        .background(Color.emerald.opacity(0.15))
                        .cornerRadius(8)
                    }
                    .padding(CGFloat.spacingXL)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Triple back-tap hint
                    HStack(spacing: CGFloat.spacingMD) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.emerald)

                        Text("Pro tip: Set up triple back-tap for instant panic access (we'll show you how)")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(CGFloat.spacingLG)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal, CGFloat.spacingXXL)

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
                        .background(Color.emerald)
                        .cornerRadius(16)
                }

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
    }
}

// MARK: - Feature Checkmark Component

struct FeatureCheckmark: View {
    let text: String

    var body: some View {
        HStack(spacing: CGFloat.spacingMD) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(.emerald)

            Text(text)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.textPrimary)

            Spacer()
        }
    }
}

#Preview {
    PanicAIIntroScreen(onContinue: {}, onBack: {})
}
