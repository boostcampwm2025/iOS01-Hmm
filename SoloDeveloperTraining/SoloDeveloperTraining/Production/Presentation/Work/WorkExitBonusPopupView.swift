//
//  WorkExitBonusPopupView.swift
//  SoloDeveloperTraining
//
//  Created by Codex on 5/22/26.
//

import SwiftUI

private enum Constant {
    enum Spacing {
        static let content: CGFloat = 11
        static let buttonHorizontal: CGFloat = 15
    }

    enum Padding {
        static let messageHorizontal: CGFloat = 20
        static let messageBottom: CGFloat = 50
    }
}

struct WorkExitBonusPopupView: View {
    let onWatchAd: () -> Void
    let onLeave: () -> Void

    var body: some View {
        Popup(title: "보너스") {
            VStack(spacing: Constant.Spacing.content) {
                Text("광고를 본다면 업무에서 얻은 재화만큼 더 벌 수 있습니다.")
                    .textStyle(.body)
                    .foregroundColor(.black)
                    .padding(.horizontal, Constant.Padding.messageHorizontal)
                    .padding(.bottom, Constant.Padding.messageBottom)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: Constant.Spacing.buttonHorizontal) {
                    MediumButton(title: "그냥 나가기", isFilled: true, isCancelButton: true) {
                        onLeave()
                    }

                    MediumButton(title: "보너스 받기(AD)", isFilled: true) {
                        onWatchAd()
                    }
                }
            }
        }
    }
}
