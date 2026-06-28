//
//  ShareSheetView.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 5/10/26.
//

import SwiftUI
import DUDesignSystem

enum ShareChannel: String {
    case copyLink = "copy_link"
    case kakao = "kakao"
    case osShare = "os_share"
    case unknown = "unknown"
}

struct ShareSheetView: View {
    @Binding var isPresented: Bool

    let kakaoMessageTemplateID: String
    let shareID: String
    let resultID: String
    let urlString: String
    let onLinkCopied: () -> Void

    var body: some View {
        VStack(spacing: TokenSpacing.xxl) {
            Text("공유하기")
                .duFont(.title2)
            HStack(spacing: TokenSpacing.xxl) {
                shareButton(
                    image: .shareLink,
                    title: "링크 복사",
                    action: {
                        ShareService
                            .copyLink(
                                urlString + "&entry_source=\(ShareChannel.copyLink.rawValue)",
                                onCompleted: {
                                    AnalyticsService.shared
                                        .logShareCompleted(
                                            shareID: shareID,
                                            shareChannel: ShareChannel.copyLink.rawValue,
                                            resultID: resultID,
                                            referrerShareID: shareID,
                                            referrerDeviceID: AnalyticsProperty.deviceID)
                                }
                            )
                        onLinkCopied()
                        isPresented = false
                    }
                )

                shareButton(
                    image: .shareKakao,
                    title: "카카오톡",
                    action: {
                        ShareService.shareToKakao(
                            messageTemplateID: kakaoMessageTemplateID,
                            templateArgs: [
                                "share_id": shareID,
                                "device_id": AnalyticsProperty.deviceIDValue,
                                "result_id": resultID,
                                "entry_source": ShareChannel.kakao.rawValue
                            ],
                            onCompleted: {
                                AnalyticsService.shared
                                    .logShareCompleted(
                                        shareID: shareID,
                                        shareChannel: ShareChannel.kakao.rawValue,
                                        resultID: resultID,
                                        referrerShareID: shareID,
                                        referrerDeviceID: AnalyticsProperty.deviceID)
                            }
                        )
                    }
                )

                shareButton(
                    image: .shareEtc,
                    title: "기타 공유",
                    action: {
                        ShareService
                            .defaultLinkShare(
                                urlString + "&entry_source=\(ShareChannel.osShare.rawValue)",
                                onCompleted: {
                                    AnalyticsService.shared
                                        .logShareCompleted(
                                            shareID: shareID,
                                            shareChannel: ShareChannel.osShare.rawValue,
                                            resultID: resultID,
                                            referrerShareID: shareID,
                                            referrerDeviceID: AnalyticsProperty.deviceID)
                                }
                            )
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
                action: {
                    SoundService.shared.trigger(.click)
                    isPresented = false
                }
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
        shareID: "",
        resultID: "",
        urlString: "",
        onLinkCopied: {}
    )
}
