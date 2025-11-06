//
//  HomeViewModel.swift
//  Anchor_iOS
//
//  ViewModel for home dashboard
//

import Foundation
import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var totalCleanDays: Int = 0
    @Published var dailyInsight: String?
    @Published var activeBlocks: [String] = []
    
    private let services: ServiceContainer
    
    init(services: ServiceContainer) {
        self.services = services
        loadData()
    }
    
    func loadData() {
        currentStreak = services.streakManager.currentStreak
        totalCleanDays = services.streakManager.totalCleanDays
        Task {
            activeBlocks = await services.blockingService.getActiveBlocks()
        }
    }
    
    func refresh() {
        loadData()
    }
}

