//
//  IntroView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI
import DUDesignSystem

private enum Constant {
    enum Animation {
        static let transitionDuration: Double = 0.5
        static let blinkingDuration: Double = 1.0
    }
}

struct IntroView: View {
    @State private var isBlinking = true
    @State private var scenarioManager: ScenarioManager?

    @Binding var hasSeenIntro: Bool
    @Binding var showNicknameSetup: Bool

    let user: User?
    let scenarioRepository: ScenarioRepository
    var isPolicyReady: Bool
    var hasPolicyError: Bool
    var onRetry: () -> Void

    var body: some View {
        ZStack {
            backgroundImage
            if hasPolicyError {
                errorView
            } else if isPolicyReady {
                touchPromptView
            }
        }
        .onTapGesture {
            if hasPolicyError {
                onRetry()
                return
            }
            guard isPolicyReady else { return }

            if user == nil {
                guard let scenario = scenarioRepository.fetchScenario(for: .unemployed) else { return }

                let manager = ScenarioManager(record: Record())
                manager.startScenario(scenario)
                self.scenarioManager = manager
            } else {
                withAnimation(.easeOut(duration: Constant.Animation.transitionDuration)) {
                    hasSeenIntro = true
                }
            }
        }
        .fullScreenCover(item: $scenarioManager) { manager in
            ScenarioStoryView(
                user: nil,
                manager: manager,
                repository: scenarioRepository,
                backgroundColor: .black300,
                onComplete: {
                    scenarioManager = nil
                    hasSeenIntro = true
                    showNicknameSetup = true
                }
            )
        }
        .ignoresSafeArea()
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
            ItemLabel(text: "화면을 터치해 주세요.", font: .title2, color: .white300)
                .opacity(isBlinking ? TokenOpacity.opacity60 : TokenOpacity.opacity100)
                .animation(.easeInOut(duration: Constant.Animation.blinkingDuration).repeatForever(autoreverses: true), value: isBlinking)
                .padding(.bottom, TokenGrid.marginBottomLarge)
                .onAppear { isBlinking = false }
        }
    }

    var errorView: some View {
        VStack {
            Spacer()
            ItemLabel(text: "네트워크 오류가 발생했습니다.\n화면을 터치하여 재시도해 주세요.", font: .title2, color: .white300)
                .padding(.bottom, TokenGrid.marginBottomLarge)
        }
    }
}

#Preview {
    IntroView(
        hasSeenIntro: .constant(false),
        showNicknameSetup: .constant(false),
        user: nil,
        scenarioRepository: DefaultScenarioRepository(),
        isPolicyReady: true,
        hasPolicyError: false,
        onRetry: {}
    )
}
