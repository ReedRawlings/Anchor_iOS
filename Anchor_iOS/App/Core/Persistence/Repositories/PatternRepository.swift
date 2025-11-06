//
//  PatternRepository.swift
//  Anchor_iOS
//
//  In-memory implementation of pattern repository
//

import Foundation

@MainActor
class PatternRepository: PatternRepositoryProtocol {
    private var patterns: [Pattern] = []
    
    func getAllPatterns() async -> [Pattern] {
        return patterns
    }
    
    func getPatterns(ofType type: PatternType) async -> [Pattern] {
        return patterns.filter { $0.type == type }
    }
    
    func savePattern(_ pattern: Pattern) async throws {
        patterns.append(pattern)
    }
    
    func deletePattern(_ id: String) async throws {
        patterns.removeAll { $0.id == id }
    }
}

