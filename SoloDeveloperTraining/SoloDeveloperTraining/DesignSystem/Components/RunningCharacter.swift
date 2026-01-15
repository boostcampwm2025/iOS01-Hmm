//
//  RunningCharacter.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-15.
//

import SwiftUI

private enum Constant {
    static let animationSpeed: TimeInterval = 0.15
}

struct RunningCharacter: View {
    @State private var currentFrame = 0

    private let frameImages: [ImageResource] = [
        .dodgeCharacter1,
        .dodgeCharacter2,
        .dodgeCharacter3,
        .dodgeCharacter2
    ]

    let isFacingLeft: Bool

    /// 달리기 애니메이션 캐릭터 초기화
    /// - Parameters:
    ///   - isFacingLeft: 왼쪽을 향할지 여부 (기본값: false, 오른쪽 향함)
    init(isFacingLeft: Bool = false) {
        self.isFacingLeft = isFacingLeft
    }

    var body: some View {
        Image(frameImages[currentFrame])
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(x: isFacingLeft ? -1 : 1, y: 1)
            .onAppear {
                startAnimation()
            }
    }

    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: Constant.animationSpeed, repeats: true) { _ in
            currentFrame = (currentFrame + 1) % frameImages.count
        }
    }
}

#Preview {
    HStack(spacing: 40) {
        VStack {
            RunningCharacter(isFacingLeft: false)
                .frame(width: 40, height: 40)
            Text("오른쪽 →")
                .font(.caption)
        }

        VStack {
            RunningCharacter(isFacingLeft: true)
                .frame(width: 40, height: 40)
            Text("← 왼쪽")
                .font(.caption)
        }
    }
}
