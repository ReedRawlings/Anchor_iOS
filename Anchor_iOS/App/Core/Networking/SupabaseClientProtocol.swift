//
//  SupabaseClientProtocol.swift
//  Anchor_iOS
//
//  Protocol for Supabase client
//

import Foundation

enum SupabaseError: Error {
    case authenticationFailed
    case networkError(Error)
    case invalidResponse
    case encryptionFailed
}

protocol SupabaseClientProtocol {
    func authenticate(email: String, password: String) async -> Result<String, SupabaseError>
    func saveConversation(_ conversationId: String, messages: [AIMessage], encrypted: Bool) async -> Result<Void, SupabaseError>
    func getConversations() async -> Result<[String], SupabaseError>
    func deleteAccount() async -> Result<Void, SupabaseError>
}

