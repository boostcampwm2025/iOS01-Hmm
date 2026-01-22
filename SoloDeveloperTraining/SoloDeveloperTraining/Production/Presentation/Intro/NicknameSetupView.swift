//
//  NicknameSetupView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-21.
//

import SwiftUI

private enum Constant {
    enum Spacing {
        static let content: CGFloat = 10
        static let textGroup: CGFloat = 4
        static let button: CGFloat = 15
    }

    enum Size {
        static let textFieldHeight: CGFloat = 40
        static let cornerRadius: CGFloat = 10
        static let strokeLineWidth: CGFloat = 1
    }

    enum Layout {
        static let textFieldHorizontalPadding: CGFloat = 17
        static let textFieldBottomPadding: CGFloat = 9
        static let contentPadding: CGFloat = 20
    }

    enum Opacity {
        static let background: Double = 0.3
        static let stroke: Double = 0.3
    }
}

struct NicknameSetupView: View {
    @State private var nickname: String = ""
    let onStart: (String) -> Void
    let onTutorial: (String) -> Void

    var body: some View {
        Popup(title: "닉네임 설정") {
            VStack(alignment: .leading, spacing: Constant.Spacing.content) {
                storyTexts
                nicknameTextField
                buttons
            }
            .padding(Constant.Layout.contentPadding)
        }
    }
}

private extension NicknameSetupView {
    var storyTexts: some View {
        Text("당신은 취직에 실패한 개발자.\n... 이대로 물러설 수는 없다.\n나의 꿈은 1인 개발자로 성공하기 ~!\n\n내 이름은!!")
            .textStyle(.body)
            .foregroundColor(.black)
    }

    var nicknameTextField: some View {
        TextField("닉네임", text: $nickname)
            .font(.pfFont(.body))
            .padding(.horizontal, Constant.Layout.textFieldHorizontalPadding)
            .frame(height: Constant.Size.textFieldHeight)
            .background(AppColors.gray100.opacity(Constant.Opacity.background))
            .cornerRadius(Constant.Size.cornerRadius)
            .foregroundColor(.black)
            .overlay {
                RoundedRectangle(cornerRadius: Constant.Size.cornerRadius)
                    .stroke(Color.gray.opacity(Constant.Opacity.stroke), lineWidth: Constant.Size.strokeLineWidth)
            }
            .padding(.bottom, Constant.Layout.textFieldBottomPadding)
    }

    var buttons: some View {
        HStack(spacing: Constant.Spacing.button) {
            MediumButton(title: "바로 시작", isFilled: false) {
                onStart(nickname)
            }

            MediumButton(title: "튜토리얼", isFilled: true, hasBadge: true) {
                onTutorial(nickname)
            }
        }
        .frame(maxWidth: .infinity)
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
