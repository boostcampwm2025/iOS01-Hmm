//
//  TutorialPageView.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-22.
//

import SwiftUI

private enum Constant {
    enum Spacing {
        static let content: CGFloat = 30
        static let textGroup: CGFloat = 16
    }

    enum Size {
        static let imageMaxWidth: CGFloat = 300
        static let imageMaxHeight: CGFloat = 300
        static let placeholderWidth: CGFloat = 300
        static let placeholderHeight: CGFloat = 300
        static let cornerRadius: CGFloat = 20
    }

    enum Layout {
        static let textHorizontalPadding: CGFloat = 40
    }
}

struct TutorialPage {
    let title: String
    let description: String
    let imageName: String?
}

struct TutorialPageView: View {
    let page: TutorialPage

    var body: some View {
        VStack(spacing: Constant.Spacing.content) {
            Spacer()

            // 이미지 영역
            if let imageName = page.imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: Constant.Size.imageMaxWidth, maxHeight: Constant.Size.imageMaxHeight)
            } else {
                // 임시 플레이스홀더
                RoundedRectangle(cornerRadius: Constant.Size.cornerRadius)
                    .fill(AppColors.gray200)
                    .frame(width: Constant.Size.placeholderWidth, height: Constant.Size.placeholderHeight)
                    .overlay {
                        Text("이미지")
                    }
            }

            VStack(spacing: Constant.Spacing.textGroup) {
                Text(page.title)
                    .textStyle(.largeTitle)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .textStyle(.body)
                    .foregroundColor(AppColors.gray600)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Constant.Layout.textHorizontalPadding)
            }

            Spacer()
        }
    }
}
