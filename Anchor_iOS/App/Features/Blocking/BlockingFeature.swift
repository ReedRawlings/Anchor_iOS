//
//  BlockingFeature.swift
//  Anchor_iOS
//
//  Consolidated Blocking feature (ViewModel + View)
//

import Foundation
import SwiftUI
import Combine

// MARK: - BlockingViewModel

@MainActor
class BlockingViewModel: ObservableObject {
    @Published var selectedApps: [String] = []
    @Published var duration: TimeInterval = 3600 // 1 hour default
    @Published var activeBlocks: [String] = []

    private let services: ServiceContainer

    init(services: ServiceContainer) {
        self.services = services
        loadActiveBlocks()
    }

    func loadActiveBlocks() {
        Task {
            activeBlocks = await services.blockingService.getActiveBlocks()
        }
    }

    func applyBlock() {
        Task {
            let result = await services.blockingService.blockApps(selectedApps, duration: duration)
            switch result {
            case .success:
                loadActiveBlocks()
            case .failure:
                // TODO: Handle error
                break
            }
        }
    }

    func removeBlock() {
        Task {
            let _ = await services.blockingService.unblockApps()
            loadActiveBlocks()
        }
    }
}

// MARK: - BlockingView

struct BlockingView: View {
    @StateObject private var viewModel: BlockingViewModel

    init(services: ServiceContainer) {
        _viewModel = StateObject(wrappedValue: BlockingViewModel(services: services))
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Blocking Management")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.textPrimary)

                Text("App selection and duration picker coming soon")
                    .foregroundColor(.textSecondary)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryBg)
            .navigationTitle("Blocking")
        }
    }
}
