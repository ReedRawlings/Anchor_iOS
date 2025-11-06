//
//  TrialOfferScreen.swift
//  Anchor_iOS
//
//  Trial offer screen - Final onboarding screen
//

import SwiftUI

struct TrialOfferScreen: View {
    let onStartTrial: () -> Void
    let onContinueFree: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: CGFloat.spacingXXXL) {
                    // Header
                    VStack(spacing: CGFloat.spacingMD) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.emerald)
                            .padding(.top, CGFloat.spacingXXXL)

                        Text("Try Anchor Pro")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.textPrimary)

                        Text("7 days free, then $4.99/month")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Pro features
                    VStack(spacing: CGFloat.spacingLG) {
                        ProFeature(
                            icon: "infinity",
                            title: "Unlimited AI Messages",
                            description: "Chat with your recovery coach anytime",
                            isFree: false
                        )

                        ProFeature(
                            icon: "chart.xyaxis.line",
                            title: "Advanced Analytics",
                            description: "Deep insights into your patterns and triggers",
                            isFree: false
                        )

                        ProFeature(
                            icon: "calendar.badge.clock",
                            title: "Smart Scheduling",
                            description: "Automatic blocks based on your risk times",
                            isFree: false
                        )

                        ProFeature(
                            icon: "icloud.fill",
                            title: "Cloud Sync",
                            description: "Keep your data synced across devices",
                            isFree: false
                        )

                        Divider()
                            .background(Color.white.opacity(0.1))
                            .padding(.vertical, CGFloat.spacingSM)

                        Text("Free Forever")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ProFeature(
                            icon: "shield.fill",
                            title: "App Blocking",
                            description: "Core blocking features always available",
                            isFree: true
                        )

                        ProFeature(
                            icon: "heart.fill",
                            title: "Panic Button",
                            description: "Emergency support when you need it",
                            isFree: true
                        )

                        ProFeature(
                            icon: "message.fill",
                            title: "3 Daily AI Messages",
                            description: "Basic AI coach support",
                            isFree: true
                        )

                        ProFeature(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Streak Tracking",
                            description: "Monitor your progress",
                            isFree: true
                        )
                    }
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Fine print
                    Text("Cancel anytime. No commitment. Privacy guaranteed.")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, CGFloat.spacingXXXL)

                    Spacer(minLength: CGFloat.spacingXXXL)
                }
            }

            // Bottom buttons
            VStack(spacing: CGFloat.spacingMD) {
                Button(action: onStartTrial) {
                    VStack(spacing: CGFloat.spacingXS) {
                        Text("Start 7-Day Free Trial")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)

                        Text("Then $4.99/month")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.black.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.emerald)
                    .cornerRadius(16)
                }

                Button(action: onContinueFree) {
                    Text("Continue with Free Version")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.emerald)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.emerald.opacity(0.3), lineWidth: 2)
                        )
                }

                Button(action: onBack) {
                    Text("Back")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.textSecondary)
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

// MARK: - Pro Feature Row

struct ProFeature: View {
    let icon: String
    let title: String
    let description: String
    let isFree: Bool

    var body: some View {
        HStack(alignment: .top, spacing: CGFloat.spacingLG) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isFree ? .textSecondary : .emerald)
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: CGFloat.spacingXXS) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)

                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            if !isFree {
                Image(systemName: "crown.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.warning)
            }
        }
    }
}

#Preview {
    TrialOfferScreen(
        onStartTrial: {},
        onContinueFree: {},
        onBack: {}
    )
}
