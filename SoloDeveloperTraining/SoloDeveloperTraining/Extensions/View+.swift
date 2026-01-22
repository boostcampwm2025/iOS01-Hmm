//
//  View+.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import SwiftUI

extension View {
    func toast(isShowing: Binding<Bool>, message: String, duration: Double = 1.5) -> some View {
        self.modifier(Toast(isShowing: isShowing, message: message, duration: duration))
    }
}
