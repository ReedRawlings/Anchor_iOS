//
//  UrgeLogRepositoryProtocol.swift
//  Anchor_iOS
//
//  Protocol for urge log repository
//

import Foundation

protocol UrgeLogRepositoryProtocol {
    func getAllLogs() async -> [UrgeLog]
    func getLogs(from startDate: Date, to endDate: Date) async -> [UrgeLog]
    func saveLog(_ log: UrgeLog) async throws
    func deleteLog(_ id: String) async throws
}

