//
//  AICoachView.swift
//  Anchor_iOS
//
//  AI coach chat interface
//

import SwiftUI

struct AICoachView: View {
    @StateObject private var viewModel: AICoachViewModel
    
    init(services: ServiceContainer, isPanicMode: Bool = false) {
        _viewModel = StateObject(wrappedValue: AICoachViewModel(services: services, isPanicMode: isPanicMode))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Message list placeholder
                ScrollView {
                    ForEach(viewModel.messages, id: \.id) { message in
                        Text(message.content)
                            .padding()
                            .background(message.role == "user" ? Color.emerald : Color.elevatedBg)
                            .cornerRadius(16)
                    }
                }
                
                // Input field placeholder
                HStack {
                    TextField("Type a message...", text: $viewModel.inputText)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Send") {
                        viewModel.sendMessage()
                    }
                    .disabled(viewModel.inputText.isEmpty || viewModel.isLoading)
                }
                .padding()
            }
            .background(Color.primaryBg)
            .navigationTitle("Coach")
        }
    }
}

