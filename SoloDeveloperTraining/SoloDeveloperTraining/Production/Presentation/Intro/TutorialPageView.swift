//
//  TutorialPageView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-22.
//

import SwiftUI

struct TutorialPage {
    let imageName: ImageResource
}

struct TutorialPageView: View {
    let page: TutorialPage

    var body: some View {
        Image(page.imageName)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}
