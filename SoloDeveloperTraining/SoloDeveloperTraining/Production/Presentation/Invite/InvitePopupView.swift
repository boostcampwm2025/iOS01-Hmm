//
//  InvitePopupView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/29/26.
//

import SwiftUI

import DUDesignSystem

private enum Constant {
    static let copiedMessage = "초대 코드를 복사했어요"
}

struct InvitePopupView: View {
    let myCode: String
    let invitedCount: Int
    let onInvite: () -> Void
    let onShowStatus: () -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            ItemLabel(text: "친구 초대", font: .title2, color: .black300)
            ItemLabel(
                text: "친구가 내 코드를 입력하면\n한 명당 다이아 \(InviteConstants.inviterRewardDiamond)개를 받아요.",
                font: .body,
                color: .gray400
            )

            codeCard

            VStack(spacing: TokenSpacing.md) {
                TextButton(text: "친구 초대하기", type: .primary, size: .large) {
                    SoundService.shared.trigger(.click)
                    onInvite()
                }
                statusButton
                TextButton(text: "닫기", type: .secondary, size: .large) {
                    SoundService.shared.trigger(.click)
                    onClose()
                }
            }
        }
        .padding(TokenSpacing.lg)
        .background(Color.white300)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: TokenRadius.lg).stroke(Color.gray700, lineWidth: 2))
        .padding(.horizontal, TokenGrid.marginPopUp)
    }
}

private extension InvitePopupView {
    var codeCard: some View {
        VStack(alignment: .leading, spacing: TokenSpacing.sm) {
            ItemLabel(text: "내 초대 코드", font: .label, color: .gray400)
            HStack {
                ItemLabel(text: myCode, font: .title1, color: .black300)
                Spacer()
                TextButton(text: "코드 복사", type: .primary, size: .small) {
                    SoundService.shared.trigger(.click)
                    copyCode()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(TokenSpacing.md)
        .background(Color.beige100)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.md))
        .overlay(RoundedRectangle(cornerRadius: TokenRadius.md).stroke(Color.beige300, lineWidth: 2))
    }

    var statusButton: some View {
        Button {
            SoundService.shared.trigger(.click)
            onShowStatus()
        } label: {
            HStack(spacing: TokenSpacing.xs) {
                Text("초대 현황")
                    .duFont(.subheadline)
                Text("\(invitedCount)명")
                    .duFont(.body)
                Spacer()
            }
            .foregroundStyle(Color.black300)
            .padding(.horizontal, TokenSpacing.md)
            .padding(.vertical, TokenSpacing.md)
            .frame(maxWidth: .infinity)
            .background(Color.white300)
            .clipShape(RoundedRectangle(cornerRadius: TokenRadius.md))
            .overlay(RoundedRectangle(cornerRadius: TokenRadius.md).stroke(Color.beige300, lineWidth: 2))
        }
        .buttonStyle(.plain)
    }

    func copyCode() {
        UIPasteboard.general.string = myCode
        ToastManager.shared.show(Constant.copiedMessage)
    }
}

#Preview {
    ZStack {
        Color.black300.ignoresSafeArea()
        InvitePopupView(
            myCode: "ABC000",
            invitedCount: 3,
            onInvite: {},
            onShowStatus: {},
            onClose: {}
        )
    }
}
