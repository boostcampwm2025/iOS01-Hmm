//
//  ShareService.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 5/12/26.
//

import UIKit

enum ShareService {
    static func copyLink(urlString: String) {
        UIPasteboard.general.string = urlString
    }

    static func shareToKakao(urlString: String) {

    }

    static func shareToInstagram(urlString: String) {

    }
}
