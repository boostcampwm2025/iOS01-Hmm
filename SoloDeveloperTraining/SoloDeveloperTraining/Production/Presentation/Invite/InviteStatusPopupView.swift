//
//  InviteStatusPopupView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/29/26.
//

import SwiftUI

import DUDesignSystem

private enum Constant {
    static let emptyText = "아직 초대한 친구가 없어요"
    static let listMaxHeight: CGFloat = 240
}

struct InviteStatusPopupView: View {
    @State private var friendRowsHeight: CGFloat = 0

    let inviteSystem: InviteSystem
    let onClaim: (InvitedFriend) -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            ItemLabel(text: "초대 현황", font: .title2, color: .black300)

            summary

            friendList

            TextButton(text: "닫기", type: .secondary, size: .large) {
                SoundService.shared.trigger(.click)
                onClose()
            }
        }
        .padding(TokenSpacing.lg)
        .background(Color.white300)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: TokenRadius.lg).stroke(Color.gray700, lineWidth: 2))
        .padding(.horizontal, TokenGrid.marginPopUp)
    }
}

private extension InviteStatusPopupView {
    // MARK: - 요약

    var summary: some View {
        HStack(spacing: TokenSpacing.sm) {
            summaryCard(title: "초대 완료") {
                ItemLabel(text: "\(inviteSystem.invitedCount)명", font: .headline, color: .black300)
            }
            summaryCard(title: "받은 다이아") {
                ItemLabel(
                    text: "\(inviteSystem.claimedDiamond)",
                    icon: .diamond,
                    iconSize: .size24,
                    font: .headline,
                    color: .black300
                )
            }
        }
    }

    func summaryCard<Value: View>(title: String, @ViewBuilder value: () -> Value) -> some View {
        VStack(alignment: .leading, spacing: TokenSpacing.xs) {
            ItemLabel(text: title, font: .label, color: .gray400)
            value()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(TokenSpacing.md)
        .background(Color.beige100)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.md))
        .overlay(RoundedRectangle(cornerRadius: TokenRadius.md).stroke(Color.beige300, lineWidth: 2))
    }

    // MARK: - 친구 목록

    @ViewBuilder
    var friendList: some View {
        if inviteSystem.invitedFriends.isEmpty {
            ItemLabel(text: Constant.emptyText, font: .body, color: .gray400)
                .padding(.vertical, TokenSpacing.lg)
        } else {
            // 목록이 짧으면 내용 높이만큼, 길면 최대 높이 안에서 스크롤
            ScrollView {
                friendRows
                    .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { height in
                        friendRowsHeight = height
                    }
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            .frame(height: min(friendRowsHeight, Constant.listMaxHeight))
        }
    }

    var friendRows: some View {
        VStack(spacing: TokenSpacing.none) {
            ForEach(inviteSystem.invitedFriends) { friend in
                friendRow(friend)
                Rectangle()
                    .fill(Color.beige300)
                    .frame(height: 1)
            }
        }
    }

    func friendRow(_ friend: InvitedFriend) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: TokenSpacing.xx) {
                Text(friend.nickname)
                    .duFont(.subheadline)
                    .foregroundStyle(Color.black300)
                Text(friend.invitedAt.formatted(.dateTime.year().month().day()))
                    .duFont(.caption)
                    .foregroundStyle(Color.gray400)
            }
            Spacer()
            claimButton(friend)
        }
        .padding(.vertical, TokenSpacing.mm)
    }

    /// 수령 대기: 수령 버튼 / 수령 완료: 비활성
    func claimButton(_ friend: InvitedFriend) -> some View {
        TextButton(
            text: friend.isRewardClaimed ? "수령 완료" : "수령",
            type: .primary,
            size: .small,
            state: friend.isRewardClaimed ? .disabled : .default
        ) {
            SoundService.shared.trigger(.click)
            onClaim(friend)
        }
    }
}

#Preview {
    ZStack {
        Color.black300.ignoresSafeArea()
        InviteStatusPopupView(inviteSystem: InviteSystem(), onClaim: { _ in }, onClose: {})
    }
}
