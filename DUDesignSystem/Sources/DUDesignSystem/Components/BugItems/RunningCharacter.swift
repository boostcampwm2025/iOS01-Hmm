//
//  RunningCharacter.swift
//  DUDesignSystem
//
//  Created by 김성훈 on 6/22/26.
//

import SwiftUI

public struct RunningCharacter: View {

    public static let size: CGFloat = 64

    private enum Constant {
        static let animationSpeed: TimeInterval = 0.15
    }

    @State private var currentFrame = 0
    @State private var animationTimer: Timer?

    private let frameImages: [String] = [
        "dodge_character1",
        "dodge_character2",
        "dodge_character3",
        "dodge_character2"
    ]

    public var isFacingLeft: Bool
    public var isGamePaused: Bool

    public init(isFacingLeft: Bool = false, isGamePaused: Bool) {
        self.isFacingLeft = isFacingLeft
        self.isGamePaused = isGamePaused
    }

    public var body: some View {
        Image(frameImages[currentFrame], bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: Self.size, height: Self.size)
            .scaleEffect(x: isFacingLeft ? -1 : 1, y: 1)
            .onAppear {
                handleAnimation()
            }
            .onDisappear {
                stopAnimation()
            }
            .onChange(of: isGamePaused) { _, _ in
                handleAnimation()
            }
    }
}

private extension RunningCharacter {
    func handleAnimation() {
        if isGamePaused {
            stopAnimation()
        } else {
            startAnimation()
        }
    }

    func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: Constant.animationSpeed, repeats: true) { _ in
            Task { @MainActor in
                currentFrame = (currentFrame + 1) % frameImages.count
            }
        }
    }

    func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

#Preview {
    HStack(spacing: TokenSpacing.xl) {
        VStack {
            RunningCharacter(isFacingLeft: false, isGamePaused: false)
            ItemLabel(text: "오른쪽 →", font: .caption, color: .black300)
        }

        VStack {
            RunningCharacter(isFacingLeft: true, isGamePaused: false)
            ItemLabel(text: "← 왼쪽", font: .caption, color: .black300)
        }
    }
    .padding(TokenSpacing.lg)
    .background(Color.beige200)
}
