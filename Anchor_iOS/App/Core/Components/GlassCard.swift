//
//  GlassCard.swift
//  Anchor_iOS
//
//  Reusable glass card component following design system
//

import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(CGFloat.spacingLG)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
    }
}

