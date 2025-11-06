//
//  PatternRepositoryProtocol.swift
//  Anchor_iOS
//
//  Protocol for pattern repository
//

import Foundation

protocol PatternRepositoryProtocol {
    func getAllPatterns() async -> [Pattern]
    func getPatterns(ofType type: PatternType) async -> [Pattern]
    func savePattern(_ pattern: Pattern) async throws
    func deletePattern(_ id: String) async throws
}

