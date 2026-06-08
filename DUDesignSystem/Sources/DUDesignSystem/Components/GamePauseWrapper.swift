//
//  GamePauseWrapper.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/8/26.
//

import SwiftUI

public struct GamePauseWrapper: ViewModifier {

    @Environment(\.scenePhase) private var scenePhase
    @State private var isPaused: Bool = false

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
                .blur(radius: isPaused ? 2 : 0)
            if isPaused {
                pauseOverlay
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
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
                .fill(.white.opacity(0.5))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture { }

            HStack(spacing: 50) {
                pauseButton(title: "나가기", icon: .cancel, action: handleLeave)
                pauseButton(title: "계속하기", icon: .play, action: handleResume)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func pauseButton(title: String, icon: DUIconName, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: TokenSpacing.sm) {
                DUIcon(icon, size: .size28)
                Text(title)
                    .duFont(.title2)
                    .foregroundStyle(Color.black300)
            }
        }
    }

    private func handlePauseRequested() {
        isPaused = true
        onPause()
    }

    private func handleLeave() {
        guard isPaused else { return }
        onLeave()
    }

    private func handleResume() {
        guard isPaused else { return }
        isPaused = false
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
