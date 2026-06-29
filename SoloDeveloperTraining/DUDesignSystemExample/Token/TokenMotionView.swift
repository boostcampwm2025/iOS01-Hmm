//
//  TokenMotionView.swift
//  DUDesignSystemExample
//
//  Created by sunjae on 6/28/26.
//

import SwiftUI
import DUDesignSystem

struct TokenMotionView: View {
    var body: some View {
        List {
            Section {
                TransitionPreviewRow(name: "transitionOverlay", token: .overlay)
                TransitionPreviewRow(name: "transitionScale", token: .scale)
            } header: {
                Text("Transition")
                    .duFont(.caption)
                    .foregroundStyle(Color.gray400)
            }

            Section {
                AnimationPreviewRow(name: "fadeInSlow", token: .fadeInSlow)
                AnimationPreviewRow(name: "crossFade", token: .crossFade)
                FloatingFadeOutPreviewRow()
                AnimationPreviewRow(name: "offsetMove", token: .offsetMove)
                BlinkLoopPreviewRow()
                SpringMovePreviewRow()
            } header: {
                Text("Animation")
                    .duFont(.caption)
                    .foregroundStyle(Color.gray400)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.beige200)
        .navigationTitle("Motion")
    }
}

// MARK: - Transition Preview

private struct TransitionPreviewRow: View {
    let name: String
    let token: TokenTransition
    @State private var isVisible = false
    @State private var isPlaying = false

    var body: some View {
        HStack(spacing: TokenSpacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: TokenRadius.xs)
                    .stroke(Color.orange300, lineWidth: 1)

                if isVisible {
                    RoundedRectangle(cornerRadius: TokenRadius.xs)
                        .fill(Color.orange300)
                        .transition(token.effect)
                }
            }
            .frame(width: 44, height: 44)

            Text(name)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(Color.gray400)

            Spacer()

            Button {
                guard !isPlaying else { return } // 중복 탭 방지
                isPlaying = true
                withAnimation(token.animation) { // 생성
                    isVisible = true
                }

                DispatchQueue.main.asyncAfter(deadline:.now() + Double(token.duration.components.seconds)) { // 소멸
                    withAnimation(token.animation) {
                        isVisible = false
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { // 버튼 활성화
                    isPlaying = false
                }
            } label: {
                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                    .foregroundStyle(Color.orange300)
            }
        }
        .padding(.vertical, TokenSpacing.xx)
    }
}

// MARK: - Animation Preview

private struct AnimationPreviewRow: View {
    let name: String
    let token: TokenAnimation
    @State private var isAnimating = false
    @State private var isPlaying = false

    var body: some View {
        HStack(spacing: TokenSpacing.sm) {
            RoundedRectangle(cornerRadius: TokenRadius.xs)
                .fill(Color.orange300)
                .frame(width: 44, height: 44)
                .opacity(isAnimating ? 0 : 1)
                .animation(token.animation, value: isAnimating)

            Text(name)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(Color.gray400)

            Spacer()

            Button {
                guard !isPlaying else { return }
                isPlaying = true
                isAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    isAnimating = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    isPlaying = false
                }
            } label: {
                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                    .foregroundStyle(Color.orange300)
            }
        }
        .padding(.vertical, TokenSpacing.xx)
    }
}

// MARK: - FloatingFadeOut Preview

private struct FloatingFadeOutPreviewRow: View {
    @State private var isActive = true
    @State private var isPlaying = false

    var body: some View {
        HStack(spacing: TokenSpacing.sm) {
            RoundedRectangle(cornerRadius: TokenRadius.xs)
                .fill(Color.orange300)
                .frame(width: 44, height: 44)
                .floatingFadeOut(isActive: isActive)

            Text("floatingFadeOut")
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(Color.gray400)

            Spacer()

            Button {
                guard !isPlaying else { return }
                isPlaying = true
                isActive = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    isActive = true
                    isPlaying = false
                }
            } label: {
                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                    .foregroundStyle(Color.orange300)
            }
        }
        .padding(.vertical, TokenSpacing.xx)
    }
}

// MARK: - BlinkLoop Preview

private struct BlinkLoopPreviewRow: View {
    @State private var isPlaying = false

    var body: some View {
        HStack(spacing: TokenSpacing.sm) {
            RoundedRectangle(cornerRadius: TokenRadius.xs)
                .fill(Color.orange300)
                .frame(width: 44, height: 44)
                .blinkLoop(isPlaying: isPlaying)

            Text("blinkLoop")
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(Color.gray400)

            Spacer()

            Button {
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                    .foregroundStyle(Color.orange300)
            }
        }
        .padding(.vertical, TokenSpacing.xx)
    }
}

// MARK: - SpringMove Preview

private struct SpringMovePreviewRow: View {
    @State private var offset: CGFloat = 0
    @State private var isPlaying = false

    var body: some View {
        HStack(spacing: TokenSpacing.sm) {
            RoundedRectangle(cornerRadius: TokenRadius.xs)
                .fill(Color.orange300)
                .frame(width: 44, height: 44)
                .offset(x: offset)
                .animation(TokenAnimation.springMove.animation, value: offset)

            Text("springMove")
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(Color.gray400)

            Spacer()

            Button {
                guard !isPlaying else { return }
                isPlaying = true
                offset = 20
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    offset = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    isPlaying = false
                }
            } label: {
                Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                    .foregroundStyle(Color.orange300)
            }
        }
        .padding(.vertical, TokenSpacing.xx)
    }
}

#Preview {
    NavigationStack {
        TokenMotionView()
    }
}
