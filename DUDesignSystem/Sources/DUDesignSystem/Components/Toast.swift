//
//  Toast.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/7/26.
//

import SwiftUI

public struct ToastModifier: ViewModifier {

    @Binding var isShowing: Bool
    public let message: String

    @State private var showContent: Bool = false
    @State private var opacity: Double = 0

    public init(
        isShowing: Binding<Bool>,
        message: String
    ) {
        self._isShowing = isShowing
        self.message = message
    }

    public func body(content: Content) -> some View {
        ZStack {
            content

            if showContent {
                VStack {
                    Spacer()

                    Toast(message: message)
                        .opacity(opacity)
                        .padding(.bottom, TokenSpacing.xxl)
                        .frame(maxWidth: .infinity)
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
    func duToast(isShowing: Binding<Bool>, message: String) -> some View {
        modifier(ToastModifier(isShowing: isShowing, message: message))
    }
}

struct Toast: View {
   var message: String

    init(message: String) {
        self.message = message
    }

    var body: some View {
        ItemLabel(text: message, font: .body2, color: .white300)
            .frame(maxWidth: .infinity)
            .padding(.vertical, TokenSpacing.mm)
            .background(Color.black300.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
            .tokenShadow(.dim)
            .padding(.horizontal, TokenGrid.marginPopUp)
        
    }
}

#Preview {
    VStack(spacing: TokenSpacing.md) {
        Toast(message: "토스트 안내 메시지입니다.")
        Toast(message: "저장되었습니다.")
    }
    .background(Color.beige200)
}
