//
//  CareerRow.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/15/26.
//

import SwiftUI

private enum Constant {
    static let imageSize: CGSize = .init(width: 49, height: 49)
    static let cornerRadius: CGFloat = 4
    enum Spacing {
        static let horizontal: CGFloat = 8
        static let vertical: CGFloat = 4
    }
}

struct CareerRow: View {

    let title: String
    let description: String
    let imageName: String

    var body: some View {
        HStack(spacing: Constant.Spacing.horizontal) {
            Image(imageName)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: Constant.cornerRadius))
                .frame(width: Constant.imageSize.width, height: Constant.imageSize.height)
            VStack(alignment: .leading, spacing: Constant.Spacing.vertical) {
                Text(title)
                    .foregroundStyle(.black)
                    .textStyle(.subheadline)
                Text(description)
                    .foregroundStyle(.black)
                    .textStyle(.label)
            }
            Spacer()
        }
    }
}

#Preview {
    VStack {
        CareerRow(
            title: "백수1",
            description: "아무것도 시작하지 않았지만, 시간은 가장 많다.",
            imageName: "housing_street"
        )
        CareerRow(
            title: "백수2",
            description: "아무것도 시작하지 않았지만, 시간은 가장 많다.",
            imageName: "housing_street"
        )
        CareerRow(
            title: "백수3",
            description: "아무것도 시작하지 않았지만, 시간은 가장 많다.",
            imageName: "housing_street"
        )
    }
    .padding(.horizontal)
}
