//
//  ShareSheetView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 5/10/26.
//

import SwiftUI

private enum Constant {
    static let verticalSpacing: CGFloat = 20
    static let buttonHorizontalSpacing: CGFloat = 24
    static let buttonVerticalSpacing: CGFloat = 10
    static let horizontalPadding: CGFloat = 16
    static let iconSize: CGFloat = 64
    static let iconCornerRadius: CGFloat = 18
}

struct ShareSheetView: View {
    @Binding var isPresented: Bool
    @State private var isCopied = false

    let kakaoMessageTemplateID: String
    let urlString: String

    var body: some View {
        Popup(title: "SNS 공유") {
            VStack(spacing: Constant.verticalSpacing) {
                HStack(spacing: Constant.buttonHorizontalSpacing) {
                    shareButton(
                        imageName: "doc.on.doc.fill",
                        title: "링크 복사",
                        action: {
                            ShareService.copyLink(urlString)
                            isCopied = true
                        }
                    )

                    shareButton(
                        imageName: "message.fill",
                        title: "카카오톡",
                        action: {
                            ShareService
                                .shareToKakao(
                                    messageTemplateID: kakaoMessageTemplateID
                                )
                        }
                    )

                    shareButton(
                        imageName: "ellipsis.circle.fill",
                        title: "기타 공유",
                        action: {
                            ShareService.defaultLinkShare(urlString)
                        }
                    )
                }
            }
            closeButton
        }
        .padding(.horizontal, Constant.horizontalPadding)
        .toast(isShowing: $isCopied, message: "링크가 복사되었습니다.")
    }
}

private extension ShareSheetView {
    var closeButton: some View {
        HStack {
            Spacer()
            MediumButton(title: "닫기", isFilled: true) {
                isPresented = false
            }
            Spacer()
        }
    }

    func shareButton(
        imageName: String,
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        return Button(action: action) {
            VStack(spacing: Constant.buttonVerticalSpacing) {
                RoundedRectangle(cornerRadius: Constant.iconCornerRadius)
                    .fill(Color.gray.opacity(0.15))
                    .frame(
                        width: Constant.iconSize,
                        height: Constant.iconSize
                    )
                    .overlay {
                        Image(systemName: imageName)
                            .font(.body)
                            .foregroundStyle(.black)
                    }
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.black)
            }
        }
    }
}
