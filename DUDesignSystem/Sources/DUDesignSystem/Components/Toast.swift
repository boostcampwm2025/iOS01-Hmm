//
//  Toast.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/7/26.
//

import SwiftUI

public struct Toast: ViewModifier {

    @Binding var isShowing: Bool
    public let message: String
    public let anchorY: CGFloat

    @State private var showContent: Bool = false
    @State private var opacity: Double = 0

    public init(
        isShowing: Binding<Bool>,
        message: String,
        anchorY: CGFloat = 0
    ) {
        self._isShowing = isShowing
        self.message = message
        self.anchorY = anchorY
    }

    public func body(content: Content) -> some View {
        ZStack {
            content

            if showContent {
                GeometryReader { geo in
                    ItemLabel(text: message, font: .body2, color: .white300)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, TokenSpacing.mm)
                        .background(
                            LinearGradient(
                                stops: [
                                    .init(color: Color.black300.opacity(0.2), location: 0),
                                    .init(color: Color.black300.opacity(0.7), location: 0.5),
                                    .init(color: Color.black300.opacity(0.2), location: 1)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(opacity)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, anchorY > 0 ? geo.size.height - anchorY + geo.frame(in: .global).minY : 0)
                }
            }
        }
        .onChange(of: isShowing) { _, newValue in
            if newValue {
                showContent = true

                withAnimation(.easeOut(duration: 0.3)) {
                    opacity = 1
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        opacity = 0
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showContent = false
                        isShowing = false
                    }
                }
            }
        }
    }
}

public extension View {
    func duToast(isShowing: Binding<Bool>, message: String, anchorY: CGFloat = 0) -> some View {
        modifier(Toast(isShowing: isShowing, message: message, anchorY: anchorY))
    }
}
