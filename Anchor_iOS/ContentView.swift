//
//  ContentView.swift
//  Anchor_iOS
//
//  Created by Reed Rawlings on 11/5/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var services: ServiceContainer
    @State private var showPanicButton = false
    
    var body: some View {
        NavigationStack {
            HomeView(services: services)
                .overlay(alignment: .bottomTrailing) {
                    // Panic button - floating, always accessible
                    Button {
                        showPanicButton = true
                    } label: {
                        Text("Panic")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.coralAlert)
                            .clipShape(Circle())
                            .shadow(color: Color.coralAlert.opacity(0.4), radius: 12, x: 0, y: 6)
                    }
                    .padding(CGFloat.spacingXL)
                    .sheet(isPresented: $showPanicButton) {
                        PanicButtonView(services: services)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ServiceContainer.createStub())
}
