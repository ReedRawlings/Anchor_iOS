//
//  BlockingView.swift
//  Anchor_iOS
//
//  Blocking management view
//

import SwiftUI

struct BlockingView: View {
    @StateObject private var viewModel: BlockingViewModel
    
    init(services: ServiceContainer) {
        _viewModel = StateObject(wrappedValue: BlockingViewModel(services: services))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Blocking Management")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Text("App selection and duration picker coming soon")
                    .foregroundColor(.textSecondary)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryBg)
            .navigationTitle("Blocking")
        }
    }
}

