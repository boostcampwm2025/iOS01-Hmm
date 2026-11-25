//
//  ShareService.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 5/12/26.
//

import UIKit
import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon

enum ShareService {
    static let baseURL = "https://solodevelopertraining.web.app"

    static func copyLink(_ urlString: String, onCompleted: () -> Void) {
        UIPasteboard.general.string = urlString
        onCompleted()
    }

    static func defaultLinkShare(_ urlString: String, onCompleted: @escaping () -> Void) {
        guard let shareURL = URL(string: urlString) else { return }
        presentActivitySheet(activityItems: [shareURL], onCompleted: onCompleted)
    }

    /// 문구(링크 포함)를 시스템 공유 시트로 공유
    static func defaultTextShare(_ text: String, onCompleted: @escaping () -> Void) {
        presentActivitySheet(activityItems: [text], onCompleted: onCompleted)
    }

    static func shareToKakao(messageTemplateID: String, templateArgs: [String: String], onCompleted: @escaping () -> Void) {
        guard let templateID = Int64(messageTemplateID) else {
            print("❌ 잘못된 카카오 템플릿 ID: \(messageTemplateID)")
            return
        }

        func openShareURL(_ url: URL) {
            UIApplication.shared.open(url) { opened in
                if opened { onCompleted() }
            }
        }

        if ShareApi.isKakaoTalkSharingAvailable() {
            ShareApi.shared.shareCustom(templateId: templateID, templateArgs: templateArgs) { (sharingResult, error) in
                if let error = error {
                    print("❌ 카카오 공유 실패: \(error)")
                } else if let sharingResult = sharingResult {
                    openShareURL(sharingResult.url)
                }
            }
        } else {
            if let url = ShareApi.shared.makeCustomUrl(templateId: templateID, templateArgs: templateArgs) {
                openShareURL(url)
            }
        }
    }

}

private extension ShareService {
    /// 최상단 화면 위에 시스템 공유 시트를 띄운다.
    static func presentActivitySheet(activityItems: [Any], onCompleted: @escaping () -> Void) {
        let activityVC = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )

        activityVC.completionWithItemsHandler = { _, completed, _, error in
            if let error {
                print("❌ 기본 시트 공유 실패: \(error)")
                return
            }

            guard completed else { return }
            onCompleted()
        }

        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else { return }

        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }

        topVC.present(activityVC, animated: true)
    }
}
