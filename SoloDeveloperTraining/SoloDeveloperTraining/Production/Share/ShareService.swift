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

        let activityVC = UIActivityViewController(
            activityItems: [shareURL],
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

    static func shareToKakao(messageTemplateID: String, templateArgs: [String: String], onCompleted: @escaping () -> Void) {
        guard let templateID = Int64(messageTemplateID) else {
            print("❌ 잘못된 카카오 템플릿 ID: \(messageTemplateID)")
            return
        }

        if ShareApi.isKakaoTalkSharingAvailable() {
            ShareApi.shared.shareCustom(templateId: templateID, templateArgs: templateArgs) { (sharingResult, error) in
                if let error = error {
                    print("❌ 카카오 공유 실패: \(error)")
                } else if let sharingResult = sharingResult {
                    UIApplication.shared.open(sharingResult.url)
                    onCompleted()
                }
            }
        } else {
            if let url = ShareApi.shared.makeCustomUrl(templateId: templateID, templateArgs: templateArgs) {
                UIApplication.shared.open(url)
                onCompleted()
            }
        }
    }

}
