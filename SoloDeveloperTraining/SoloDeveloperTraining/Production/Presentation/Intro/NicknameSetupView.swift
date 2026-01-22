//
//  NicknameSetupView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI

struct NicknameSetupView: View {
    @State private var nickname: String = ""
    let onStart: (String) -> Void
    let onTutorial: (String) -> Void

    var body: some View {
        Popup(title: "닉네임 설정") {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("당신은 취직에 실패한 개발자.")
                        .textStyle(.body)
                        .foregroundColor(.black)

                    Text("... 이대로 물러설 수는 없다.")
                        .textStyle(.body)
                        .foregroundColor(.black)

                    Text("나의 꿈은 1인 개발자로 성공하기 ~!")
                        .textStyle(.body)
                        .foregroundColor(.black)
                }

                Text("내 이름은!!")
                    .textStyle(.body)
                    .foregroundColor(.black)

                TextField("닉네임", text: $nickname)
                    .font(.pfFont(.body))
                    .padding(.horizontal, 17)
                    .frame(height: 40)
                    .background(AppColors.gray100.opacity(0.3))
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    }
                    .padding(.bottom, 9)

                HStack(spacing: 15) {
                    MediumButton(title: "바로 시작", isFilled: false) {
                        onStart(nickname)
                    }

                    MediumButton(title: "튜토리얼", isFilled: true, hasBadge: true) {
                        onTutorial(nickname)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(20)
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.5)
            .ignoresSafeArea()

        NicknameSetupView(
            onStart: { nickname in
                print("시작: \(nickname)")
            },
            onTutorial: { nickname in
                print("튜토리얼: \(nickname)")
            }
        )
        .padding()
    }
}
