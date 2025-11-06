//
//  GoalsTriggersScreen.swift
//  Anchor_iOS
//
//  Goals and Triggers selection screen
//

import SwiftUI

struct GoalsTriggersScreen: View {
    @Binding var selectedGoals: [String]
    @Binding var selectedTriggers: [String]
    let onContinue: () -> Void
    let onBack: () -> Void

    private let availableGoals = [
        "Build healthier habits",
        "Improve relationships",
        "Focus on personal growth",
        "Better mental health",
        "Reclaim my time",
        "Be more present"
    ]

    private let availableTriggers = [
        "Boredom",
        "Stress/Anxiety",
        "Loneliness",
        "Late night browsing",
        "Social media",
        "After work/school",
        "Morning routine",
        "Specific websites"
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: CGFloat.spacingXXXL) {
                // Header
                VStack(spacing: CGFloat.spacingMD) {
                    Text("What brings you here?")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)

                    Text("Select your goals and common triggers")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, CGFloat.spacingXXXL)
                .padding(.horizontal, CGFloat.spacingXXL)

                // Goals Section
                VStack(alignment: .leading, spacing: CGFloat.spacingLG) {
                    Text("My Goals")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.textPrimary)

                    FlowLayout(spacing: CGFloat.spacingSM) {
                        ForEach(availableGoals, id: \.self) { goal in
                            SelectableChip(
                                title: goal,
                                isSelected: selectedGoals.contains(goal)
                            ) {
                                toggleSelection(item: goal, in: &selectedGoals)
                            }
                        }
                    }
                }
                .padding(.horizontal, CGFloat.spacingXXL)

                // Triggers Section
                VStack(alignment: .leading, spacing: CGFloat.spacingLG) {
                    Text("Common Triggers")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.textPrimary)

                    FlowLayout(spacing: CGFloat.spacingSM) {
                        ForEach(availableTriggers, id: \.self) { trigger in
                            SelectableChip(
                                title: trigger,
                                isSelected: selectedTriggers.contains(trigger)
                            ) {
                                toggleSelection(item: trigger, in: &selectedTriggers)
                            }
                        }
                    }
                }
                .padding(.horizontal, CGFloat.spacingXXL)

                Spacer(minLength: CGFloat.spacingXXXL)
            }
        }
        .background(Color.primaryBg)
        .safeAreaInset(edge: .bottom) {
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
    }

    private var canContinue: Bool {
        !selectedGoals.isEmpty && !selectedTriggers.isEmpty
    }

    private func toggleSelection(item: String, in array: inout [String]) {
        if let index = array.firstIndex(of: item) {
            array.remove(at: index)
        } else {
            array.append(item)
        }
    }
}

// MARK: - Selectable Chip Component

struct SelectableChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(isSelected ? .black : .textPrimary)
                .padding(.horizontal, CGFloat.spacingLG)
                .padding(.vertical, CGFloat.spacingMD)
                .background(
                    isSelected
                        ? Color.emerald
                        : Color.white.opacity(0.05)
                )
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isSelected ? Color.clear : Color.emerald.opacity(0.3),
                            lineWidth: 2
                        )
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Flow Layout for wrapping chips

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

                if x + size.width > maxWidth, x > 0 {
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

// MARK: - Scale Button Style

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var goals: [String] = []
        @State private var triggers: [String] = []

        var body: some View {
            GoalsTriggersScreen(
                selectedGoals: $goals,
                selectedTriggers: $triggers,
                onContinue: {},
                onBack: {}
            )
        }
    }

    return PreviewWrapper()
}
