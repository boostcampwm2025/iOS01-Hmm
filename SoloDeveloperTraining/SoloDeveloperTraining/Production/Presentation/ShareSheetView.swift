//
//  ShareSheetView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 5/10/26.
//

import SwiftUI
import DUDesignSystem

struct ShareSheetView: View {
    @Binding var isPresented: Bool
    @State private var isCopied = false

    let kakaoMessageTemplateID: String
    let urlString: String

    var body: some View {
        VStack(spacing: TokenSpacing.xxl) {
            Text("공유하기")
                .duFont(.title2)
            HStack(spacing: TokenSpacing.xxl) {
                shareButton(
                    image: .shareLink,
                    title: "링크 복사",
                    action: {
                        ShareService.copyLink(urlString)
                        isCopied = true
                    }
                )

                shareButton(
                    image: .shareKakao,
                    title: "카카오톡",
                    action: {
                        ShareService
                            .shareToKakao(
                                messageTemplateID: kakaoMessageTemplateID
                            )
                    }
                )

                shareButton(
                    image: .shareEtc,
                    title: "기타 공유",
                    action: {
                        ShareService.defaultLinkShare(urlString)
                    }
                )
            }
            closeButton
        }
        .padding(.all, TokenSpacing.lg)
        .background(Color.white300)
        .cornerRadius(TokenRadius.lg)
        .overlay {
            RoundedRectangle(cornerRadius: TokenRadius.lg)
                .stroke(Color.gray700, lineWidth: 2)
        }
        .darkToast(isShowing: $isCopied, message: "링크가 복사되었습니다.")
    }
}

private extension ShareSheetView {
    var closeButton: some View {
        HStack {
            Spacer()
            TextButton(
                text: "닫기",
                type: .primary,
                size: .medium,
                action: { isPresented = false }
            )
            Spacer()
        }
    }

    func shareButton(
        image: UIImage,
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        return Button(action: action) {
            VStack(spacing: TokenSpacing.mm) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 58, height: 58)
                Text(title)
                    .duFont(.caption)
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    @Previewable @State var bindingIsPresented: Bool = true
    ShareSheetView(
        isPresented: $bindingIsPresented,
        kakaoMessageTemplateID: "",
        urlString: ""
    )
}
