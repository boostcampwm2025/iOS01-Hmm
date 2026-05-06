//
//  AdView.swift
//  SoloDeveloperTraining-Dev
//
//  Created by sunjae on 5/6/26.
//

import SwiftUI

struct AdView: View {
    var body: some View {
        List {
            Section(header: Text("광고 테스트")) {
                Button("전면 광고 노출") {
                    AdService.shared.showAd(.interstitial)
                }
            }
        }
        .task {
            await AdService.shared.loadAd(.interstitial)
        }
    }
}
