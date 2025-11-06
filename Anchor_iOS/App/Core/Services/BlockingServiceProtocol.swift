//
//  BlockingServiceProtocol.swift
//  Anchor_iOS
//
//  Protocol for app blocking service
//

import Foundation

enum BlockingError: Error {
    case permissionDenied
    case invalidDuration
    case systemError(Error)
}

protocol BlockingServiceProtocol {
    func blockApps(_ appIdentifiers: [String], duration: TimeInterval) async -> Result<Void, BlockingError>
    func unblockApps() async -> Result<Void, BlockingError>
    func getActiveBlocks() async -> [String]
}

