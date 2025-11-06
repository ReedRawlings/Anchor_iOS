//
//  BlockingService.swift
//  Anchor_iOS
//
//  Consolidated blocking service (protocol + implementation + errors)
//

import Foundation

// MARK: - BlockingError

enum BlockingError: Error {
    case permissionDenied
    case invalidDuration
    case systemError(Error)
}

// MARK: - BlockingServiceProtocol

protocol BlockingServiceProtocol {
    func blockApps(_ appIdentifiers: [String], duration: TimeInterval) async -> Result<Void, BlockingError>
    func unblockApps() async -> Result<Void, BlockingError>
    func getActiveBlocks() async -> [String]
}

// MARK: - BlockingService

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

