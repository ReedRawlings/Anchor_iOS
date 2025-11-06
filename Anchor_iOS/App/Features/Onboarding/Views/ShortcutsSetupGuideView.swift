//
//  ShortcutsSetupGuideView.swift
//  Anchor_iOS
//
//  Guide for setting up triple back-tap shortcut for panic button
//

import SwiftUI

struct ShortcutsSetupGuideView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: CGFloat.spacingXXXL) {
                    // Header
                    VStack(spacing: CGFloat.spacingMD) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.emerald)
                            .padding(.top, CGFloat.spacingXL)

                        Text("Quick Panic Access")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.textPrimary)

                        Text("Activate panic mode with triple back-tap")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Why section
                    VStack(alignment: .leading, spacing: CGFloat.spacingLG) {
                        HStack(spacing: CGFloat.spacingMD) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.emerald)

                            Text("Why this helps")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.textPrimary)
                        }

                        Text("In crisis moments, you need instant access. Triple back-tap works even with your phone locked or in any app.")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(CGFloat.spacingLG)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(16)
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Setup steps
                    VStack(alignment: .leading, spacing: CGFloat.spacingLG) {
                        Text("Setup Steps")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.textPrimary)

                        SetupStep(
                            number: 1,
                            title: "Open Settings App",
                            description: "Go to your iPhone Settings"
                        )

                        SetupStep(
                            number: 2,
                            title: "Navigate to Accessibility",
                            description: "Tap Accessibility → Touch"
                        )

                        SetupStep(
                            number: 3,
                            title: "Enable Back Tap",
                            description: "Tap \"Back Tap\" → \"Triple Tap\""
                        )

                        SetupStep(
                            number: 4,
                            title: "Select Anchor Panic",
                            description: "Scroll down and select \"Anchor Panic\" from the Shortcuts list"
                        )
                    }
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Open settings button
                    Button(action: openSettings) {
                        HStack(spacing: CGFloat.spacingMD) {
                            Image(systemName: "gear")
                                .font(.system(size: 17))

                            Text("Open Settings")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.emerald)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Note
                    HStack(spacing: CGFloat.spacingMD) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.textSecondary)

                        Text("This feature requires iOS 14 or later and is optional. You can always access panic mode from within the app.")
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
            .background(Color.primaryBg)
            .navigationTitle("Shortcuts Setup")
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

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Setup Step Component

struct SetupStep: View {
    let number: Int
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: CGFloat.spacingLG) {
            // Step number
            Text("\(number)")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .frame(width: 32, height: 32)
                .background(Color.emerald)
                .clipShape(Circle())

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
    ShortcutsSetupGuideView()
}
