//
//  QuizGameTestView.swift
//  SoloDeveloperTraining
//
//  Created by Claude on 1/21/26.
//

import SwiftUI

struct QuizGameTestView: View {
    @State private var isGameStarted = false
    @State private var user: User

    init() {
        self._user = State(initialValue: User(
            nickname: "퀴즈 테스터",
            wallet: Wallet(gold: 0, diamond: 100),
            inventory: Inventory(),
            record: Record(),
            skills: []
        ))
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            if isGameStarted {
                QuizGameTestContentView(user: user, isGameStarted: $isGameStarted)
            } else {
                VStack(spacing: 20) {
                    Text("퀴즈 게임 테스트")
                        .textStyle(.title)
                        .foregroundStyle(.black)

                    Text("현재 다이아: \(user.wallet.diamond)")
                        .textStyle(.headline)
                        .foregroundStyle(.gray)

                    LargeButton(title: "퀴즈 시작") {
                        isGameStarted = true
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    QuizGameTestView()
}
