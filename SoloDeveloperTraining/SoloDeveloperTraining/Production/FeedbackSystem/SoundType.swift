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
