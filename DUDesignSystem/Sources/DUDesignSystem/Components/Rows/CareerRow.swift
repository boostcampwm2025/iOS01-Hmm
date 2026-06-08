//
//  CareerRow.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/8/26.
//

import SwiftUI

public struct CareerRow: View {

    public enum CareerRowState {
        case achieved
        case current
        case upcoming
    }

    public var imageName: String
    public var title: String
    public var description: String
    public var state: CareerRowState

    public init(
        imageName: String,
        title: String,
        description: String,
        state: CareerRowState
    ) {
        self.imageName = imageName
        self.title = title
        self.description = description
        self.state = state
    }

    private var textColor: Color {
        state == .achieved ? Color.gray200 : Color.black300
    }

    public var body: some View {
        HStack(alignment: .center, spacing: TokenSpacing.sm) {
            Image(imageName, bundle: .module)
                .resizable()
                .scaledToFill()
                .frame(width: 44, height: 44)
                .background(Color.black)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    Text(title)
                        .duFont(.subheadline)
                        .foregroundStyle(textColor)
                    Spacer()
                    if state == .achieved {
                        Text("완료")
                            .duFont(.label)
                            .foregroundStyle(Color.gray200)
                    }
                }
                Text(description)
                    .duFont(.label)
                    .foregroundStyle(textColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    VStack(spacing: TokenSpacing.sm) {
        CareerRow(imageName: "", title: "백수", description: "아직 아무것도 시작하지 않았지만, 시간은 가장 많다", state: .achieved)
        CareerRow(imageName: "", title: "백수", description: "아직 아무것도 시작하지 않았지만, 시간은 가장 많다", state: .current)
        CareerRow(imageName: "", title: "백수", description: "아직 아무것도 시작하지 않았지만, 시간은 가장 많다", state: .upcoming)
    }
    .padding(TokenSpacing.md)
    .background(Color.beige200)
}
