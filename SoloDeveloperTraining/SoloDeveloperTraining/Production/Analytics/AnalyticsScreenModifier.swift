//
//  AnalyticsScreenModifier.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 7/3/26.
//


import SwiftUI

struct AnalyticsScreenModifier: ViewModifier {

    let screen: ScreenID

    func body(content: Content) -> some View {
        content
            .onAppear {
                AnalyticsService.shared.enterScreen(screen)
            }
    }
}

extension View {
    func analyticsScreen(_ screen: ScreenID) -> some View {
        modifier(AnalyticsScreenModifier(screen: screen))
    }
}