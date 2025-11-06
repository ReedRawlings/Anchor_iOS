//
//  ScreenTimePermissionScreen.swift
//  Anchor_iOS
//
//  Screen Time / FamilyControls permission request screen
//

import SwiftUI
import FamilyControls

struct ScreenTimePermissionScreen: View {
    @State private var authorizationCenter = AuthorizationCenter.shared
    @State private var isRequesting = false
    @State private var permissionGranted = false
    let onContinue: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: CGFloat.spacingXXXL) {
                    // Icon
                    Image(systemName: "hourglass.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.emerald)
                        .padding(.top, CGFloat.spacingXXXL * 2)

                    // Header
                    VStack(spacing: CGFloat.spacingMD) {
                        Text("Enable App Blocking")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)

                        Text("Block distracting apps when you need focus")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Features
                    VStack(spacing: CGFloat.spacingLG) {
                        PermissionFeature(
                            icon: "lock.shield.fill",
                            title: "Block Apps & Websites",
                            description: "Prevent access during vulnerable moments"
                        )

                        PermissionFeature(
                            icon: "clock.fill",
                            title: "Schedule Protection",
                            description: "Set up automatic blocks for risk times"
                        )

                        PermissionFeature(
                            icon: "hand.raised.fill",
                            title: "Emergency Override",
                            description: "Can be unlocked with a cooldown period"
                        )
                    }
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Info box
                    HStack(spacing: CGFloat.spacingMD) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.emerald)

                        Text("This permission is required for app blocking to work. You can revoke it anytime in Settings.")
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
                if permissionGranted {
                    // Show success state
                    HStack(spacing: CGFloat.spacingMD) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.emerald)

                        Text("Permission Granted")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.emerald)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.emerald.opacity(0.2))
                    .cornerRadius(16)

                    Button(action: onContinue) {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.emerald)
                            .cornerRadius(16)
                    }
                } else {
                    Button(action: requestAuthorization) {
                        HStack(spacing: CGFloat.spacingMD) {
                            if isRequesting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                            }

                            Text(isRequesting ? "Requesting..." : "Grant Permission")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.emerald)
                        .cornerRadius(16)
                    }
                    .disabled(isRequesting)

                    Button(action: onBack) {
                        Text("Back")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.emerald)
                            .frame(height: 44)
                    }
                }
            }
            .padding(.horizontal, CGFloat.spacingXXL)
            .padding(.bottom, CGFloat.spacingLG)
            .background(Color.primaryBg.opacity(0.95))
        }
        .background(Color.primaryBg)
        .onAppear {
            checkCurrentStatus()
        }
    }

    private func checkCurrentStatus() {
        permissionGranted = authorizationCenter.authorizationStatus == .approved
    }

    private func requestAuthorization() {
        isRequesting = true

        Task {
            do {
                try await authorizationCenter.requestAuthorization(for: .individual)
                await MainActor.run {
                    permissionGranted = authorizationCenter.authorizationStatus == .approved
                    isRequesting = false

                    // If granted, automatically continue after a brief delay
                    if permissionGranted {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            onContinue()
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    isRequesting = false
                    // Handle error - user might have denied permission
                    // For now, we'll just allow them to retry
                }
            }
        }
    }
}

// MARK: - Permission Feature Row

struct PermissionFeature: View {
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
    ScreenTimePermissionScreen(onContinue: {}, onBack: {})
}
