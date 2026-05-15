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

    static func copyLink(urlString: String) {
        UIPasteboard.general.string = urlString
    }

    static func shareToInstagram(urlString: String) {
        // 인스타그램 공유 구현 (필요시 추가)
    }

    static func shareToKakao(messageTemplateID: String) {
        guard let templateId = Int64(messageTemplateID) else {
            print("❌ 잘못된 카카오 템플릿 ID: \(messageTemplateID)")
            return
        }

        if ShareApi.isKakaoTalkSharingAvailable() {
            ShareApi.shared.shareCustom(templateId: templateId) { (sharingResult, error) in
                if let error = error {
                    print("❌ 카카오 공유 실패: \(error)")
                } else if let sharingResult = sharingResult {
                    UIApplication.shared.open(sharingResult.url)
                }
            }
        } else {
            // 카카오톡 미설치 시 웹 브라우저 공유
            if let url = ShareApi.shared.makeCustomUrl(templateId: templateId) {
                UIApplication.shared.open(url)
            }
        }
    }
}
