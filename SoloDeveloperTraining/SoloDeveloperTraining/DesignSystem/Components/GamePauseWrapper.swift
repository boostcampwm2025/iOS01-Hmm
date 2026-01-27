//
//  GamePauseWrapper.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/27/26.
//

import SwiftUI

private enum Constant {
    static let opacity: Double = 0.5
    static let animation: Animation = .easeOut(duration: 0.25)
    static let blurRadius: CGFloat = 2
    static let iconSize: CGFloat = 28

    enum Spacing {
        static let buttonHorizontal: CGFloat = 32
        static let iconTextHorizontal: CGFloat = 8
    }

    enum ButtonText {
        static let leave: String = "나가기"
        static let resume: String = "계속하기"
    }
}

struct GamePauseWrapper: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPaused: Bool = false

    @Binding var isGameViewDisappeared: Bool
    let height: CGFloat
    let onLeave: () -> Void
    let onPause: () -> Void
    let onResume: () -> Void

    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: isPaused ? Constant.blurRadius : 0)
            if isPaused {
                pauseOverlay
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            handleScenePhase(oldPhase: oldPhase, newPhase: newPhase)
        }
        .onChange(of: isGameViewDisappeared) { _, newValue in
            if newValue {
                handleGameViewDisappeard()
            }
        }
    }
}

// MARK: - Pause Overlay
private extension GamePauseWrapper {
    var pauseOverlay: some View {
        ZStack {
            Rectangle()
                .fill(.white.opacity(Constant.opacity))
                .frame(height: height)
                .contentShape(Rectangle())
                .onTapGesture { } // 배경 터치 무효화

            HStack(spacing: Constant.Spacing.buttonHorizontal) {
                pauseButton(
                    title: Constant.ButtonText.leave,
                    iconImage: .iconCancel,
                    action: handleLeave
                )

                pauseButton(
                    title: Constant.ButtonText.resume,
                    iconImage: .iconPlay,
                    action: handleResume
                )
            }
        }
        .frame(maxWidth: .infinity)
    }

    func pauseButton(
        title: String,
        iconImage: ImageResource,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: Constant.Spacing.iconTextHorizontal) {
                Image(iconImage)
                    .resizable()
                    .frame(width: Constant.iconSize, height: Constant.iconSize)
                Text(title)
                    .textStyle(.title2)
                    .foregroundStyle(.black)
            }
        }
    }
}

// MARK: - Actions
private extension GamePauseWrapper {
    func handleGameViewDisappeard() {
        isPaused = true
        onPause()
    }

    func handleScenePhase(oldPhase: ScenePhase, newPhase: ScenePhase) {
        // 앱이 비활성 상태로 갈 때 즉시 일시정지
        if newPhase != .active {
            handleGameViewDisappeard()
        }
    }

    func handleLeave() {
        guard isPaused else { return }
        isPaused = false
        onLeave()
    }

    func handleResume() {
        guard isPaused else { return }
        isPaused = false
        onResume()
    }
}
