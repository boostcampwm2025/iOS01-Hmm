//
//  SoundType.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import Foundation

enum SoundType: String {
    case success
    case failure
    /// 버튼 탭 시 재생
    case tap

    var url: URL? {
        switch self {
        default:
            Bundle.main.url(
                forResource: self.rawValue,
                withExtension: "wav"
            )
        }
    }
}
