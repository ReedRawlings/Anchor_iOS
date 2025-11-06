//
//  WelcomeScreen.swift
//  Anchor_iOS
//
//  Welcome screen - First screen in onboarding flow
//

import SwiftUI

struct WelcomeScreen: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: CGFloat.spacingXXL) {
            Spacer()

            // App Icon/Logo
            Image(systemName: "anchor.fill")
                .font(.system(size: 80))
                .foregroundColor(.emerald)
                .padding(.bottom, CGFloat.spacingLG)

            // Title
            VStack(spacing: CGFloat.spacingMD) {
                Text("Welcome to Anchor")
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .foregroundColor(.textPrimary)

                Text("Your recovery support system")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            // Description
            VStack(spacing: CGFloat.spacingXL) {
                FeatureRow(
                    icon: "shield.fill",
                    title: "Block Distractions",
                    description: "Prevent access to apps and websites during vulnerable moments"
                )

                FeatureRow(
                    icon: "heart.text.square.fill",
                    title: "AI Recovery Coach",
                    description: "Get personalized support when urges hit"
                )

                FeatureRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Track Patterns",
                    description: "Understand your triggers and build lasting streaks"
                )
            }
            .padding(.horizontal, CGFloat.spacingXXL)

            Spacer()

            // CTA Button
            Button(action: onContinue) {
                Text("Get Started")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.emerald)
                    .cornerRadius(16)
            }
            .padding(.horizontal, CGFloat.spacingXXL)
            .padding(.bottom, CGFloat.spacingXXL)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBg)
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: CGFloat.spacingLG) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.emerald)
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: CGFloat.spacingXS) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.textPrimary)

                Text(description)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    WelcomeScreen(onContinue: {})
}
