//
//  PanicButtonView.swift
//  Anchor_iOS
//
//  Panic button flow view
//

import SwiftUI

struct PanicButtonView: View {
    @StateObject private var viewModel: PanicButtonViewModel
    
    init(services: ServiceContainer) {
        _viewModel = StateObject(wrappedValue: PanicButtonViewModel(services: services))
    }
    
    var body: some View {
        VStack {
            switch viewModel.currentStep {
            case .breathing:
                Text("Breathe")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                
            case .actionSelection:
                Text("What would help right now?")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
            case .actionExecution:
                Text("Action in progress...")
                    .foregroundColor(.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBg)
    }
}

