//
//  PopupModifier.swift
//  DUDesignSystem
//
//  Created by sunjae on 6/29/26.
//


import SwiftUI

public struct PopupModifier<Popup: View>: ViewModifier {

    private let isPresented: Bool
    private let backgroundColor: Color
    private let onBackgroundTap: (() -> Void)?
    private let popup: () -> Popup

    public init(
        isPresented: Bool,
        backgroundColor: Color,
        onBackgroundTap: (() -> Void)? = nil,
        @ViewBuilder popup: @escaping () -> Popup
    ) {
        self.isPresented = isPresented
        self.backgroundColor = backgroundColor
        self.onBackgroundTap = onBackgroundTap
        self.popup = popup
    }

    public func body(content: Content) -> some View {
        ZStack {
            content
                .transaction { parent in
                    parent.animation = nil
                }

            if isPresented {
                backgroundColor
                    .ignoresSafeArea()
                    .onTapGesture {
                        onBackgroundTap?()
                    }

                popup()
                    .transition(TokenTransition.scale.effect)
            }
        }
        .animation(TokenTransition.scale.animation, value: isPresented)
    }
}

public extension View {
    func duPopup<Popup: View>(
        isPresented: Bool,
        backgroundColor: Color = .black300PopUpDimStatusBar,
        onBackgroundTap: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Popup
    ) -> some View {
        modifier(
            PopupModifier(
                isPresented: isPresented,
                backgroundColor: backgroundColor,
                onBackgroundTap: onBackgroundTap,
                popup: content
            )
        )
    }
}
