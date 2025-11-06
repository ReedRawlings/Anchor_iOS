//
//  NotificationPermissionScreen.swift
//  Anchor_iOS
//
//  Notification permission request screen
//

import SwiftUI
import UserNotifications

struct NotificationPermissionScreen: View {
    @State private var isRequesting = false
    @State private var permissionGranted = false
    let onContinue: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: CGFloat.spacingXXXL) {
                    // Icon
                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.emerald)
                        .padding(.top, CGFloat.spacingXXXL * 2)

                    // Header
                    VStack(spacing: CGFloat.spacingMD) {
                        Text("Stay on Track")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)

                        Text("Get helpful reminders at the right time")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Features
                    VStack(spacing: CGFloat.spacingLG) {
                        PermissionFeature(
                            icon: "clock.badge.checkmark.fill",
                            title: "Risk Time Alerts",
                            description: "Gentle reminders before your typical trigger times"
                        )

                        PermissionFeature(
                            icon: "star.fill",
                            title: "Milestone Celebrations",
                            description: "Celebrate your progress and achievements"
                        )

                        PermissionFeature(
                            icon: "heart.fill",
                            title: "Encouragement",
                            description: "Supportive messages when you need them most"
                        )
                    }
                    .padding(.horizontal, CGFloat.spacingXXL)

                    // Info box
                    HStack(spacing: CGFloat.spacingMD) {
                        Image(systemName: "moon.zzz.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.emerald)

                        Text("Notifications respect Do Not Disturb and can be customized in Settings.")
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

                        Text("Notifications Enabled")
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

                            Text(isRequesting ? "Requesting..." : "Enable Notifications")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.emerald)
                        .cornerRadius(16)
                    }
                    .disabled(isRequesting)

                    Button(action: onContinue) {
                        Text("Skip for Now")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.emerald)
                            .frame(height: 44)
                    }

                    Button(action: onBack) {
                        Text("Back")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.textSecondary)
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
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                permissionGranted = settings.authorizationStatus == .authorized
            }
        }
    }

    private func requestAuthorization() {
        isRequesting = true

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                permissionGranted = granted
                isRequesting = false

                // If granted, automatically continue after a brief delay
                if granted {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        onContinue()
                    }
                }
            }
        }
    }
}

#Preview {
    NotificationPermissionScreen(onContinue: {}, onBack: {})
}
