//
//  HomeFeature.swift
//  Anchor_iOS
//
//  Consolidated Home feature (ViewModel + View)
//

import Foundation
import SwiftUI
import Combine

// MARK: - HomeViewModel

@MainActor
class HomeViewModel: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var totalCleanDays: Int = 0
    @Published var dailyInsight: String?
    @Published var activeBlocks: [String] = []
    @Published var showUrgeLog = false

    private let services: ServiceContainer

    init(services: ServiceContainer) {
        self.services = services
        loadData()
    }

    func loadData() {
        currentStreak = services.streakManager.currentStreak
        totalCleanDays = services.streakManager.totalCleanDays

        // Generate daily insight stub if user has 7+ clean days
        if totalCleanDays >= 7 {
            dailyInsight = generateDailyInsight()
        }

        Task {
            activeBlocks = await services.blockingService.getActiveBlocks()
        }
    }

    func refresh() {
        loadData()
    }

    private func generateDailyInsight() -> String {
        // Stub implementation - will be replaced with real insights later
        let insights = [
            "Your consistency is building strong habits. Keep going!",
            "You're \(totalCleanDays) days strong. Progress over perfection.",
            "Each day is a step forward. You're doing great.",
            "Your commitment to change is inspiring. Stay focused."
        ]
        return insights.randomElement() ?? insights[0]
    }
}

// MARK: - HomeView

struct HomeView: View {
    @EnvironmentObject var services: ServiceContainer
    @StateObject private var viewModel: HomeViewModel

    init(services: ServiceContainer) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(services: services))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: CGFloat.spacingXXL) {
                    // Hero stats
                    GlassCard {
                        VStack(alignment: .leading, spacing: CGFloat.spacingMD) {
                            Text("Current Streak")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.textPrimary)

                            Text("\(viewModel.currentStreak)")
                                .font(.system(size: 48, weight: .semibold, design: .monospaced))
                                .foregroundColor(.emerald)

                            // Total clean days
                            if viewModel.totalCleanDays > 0 {
                                Divider()
                                    .background(Color.textTertiary.opacity(0.3))
                                    .padding(.vertical, CGFloat.spacingXS)

                                HStack {
                                    Text("Total Clean Days")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.textSecondary)
                                    Spacer()
                                    Text("\(viewModel.totalCleanDays)")
                                        .font(.system(size: 18, weight: .semibold, design: .monospaced))
                                        .foregroundColor(.emerald)
                                }
                            }
                        }
                    }

                    // Daily insight card (show after 7+ days)
                    if let insight = viewModel.dailyInsight {
                        GlassCard {
                            VStack(alignment: .leading, spacing: CGFloat.spacingSM) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(.emerald)
                                        .font(.system(size: 16))
                                    Text("Daily Insight")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.textPrimary)
                                }

                                Text(insight)
                                    .font(.system(size: 15))
                                    .foregroundColor(.textSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }

                    // Quick actions - 2x2 grid
                    VStack(spacing: CGFloat.spacingMD) {
                        Text("Quick Actions")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Grid layout
                        VStack(spacing: CGFloat.spacingMD) {
                            HStack(spacing: CGFloat.spacingMD) {
                                // AI Coach
                                NavigationLink {
                                    AICoachView(services: services)
                                } label: {
                                    QuickActionCard(
                                        icon: "brain.head.profile",
                                        title: "AI Coach",
                                        color: .emerald
                                    )
                                }

                                // Log Urge
                                Button {
                                    viewModel.showUrgeLog = true
                                } label: {
                                    QuickActionCard(
                                        icon: "exclamationmark.triangle.fill",
                                        title: "Log Urge",
                                        color: .orange
                                    )
                                }
                            }

                            HStack(spacing: CGFloat.spacingMD) {
                                // Quick Block
                                NavigationLink {
                                    BlockingView(services: services)
                                } label: {
                                    QuickActionCard(
                                        icon: "shield.fill",
                                        title: "Quick Block",
                                        color: .blue
                                    )
                                }

                                // View Patterns
                                NavigationLink {
                                    AnalyticsView(services: services)
                                } label: {
                                    QuickActionCard(
                                        icon: "chart.bar.fill",
                                        title: "View Patterns",
                                        color: .purple
                                    )
                                }
                            }
                        }
                    }
                }
                .padding(CGFloat.spacingXL)
            }
            .background(Color.primaryBg)
            .navigationTitle("Anchor")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView(services: services)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showUrgeLog) {
                UrgeLogView(services: services)
            }
        }
    }
}

// MARK: - QuickActionCard

struct QuickActionCard: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        VStack(spacing: CGFloat.spacingMD) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)

            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

// MARK: - UrgeLogView

struct UrgeLogView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: UrgeLogViewModel

    init(services: ServiceContainer) {
        _viewModel = StateObject(wrappedValue: UrgeLogViewModel(services: services))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: CGFloat.spacingLG) {
                    // Notes
                    VStack(alignment: .leading, spacing: CGFloat.spacingSM) {
                        Text("What triggered this urge?")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)

                        TextEditor(text: $viewModel.notes)
                            .frame(height: 120)
                            .padding(CGFloat.spacingSM)
                            .background(Color.textTertiary.opacity(0.1))
                            .cornerRadius(12)
                            .foregroundColor(.textPrimary)
                    }

                    // Common triggers
                    VStack(alignment: .leading, spacing: CGFloat.spacingSM) {
                        Text("Common Triggers")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)

                        FlowLayout(spacing: CGFloat.spacingSM) {
                            ForEach(viewModel.commonTriggers, id: \.self) { trigger in
                                Button {
                                    viewModel.toggleTrigger(trigger)
                                } label: {
                                    Text(trigger)
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.horizontal, CGFloat.spacingMD)
                                        .padding(.vertical, CGFloat.spacingSM)
                                        .background(viewModel.selectedTriggers.contains(trigger) ? Color.emerald : Color.textTertiary.opacity(0.1))
                                        .foregroundColor(viewModel.selectedTriggers.contains(trigger) ? .white : .textSecondary)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }

                    // Was this a relapse?
                    Toggle("This was a relapse", isOn: $viewModel.wasRelapse)
                        .tint(.emerald)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    // Save button
                    Button {
                        viewModel.saveLog()
                        dismiss()
                    } label: {
                        Text("Save Log")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.emerald)
                            .cornerRadius(12)
                    }
                }
                .padding(CGFloat.spacingXL)
            }
            .background(Color.primaryBg)
            .navigationTitle("Log Urge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }
            }
        }
    }
}

// MARK: - UrgeLogViewModel

@MainActor
class UrgeLogViewModel: ObservableObject {
    @Published var notes: String = ""
    @Published var selectedTriggers: Set<String> = []
    @Published var wasRelapse: Bool = false

    let commonTriggers = [
        "Stress",
        "Boredom",
        "Loneliness",
        "Anxiety",
        "Social Media",
        "Late Night",
        "Tired",
        "Other"
    ]

    private let services: ServiceContainer

    init(services: ServiceContainer) {
        self.services = services
    }

    func toggleTrigger(_ trigger: String) {
        if selectedTriggers.contains(trigger) {
            selectedTriggers.remove(trigger)
        } else {
            selectedTriggers.insert(trigger)
        }
    }

    func saveLog() {
        // TODO: Save to persistence layer
        let log = UrgeLog(
            id: UUID().uuidString,
            timestamp: Date(),
            triggers: Array(selectedTriggers),
            notes: notes.isEmpty ? nil : notes,
            wasRelapse: wasRelapse
        )

        // If relapse, reset streak
        if wasRelapse {
            services.streakManager.resetStreak()
        }
    }
}

// MARK: - FlowLayout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}
