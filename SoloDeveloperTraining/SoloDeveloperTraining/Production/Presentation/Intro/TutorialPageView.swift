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
        static let cornerRadius: CGFloat = 4
        static let strokeWidth: CGFloat = 2
    }

    enum Layout {
        static let textHorizontalPadding: CGFloat = 40
    }
}

struct TutorialPage {
    let title: String
    let description: String
    let imageName: ImageResource
}

struct TutorialPageView: View {
    let page: TutorialPage

    var body: some View {
        VStack(spacing: Constant.Spacing.content) {
            textGroup
            imageView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, Constant.Size.strokeWidth)
        }
    }
}

private extension TutorialPageView {
    var imageView: some View {
        Image(page.imageName)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: Constant.Size.cornerRadius)
                    .stroke(.black, lineWidth: Constant.Size.strokeWidth)
            }
    }

    var textGroup: some View {
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
    }
}
