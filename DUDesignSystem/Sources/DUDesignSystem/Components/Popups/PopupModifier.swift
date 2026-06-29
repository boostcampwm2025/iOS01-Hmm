//
//  PopupModifier.swift
//  DUDesignSystem
//
//  Created by sunjae on 6/29/26.
//


import SwiftUI

public struct PopupModifier<Popup: View>: ViewModifier {

    @Binding private var isPresented: Bool
    private let popup: () -> Popup
    private let backgroundColor: Color


    public init(
        isPresented: Binding<Bool>,
        @ViewBuilder popup: @escaping () -> Popup,
        backgroundColor: Color
    ) {
        self._isPresented = isPresented
        self.popup = popup
        self.backgroundColor = backgroundColor
    }

    public func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                backgroundColor
                    .ignoresSafeArea()

                popup()
                    .transition(TokenTransition.scale.effect)
            }
        }
        .animation(
            TokenTransition.scale.animation,
            value: isPresented
        )
    }
}

public extension View {
    func duPopup<Popup: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Popup,
        backgroundColor: Color = .black300PopUpDimStatusBar
    ) -> some View {
        modifier(
            PopupModifier(
                isPresented: isPresented,
                popup: content,
                backgroundColor: backgroundColor
            )
        )
    }
}
