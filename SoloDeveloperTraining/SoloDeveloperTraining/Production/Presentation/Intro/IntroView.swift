//
//  IntroView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI

private enum Constant {
    enum Animation {
        static let duration: Double = 1.0
    }

    enum Layout {
        static let bottomPadding: CGFloat = 100
    }

    enum Opacity {
        static let blinking: Double = 0.3
        static let normal: Double = 1.0
    }

    enum Text {
        static let touchPrompt = "화면을 터치해 주세요"
    }
}

struct IntroView: View {
    @State private var isBlinking = true
    @Binding var hasSeenIntro: Bool
    @Binding var showNicknameSetup: Bool
    let user: User?

    var body: some View {
        ZStack {
            backgroundImage
            touchPromptView
        }
        .onTapGesture {
            if user == nil {
                showNicknameSetup = true
            } else {
                withAnimation(.easeOut(duration: Constant.Animation.duration)) {
                    hasSeenIntro = true
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            isBlinking = false
        }
    }
}

private extension IntroView {
    var backgroundImage: some View {
        GeometryReader { geometry in
            Image(.appLaunchScreen)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
        }
    }

    var touchPromptView: some View {
        VStack {
            Spacer()

            Text(Constant.Text.touchPrompt)
                .textStyle(.title2)
                .foregroundColor(.white)
                .opacity(isBlinking ? Constant.Opacity.blinking : Constant.Opacity.normal)
                .animation(.easeInOut(duration: Constant.Animation.duration).repeatForever(autoreverses: true), value: isBlinking)
                .padding(.bottom, Constant.Layout.bottomPadding)
        }
    }
}

#Preview {
    IntroView(
        hasSeenIntro: .constant(false),
        showNicknameSetup: .constant(false),
        user: nil
    )
}
