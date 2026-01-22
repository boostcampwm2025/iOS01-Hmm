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
}

struct Toast: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let duration: Double

    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
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
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                withAnimation {
                                    isShowing = false
                                }
                            }
                        }
                        .padding(.bottom, Constant.Padding.bottom)
                }
                .animation(.easeInOut, value: isShowing)
            }
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, message: String, duration: Double = 2) -> some View {
        self.modifier(Toast(isShowing: isShowing, message: message, duration: duration))
    }
}

#Preview {
    struct ToastPreview: View {
        @State private var shortToast: Bool = true
        @State private var longToast: Bool = true

        var body: some View {
            VStack(spacing: 50) {
                VStack(spacing: 10) {
                    Button("짧은 메시지 토글") {
                        withAnimation {
                            shortToast.toggle()
                        }
                    }
                    Text("짧은 메시지 테스트")
                        .toast(isShowing: $shortToast, message: "짧은 토스트 메시지입니다.")
                }

                VStack(spacing: 10) {
                    Button("긴 메시지 토글") {
                        withAnimation {
                            longToast.toggle()
                        }
                    }
                    Text("긴 메시지 테스트")
                        .toast(isShowing: $longToast, message: "긴 토스트 메시지입니다. 이 메시지는 길어서 줄바꿈과 최대 너비가 적용되는지 확인하는 테스트용입니다.")
                }
            }
            .padding()
        }
    }

    return ToastPreview()
}
