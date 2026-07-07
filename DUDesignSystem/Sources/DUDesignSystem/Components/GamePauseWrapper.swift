//
//  GamePauseWrapper.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/8/26.
//

import SwiftUI

public struct GamePauseWrapper: ViewModifier {

    @Environment(\.scenePhase) private var scenePhase

    @Binding public var pauseBinding: Bool

    public let onLeave: () -> Void
    public let onPause: () -> Void
    public let onResume: () -> Void

    public init(
        pauseBinding: Binding<Bool>,
        onLeave: @escaping () -> Void,
        onPause: @escaping () -> Void,
        onResume: @escaping () -> Void
    ) {
        self._pauseBinding = pauseBinding
        self.onLeave = onLeave
        self.onPause = onPause
        self.onResume = onResume
    }

    public func body(content: Content) -> some View {
        ZStack {
            content
            if pauseBinding {
                pauseOverlay
                    .transition(TokenTransition.overlay.effect)
            }
        }
        .animation(TokenTransition.overlay.animation, value: pauseBinding)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase != .active {
                handlePauseRequested()
            }
        }
        .onChange(of: pauseBinding) { _, newValue in
            if newValue {
                handlePauseRequested()
            }
        }
    }

    private var pauseOverlay: some View {
        ZStack {
            Rectangle()
                .fill(Color.white300StatusBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture { }

            HStack(spacing: TokenSpacing.xl) {
                pauseButton(title: "나가기", icon: .cancel, action: handleLeave)
                pauseButton(title: "계속하기", icon: .play, action: handleResume)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func pauseButton(title: String, icon: DUIconName, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ItemLabel(text: title, icon: icon, iconSize: .size28, font: .title2, color: .black300)
                .padding(TokenSpacing.sm)
        }
    }

    private func handlePauseRequested() {
        pauseBinding = true
        onPause()
    }

    private func handleLeave() {
        guard pauseBinding else { return }
        onLeave()
    }

    private func handleResume() {
        guard pauseBinding else { return }
        pauseBinding = false
        onResume()
    }
}

public extension View {
    func gamePauseWrapper(
        pauseBinding: Binding<Bool>,
        onLeave: @escaping () -> Void,
        onPause: @escaping () -> Void = {},
        onResume: @escaping () -> Void = {}
    ) -> some View {
        modifier(GamePauseWrapper(
            pauseBinding: pauseBinding,
            onLeave: onLeave,
            onPause: onPause,
            onResume: onResume
        ))
    }
}
