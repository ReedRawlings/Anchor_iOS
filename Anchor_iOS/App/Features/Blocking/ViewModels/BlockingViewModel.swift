//
//  BlockingViewModel.swift
//  Anchor_iOS
//
//  ViewModel for blocking management
//

import Foundation
import SwiftUI

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

