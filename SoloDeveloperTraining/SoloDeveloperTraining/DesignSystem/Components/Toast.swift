//
//  Toast.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import SwiftUI

private enum Constant {
    static let cornerRadius: CGFloat = 6

    enum Padding {
        static let horizontal: CGFloat = 16
        static let vertical: CGFloat = 10
        static let bottom: CGFloat = 20
    }

    enum Width {
        static let maxRatio: CGFloat = 0.7
    }

    enum Shadow {
        static let color: Color = AppColors.gray400
        static let radius: CGFloat = 4
        static let yOffset: CGFloat = 3
    }

    enum Animation {
        static let showDuration: CGFloat = 0.3
        static let hideDuration: CGFloat = 0.3
    }
}

struct Toast: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let duration: Double

    @State private var showContent: Bool = false
    @State private var opacity: Double = 0

    func body(content: Content) -> some View {
        ZStack {
            content

            if showContent {
                VStack {
                    Spacer()
                    Text(message)
                        .textStyle(.callout)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, Constant.Padding.horizontal)
                        .padding(.vertical, Constant.Padding.vertical)
                        .background(AppColors.orange300)
                        .foregroundColor(.white)
                        .cornerRadius(Constant.cornerRadius)
                        .shadow(color: Constant.Shadow.color,
                                radius: Constant.Shadow.radius,
                                y: Constant.Shadow.yOffset)
                        .frame(maxWidth: UIScreen.main.bounds.width * Constant.Width.maxRatio)
                        .padding(.bottom, Constant.Padding.bottom)
                        .opacity(opacity)
                }
            }
        }
        .onChange(of: isShowing) { _, newValue in
            if newValue {
                // 토스트 나타날 때
                showContent = true
                withAnimation(.easeOut(duration: Constant.Animation.showDuration)) {
                    opacity = 1
                }

                // duration 후 사라지게 함
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    // 부드럽게 사라지는 애니메이션
                    withAnimation(.easeIn(duration: Constant.Animation.hideDuration)) {
                        opacity = 0
                    }

                    // 애니메이션 완료 후 뷰 제거 및 바인딩 리셋
                    DispatchQueue.main.asyncAfter(deadline: .now() + Constant.Animation.hideDuration) {
                        showContent = false
                        isShowing = false
                    }
                }
            }
        }
    }
}

#Preview {
    struct ToastPreview: View {
        @State private var shortToast: Bool = false
        @State private var longToast: Bool = false

        var body: some View {
            VStack(spacing: 50) {
                VStack(spacing: 10) {
                    Button("짧은 메시지 표시") {
                        shortToast = true
                    }
                    .withTapSound()
                    Text("짧은 메시지 테스트")
                        .toast(isShowing: $shortToast, message: "짧은 토스트 메시지입니다.")
                }

                VStack(spacing: 10) {
                    Button("긴 메시지 표시") {
                        longToast = true
                    }
                    .withTapSound()
                    Text("긴 메시지 테스트")
                        .toast(isShowing: $longToast, message: "긴 토스트 메시지입니다. 이 메시지는 길어서 줄바꿈과 최대 너비가 적용되는지 확인하는 테스트용입니다.")
                }
            }
            .padding()
        }
    }

    return ToastPreview()
}
