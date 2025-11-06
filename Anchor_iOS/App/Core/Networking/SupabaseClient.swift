//
//  SupabaseClient.swift
//  Anchor_iOS
//
//  Consolidated Supabase client (errors + protocol + implementation)
//

import Foundation

// MARK: - SupabaseError

enum SupabaseError: Error {
    case authenticationFailed
    case networkError(Error)
    case invalidResponse
    case encryptionFailed
}

// MARK: - SupabaseClientProtocol

protocol SupabaseClientProtocol {
    func authenticate(email: String, password: String) async -> Result<String, SupabaseError>
    func saveConversation(_ conversationId: String, messages: [AIMessage], encrypted: Bool) async -> Result<Void, SupabaseError>
    func getConversations() async -> Result<[String], SupabaseError>
    func deleteAccount() async -> Result<Void, SupabaseError>
}

// MARK: - SupabaseClient

@MainActor
class SupabaseClient: SupabaseClientProtocol {
    private var conversations: [String: [AIMessage]] = [:]

    func authenticate(email: String, password: String) async -> Result<String, SupabaseError> {
        // Stub: return mock session token
        return .success("stub-session-token")
    }

    func saveConversation(_ conversationId: String, messages: [AIMessage], encrypted: Bool) async -> Result<Void, SupabaseError> {
        // Stub: store in memory
        conversations[conversationId] = messages
        return .success(())
    }

    func getConversations() async -> Result<[String], SupabaseError> {
        // Stub: return conversation IDs
        return .success(Array(conversations.keys))
    }

    func deleteAccount() async -> Result<Void, SupabaseError> {
        // Stub: clear in-memory data
        conversations.removeAll()
        return .success(())
    }
}

