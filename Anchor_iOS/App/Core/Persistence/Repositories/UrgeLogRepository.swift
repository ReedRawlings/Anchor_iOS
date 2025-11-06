//
//  UrgeLogRepository.swift
//  Anchor_iOS
//
//  In-memory implementation of urge log repository
//

import Foundation

@MainActor
class UrgeLogRepository: UrgeLogRepositoryProtocol {
    private var logs: [UrgeLog] = []
    
    func getAllLogs() async -> [UrgeLog] {
        return logs
    }
    
    func getLogs(from startDate: Date, to endDate: Date) async -> [UrgeLog] {
        return logs.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
    }
    
    func saveLog(_ log: UrgeLog) async throws {
        logs.append(log)
    }
    
    func deleteLog(_ id: String) async throws {
        logs.removeAll { $0.id == id }
    }
}

