//
//  BlockingService.swift
//  Anchor_iOS
//
//  Stub implementation of blocking service
//

import Foundation

@MainActor
class BlockingService: BlockingServiceProtocol {
    private var activeBlocks: [String] = []
    
    func blockApps(_ appIdentifiers: [String], duration: TimeInterval) async -> Result<Void, BlockingError> {
        // Stub: just store the identifiers
        activeBlocks = appIdentifiers
        return .success(())
    }
    
    func unblockApps() async -> Result<Void, BlockingError> {
        activeBlocks = []
        return .success(())
    }
    
    func getActiveBlocks() async -> [String] {
        return activeBlocks
    }
}

