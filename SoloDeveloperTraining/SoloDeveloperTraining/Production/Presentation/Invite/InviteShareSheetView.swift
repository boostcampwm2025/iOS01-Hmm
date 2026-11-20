//
//  InviteShareSheetView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/29/26.
//

import SwiftUI

import DUDesignSystem

private enum Constant {
    static let linkCopiedMessage = "링크를 복사했어요"
    static let codeCopiedMessage = "초대 코드를 복사했어요"
    static let codeNotReadyMessage = "초대 코드를 준비하고 있어요. 잠시 후 다시 시도해주세요"
    static let shareButtonSize: CGFloat = 58
}

struct InviteShareSheetView: View {
    let myCode: String

    var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            ItemLabel(text: "친구에게 보내기", font: .title2, color: .black300)

            infoCard

            HStack(alignment: .top) {
                shareButton(title: "링크 복사", action: copyLink) {
                    Image(uiImage: .shareLink)
                        .resizable()
                }
                Spacer()
                shareButton(title: "코드 복사", action: copyCode) {
                    codeCopyIcon
                }
                Spacer()
                shareButton(title: "카카오톡", action: shareToKakao) {
                    Image(uiImage: .shareKakao)
                        .resizable()
                }
                Spacer()
                shareButton(title: "기타 공유", action: shareToOthers) {
                    Image(uiImage: .shareEtc)
                        .resizable()
                }
            }
        }
        .padding(TokenSpacing.lg)
        .padding(.bottom, TokenSpacing.lg)
        .frame(maxWidth: .infinity)
        // 홈 인디케이터 영역까지 시트 배경이 이어지도록 하단 safe area 무시
        .background {
            sheetShape
                .fill(Color.white300)
                .overlay(sheetShape.stroke(Color.gray700, lineWidth: 2))
                .ignoresSafeArea(edges: .bottom)
        }
    }
}

private extension InviteShareSheetView {
    var sheetShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(topLeadingRadius: TokenRadius.lg, topTrailingRadius: TokenRadius.lg)
    }

    /// 초대 랜딩 페이지 URL
    var inviteLink: String {
        InviteLink.urlString(code: myCode)
    }

    /// 내 초대 코드가 준비됐는지 (서버에서 받기 전에는 빈 값)
    var isCodeReady: Bool {
        !myCode.isEmpty
    }

    var infoCard: some View {
        VStack(alignment: .leading, spacing: TokenSpacing.sm) {
            Text(InviteLink.inviteMessage)
                .duFont(.body)
            HStack(spacing: TokenSpacing.xs) {
                Text("초대 코드:")
                    .duFont(.body)
                Text(myCode)
                    .duFont(.subheadline)
                    .padding(.horizontal, TokenSpacing.xs)
                    .background(Color.beige300)
                    .clipShape(RoundedRectangle(cornerRadius: TokenRadius.sm))
            }
            Text(isCodeReady ? inviteLink : "")
                .duFont(.caption)
                .foregroundStyle(Color.gray400)
                .lineLimit(1)
        }
        .foregroundStyle(Color.black300)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(TokenSpacing.md)
        .background(Color.beige100)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.md))
        .overlay(RoundedRectangle(cornerRadius: TokenRadius.md).stroke(Color.beige300, lineWidth: 2))
    }

    // TODO: 전용 에셋이 나오면 이미지로 교체
    var codeCopyIcon: some View {
        ItemLabel(text: "CODE", font: .caption, color: .black300)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.beige100)
            .clipShape(RoundedRectangle(cornerRadius: TokenRadius.md))
            .overlay(RoundedRectangle(cornerRadius: TokenRadius.md).stroke(Color.gray100, lineWidth: 2))
    }

    func shareButton<Icon: View>(
        title: String,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> Icon
    ) -> some View {
        Button {
            SoundService.shared.trigger(.click)
            action()
        } label: {
            VStack(spacing: TokenSpacing.mm) {
                icon()
                    .frame(width: Constant.shareButtonSize, height: Constant.shareButtonSize)
                Text(title)
                    .duFont(.caption)
                    .foregroundStyle(Color.black300)
            }
        }
        .buttonStyle(.plain)
    }

    /// 코드가 준비되지 않았으면 안내하고 false
    func ensureCodeReady() -> Bool {
        guard isCodeReady else {
            ToastManager.shared.show(Constant.codeNotReadyMessage)
            return false
        }
        return true
    }

    /// 초대 문구 + 코드 + 랜딩 페이지 URL을 복사
    func copyLink() {
        guard ensureCodeReady() else { return }
        ShareService.copyLink(InviteLink.shareMessage(code: myCode)) {
            ToastManager.shared.show(Constant.linkCopiedMessage)
        }
    }

    func copyCode() {
        guard ensureCodeReady() else { return }
        UIPasteboard.general.string = myCode
        ToastManager.shared.show(Constant.codeCopiedMessage)
    }

    func shareToKakao() {
        // TODO: 서버 연동 - 초대 전용 템플릿 등록 후 연결 (템플릿 인자 예: invite_code)
    }

    /// 초대 문구 + 코드 + 랜딩 페이지 URL을 시스템 공유 시트로 공유
    func shareToOthers() {
        guard ensureCodeReady() else { return }
        ShareService.defaultTextShare(InviteLink.shareMessage(code: myCode), onCompleted: {})
    }
}

#Preview {
    ZStack(alignment: .bottom) {
        Color.black300.ignoresSafeArea()
        InviteShareSheetView(myCode: "ABC000")
    }
}
