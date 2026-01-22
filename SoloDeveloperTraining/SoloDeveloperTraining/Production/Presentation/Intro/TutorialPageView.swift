//
//  TutorialPageView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-22.
//

import SwiftUI

struct TutorialPage {
    let title: String
    let description: String
    let imageName: String?
}

struct TutorialPageView: View {
    let page: TutorialPage

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // 이미지 영역
            if let imageName = page.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300, maxHeight: 300)
            } else {
                // 임시 플레이스홀더
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.gray200)
                    .frame(width: 300, height: 300)
                    .overlay {
                        Text("이미지")
                            .foregroundColor(AppColors.gray400)
                    }
            }

            VStack(spacing: 16) {
                Text(page.title)
                    .textStyle(.largeTitle)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .textStyle(.body)
                    .foregroundColor(AppColors.gray600)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()
        }
    }
}
