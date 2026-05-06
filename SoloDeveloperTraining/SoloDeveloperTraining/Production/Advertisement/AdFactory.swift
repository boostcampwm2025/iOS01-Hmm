//
//  AdFactory.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 5/6/26.
//


protocol AdFactory {
    func makeAdUnit(for type: AdType) -> AdUnit
}

final class DefaultAdFactory: AdFactory {
    func makeAdUnit(for type: AdType) -> AdUnit {
        switch type {
        case .interstitial:
            return InterstitialAdUnit()
        }
    }
}