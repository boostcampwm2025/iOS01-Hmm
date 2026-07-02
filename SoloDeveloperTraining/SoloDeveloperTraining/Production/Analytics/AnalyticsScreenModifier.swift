//
//  AnalyticsScreenModifier.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 7/3/26.
//


import SwiftUI

private struct AnalyticsScreenModifier: ViewModifier {

    let screen: String

    func body(content: Content) -> some View {
        content.onAppear {
            AnalyticsService.shared.enterScreen(screen)
        }
    }
}

extension View {
    func analyticsScreen(_ screen: ScreenID) -> some View {
        modifier(AnalyticsScreenModifier(screen: screen.rawValue))
    }

    func analyticsScreen(_ screen: String) -> some View {
        modifier(AnalyticsScreenModifier(screen: screen))
    }
}
