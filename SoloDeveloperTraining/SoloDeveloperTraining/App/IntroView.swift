//
//  IntroView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI

struct IntroView: View {
    @State private var isBlinking = false
    @Binding var hasSeenIntro: Bool
    @Binding var showNicknameSetup: Bool
    let user: User?

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image(.appLaunchScreen)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }

            VStack {
                Spacer()

                Text("화면을 터치해 주세요")
                    .textStyle(.largeTitle)
                    .foregroundColor(.white)
                    .opacity(isBlinking ? 0.3 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isBlinking)
                    .padding(.bottom, 100)
            }
        }
        .onTapGesture {
            if user == nil {
                showNicknameSetup = true
            } else {
                withAnimation(.easeOut(duration: 0.5)) {
                    hasSeenIntro = true
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            isBlinking = true
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
